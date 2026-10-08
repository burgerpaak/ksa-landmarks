// Run: node --experimental-vm-modules --test tests/comment-store.test.mjs
// Exercise the production module with a controlled Firebase SDK transport.
import {test} from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';

async function setup(uid = 'author-a') {
  const records = new Map();
  const auth = {currentUser: uid ? {uid} : null, authStateReady: async () => {}};
  let authListener, failure;
  const stamp = () => ({toDate: () => new Date('2026-10-01T12:00:00Z'), toMillis: () => 1790856000000});
  const snapshot = ref => ({id: ref.split('/').at(-1), exists: () => records.has(ref), data: () => records.get(ref)});
  const sdk = {
    getFirestore: () => ({}), doc: (_, ...segments) => segments.join('/'),
    collection: (_, ...segments) => segments.join('/'),
    getCount: async ref => {
      if (failure) throw failure;
      return {data: () => ({count: [...records.keys()].filter(path => path.startsWith(ref + '/')).length})};
    },
    getDoc: async ref => snapshot(ref), serverTimestamp: stamp,
    runTransaction: async (_, run) => {
      const writes = [];
      await run({get: async ref => snapshot(ref),
        update: (ref, changes) => writes.push(() => records.set(ref, {...records.get(ref), ...changes})),
        delete: ref => writes.push(() => records.delete(ref))});
      if (failure) throw failure;
      writes.forEach(write => write());
    },
  };
  const exports = {
    'firebase-app.js': {initializeApp: () => ({})},
    'firebase-auth.js': {getAuth: () => auth, onAuthStateChanged: (_, fn) => {authListener = fn; fn(auth.currentUser);}},
    'firebase-firestore-lite.js': sdk,
  };
  const context = vm.createContext({setTimeout, Date, console});
  const module = new vm.SourceTextModule(await readFile(new URL('../assets/research-comment-store.js', import.meta.url), 'utf8'), {
    context, importModuleDynamically: async specifier => {
      const values = exports[specifier.split('/').at(-1)];
      const dependency = new vm.SyntheticModule(Object.keys(values), function () {
        Object.entries(values).forEach(([key, value]) => this.setExport(key, value));
      }, {context});
      await dependency.link(() => {}); await dependency.evaluate(); return dependency;
    },
  });
  await module.link(() => {}); await module.evaluate();
  const store = module.namespace.createCommentStore({apiKey:'public',projectId:'test',appId:'test'});
  const path = 'landmarkComments/N02/comments/one';
  records.set(path, {author:'Same name',body:'Original',authorId:'author-a',createdAt:stamp()});
  return {store,records,path,auth,stamp,changeUser: next => {auth.currentUser = next ? {uid:next} : null; authListener(auth.currentUser);}, fail: error => {failure=error;}};
}

test('author can edit body while retaining author, ID and creation time', async () => {
  const {store,records,path} = await setup();
  const before = records.get(path);
  const result = await store.edit('N02','one','Revised');
  assert.equal(result.text,'Revised'); assert.equal(result.authorId,'author-a');
  assert.equal(result.id,'one'); assert.ok(result.updatedAt);
  assert.equal(records.get(path).author,before.author);
  assert.equal(records.get(path).createdAt,before.createdAt);
});

test('filter counts include unseen cards and do not read or modify comment bodies', async () => {
  const {store,records,path,stamp} = await setup(null);
  records.set('landmarkComments/N36/comments/two', {author:'B',body:'Distant card',authorId:'b',createdAt:stamp()});
  assert.equal(await store.count('N02'), 1);
  assert.equal(await store.count('N36'), 1);
  assert.equal(await store.count('N34'), 0);
  assert.equal(records.get(path).body, 'Original');
  assert.equal(records.size, 2);
});

test('count failures reject so an incomplete filter cannot silently omit cards', async () => {
  const {store,fail} = await setup();
  fail(Object.assign(new Error('denied'), {code:'permission-denied'}));
  await assert.rejects(store.count('N36'), {code:'permission-denied'});
});

test('same display name does not give another anonymous identity ownership', async () => {
  const {store,records,path} = await setup('author-b');
  await assert.rejects(store.edit('N02','one','Hijack'), {code:'comment-not-owner'});
  await assert.rejects(store.remove('N02','one'), {code:'comment-not-owner'});
  assert.equal(store.owns({author:'Same name',authorId:'author-a'}),false);
  assert.equal(records.get(path).body,'Original');
});

test('missing browser session cannot edit or delete', async () => {
  const {store} = await setup(null);
  await assert.rejects(store.edit('N02','one','Revised'), {code:'comment-not-owner'});
  await assert.rejects(store.remove('N02','one'), {code:'comment-not-owner'});
});

test('owner deletion is idempotent and a deleted comment cannot be edited', async () => {
  const {store,records,path} = await setup();
  await store.remove('N02','one'); assert.equal(records.has(path),false);
  await store.remove('N02','one');
  await assert.rejects(store.edit('N02','one','Recreate'), {code:'comment-not-found'});
  assert.equal(records.has(path),false);
});

test('server denial leaves stored content intact and rejects both operations', async () => {
  const {store,records,path,fail} = await setup();
  fail(Object.assign(new Error('denied'), {code:'permission-denied'}));
  await assert.rejects(store.edit('N02','one','Denied'), {code:'permission-denied'});
  await assert.rejects(store.remove('N02','one'), {code:'permission-denied'});
  assert.equal(records.get(path).body,'Original');
});

test('ownership is restored and revoked when the anonymous session changes', async () => {
  const {store,changeUser} = await setup();
  let changes = 0; store.onViewerChange(() => changes++);
  const saved = await store.edit('N02','one','Revised');
  assert.equal(store.owns(saved),true);
  changeUser('author-b'); assert.equal(store.owns(saved),false);
  changeUser('author-a'); assert.equal(store.owns(saved),true);
  assert.equal(changes,3);
});
