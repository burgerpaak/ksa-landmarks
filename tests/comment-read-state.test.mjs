import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
const source = await readFile(new URL('../assets/research-comment-read-state.js', import.meta.url), 'utf8');
const {createCommentReadState, commentStamp} = await import(`data:text/javascript;base64,${Buffer.from(source).toString('base64')}`);
const stamp = (seconds, nanoseconds = 0) => ({seconds, nanoseconds});
function browser() {
  let stored = null;
  return {open: () => createCommentReadState({read: () => stored, write: value => {stored = value;}}),
    inspect: () => JSON.parse(stored)};
}
test('first visit starts with existing comments and empty cards as read baselines', () => {
  const storage = browser(), first = storage.open();
  first.observe('N02', stamp(100)); first.observe('J01', null);
  assert.equal(first.hasUnread('N02'), false); assert.equal(first.hasUnread('J01'), false);
  assert.deepEqual(storage.inspect(), {N02:stamp(100), J01:stamp(0)});
  const next = storage.open(); next.observe('J01', stamp(101));
  assert.equal(next.hasUnread('J01'), true);
});
test('refresh and partial reading preserve unread state until the latest body is seen', () => {
  const storage = browser(), first = storage.open(); first.observe('N02', stamp(100));
  const next = storage.open(); next.observe('N02', stamp(103)); next.markSeen('N02', stamp(102));
  assert.equal(next.hasUnread('N02'), true);
  const reloaded = storage.open(); reloaded.observe('N02', stamp(103));
  assert.equal(reloaded.hasUnread('N02'), true);
  reloaded.markSeen('N02', stamp(103)); assert.equal(reloaded.hasUnread('N02'), false);
  const afterReading = storage.open(); afterReading.observe('N02', stamp(103));
  assert.equal(afterReading.hasUnread('N02'), false);
  afterReading.observe('N02', stamp(104)); assert.equal(afterReading.hasUnread('N02'), true);
});
test('editing does not trigger updates, and same-count replacement still detects a new registration', () => {
  const state = browser().open(); state.observe('N02', stamp(100));
  state.observe('N02', commentStamp({createdStamp:stamp(100), updatedAt:'2026-10-08T12:00:00Z'}));
  assert.equal(state.hasUnread('N02'), false);
  state.observe('N02', stamp(101)); assert.equal(state.hasUnread('N02'), true);
  state.observe('N02', stamp(100)); assert.equal(state.hasUnread('N02'), false);
  state.observe('N02', null); assert.equal(state.hasUnread('N02'), false);
});
test('timestamps in the same millisecond are distinct; read markers never move backwards', () => {
  const state = browser().open(); state.observe('N02', stamp(100, 100001));
  state.observe('N02', stamp(100, 100002)); assert.equal(state.hasUnread('N02'), true);
  state.markSeen('N02', stamp(100, 100002)); state.markSeen('N02', stamp(99));
  assert.equal(state.hasUnread('N02'), false);
});
test('other browser tabs merge read markers without overwriting newer values', () => {
  const storage = browser(), a = storage.open(); a.observe('N02', stamp(100));
  const b = storage.open(); a.observe('N02', stamp(101)); b.observe('N02', stamp(101));
  a.markSeen('N02', stamp(101)); b.sync(); assert.equal(b.hasUnread('N02'), false);
  b.observe('J01', stamp(99));
  assert.deepEqual(storage.inspect().N02, stamp(101));
});
test('unavailable and malformed storage fall back to current-page tracking', () => {
  for (const read of [() => {throw Error('blocked');}, () => '{invalid', () => 'null']) {
    const state = createCommentReadState({read, write: () => {throw Error('blocked');}});
    state.observe('N02', stamp(100)); state.observe('N02', stamp(101));
    assert.equal(state.hasUnread('N02'), true); state.markSeen('N02', stamp(101));
    assert.equal(state.hasUnread('N02'), false);
  }
});
