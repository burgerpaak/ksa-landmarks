// Run against the local demo emulator only; never a production project.
import test from 'node:test';
import assert from 'node:assert/strict';
const host = process.env.FIRESTORE_EMULATOR_HOST;
if (!host || !/^(127\.0\.0\.1|localhost):\d+$/.test(host)) throw new Error('Set FIRESTORE_EMULATOR_HOST to a local emulator.');
const project = 'demo-ksa-comments';
const base = `http://${host}/v1/projects/${project}/databases/(default)/documents`;
const name = id => `projects/${project}/databases/(default)/documents/landmarkComments/N99/comments/${id}`;
const str = stringValue => ({stringValue});
function token(uid) {
 const now = Math.floor(Date.now()/1000);
 const encode = data => Buffer.from(JSON.stringify(data)).toString('base64url');
 return `${encode({alg:'none',typ:'JWT'})}.${encode({aud:project,iss:`https://securetoken.google.com/${project}`,sub:uid,user_id:uid,iat:now,exp:now+3600,auth_time:now,firebase:{sign_in_provider:'anonymous'}})}.`;
}
async function request(path, uid, body, method='POST') {
 const headers = {'Content-Type':'application/json'};
 if (uid) headers.Authorization = `Bearer ${uid === 'owner' ? 'owner' : token(uid)}`;
 const response = await fetch(base+path,{method,headers,body:body && JSON.stringify(body)});
 const data = await response.json();
 return {status:response.status,data};
}
async function seed(id) {
 const result=await request(':commit','owner',{writes:[{update:{name:name(id),fields:{author:str('디자인팀'),body:str('원래 본문'),authorId:str('writer-a'),createdAt:{timestampValue:'2026-10-01T00:00:00Z'}}}}]});
 assert.equal(result.status,200);
}
function edit(id, body, extra={}, timestamp=true) {
 return {writes:[{update:{name:name(id),fields:{body:str(body),...extra}},updateMask:{fieldPaths:['body',...Object.keys(extra)]},...(timestamp?{updateTransforms:[{fieldPath:'updatedAt',setToServerValue:'REQUEST_TIME'}]}:{})}]};
}
async function denied(result) { assert.equal(result.status,403,JSON.stringify(result.data)); }
test('owner can update body with server timestamp; author metadata stays intact',async()=>{
 await seed('owner-edit');
 assert.equal((await request(':commit','writer-a',edit('owner-edit','수정 본문'))).status,200);
 const result=await request('/landmarkComments/N99/comments/owner-edit',null,null,'GET');
 assert.equal(result.data.fields.body.stringValue,'수정 본문');
 assert.equal(result.data.fields.authorId.stringValue,'writer-a');
 assert.equal(result.data.fields.createdAt.timestampValue,'2026-10-01T00:00:00Z');
 assert.ok(result.data.fields.updatedAt.timestampValue);
});
test('anonymous and other writer cannot edit or delete',async()=>{
 await seed('foreign');
 for(const uid of [null,'writer-b']){
  await denied(await request(':commit',uid,edit('foreign','변경')));
  await denied(await request(':commit',uid,{writes:[{delete:name('foreign')}]}));
 }
});
test('owner cannot change identity, author, creation time or add fields',async()=>{
 await seed('immutable');
 for(const extra of [{authorId:str('writer-b')},{author:str('다른 이름')},{createdAt:{timestampValue:'2026-09-01T00:00:00Z'}},{unexpected:str('추가')}]) {
  await denied(await request(':commit','writer-a',edit('immutable','변경',extra)));
 }
});
test('empty, whitespace, oversized body and missing timestamp are rejected',async()=>{
 await seed('invalid');
 for(const body of ['', ' \n\t ', 'x'.repeat(1001)]) await denied(await request(':commit','writer-a',edit('invalid',body)));
 await denied(await request(':commit','writer-a',edit('invalid','변경',{},false)));
});
test('owner can delete their own comment',async()=>{
 await seed('delete-own');
 assert.equal((await request(':commit','writer-a',{writes:[{delete:name('delete-own')}]})).status,200);
 assert.equal((await request('/landmarkComments/N99/comments/delete-own',null,null,'GET')).status,404);
});
test('paired comment create still works and cooldown remains enforced',async()=>{
 const uid=`fresh-writer-${crypto.randomUUID()}`;
 function posting(id){return {writes:[
 {update:{name:name(id),fields:{author:str('작성자'),body:str('코멘트'),authorId:str(uid)}},updateTransforms:[{fieldPath:'createdAt',setToServerValue:'REQUEST_TIME'}]},
 {update:{name:`projects/${project}/databases/(default)/documents/commentWriters/${uid}`,fields:{lastCommentId:str(id),lastLandmarkId:str('N99')}},updateTransforms:[{fieldPath:'lastCreatedAt',setToServerValue:'REQUEST_TIME'}]}
 ]};}
 assert.equal((await request(':commit',uid,posting(`new-${uid}`))).status,200);
 await denied(await request(':commit',uid,posting(`too-soon-${uid}`)));
});
