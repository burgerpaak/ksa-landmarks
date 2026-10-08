// Store only per-card read timestamps in this browser, never comment bodies.
const zero = {seconds: 0, nanoseconds: 0};
function stamp(value) {
  if (!value || !Number.isSafeInteger(value.seconds) || value.seconds < 0 ||
      !Number.isInteger(value.nanoseconds) || value.nanoseconds < 0 || value.nanoseconds >= 1e9) return null;
  return {seconds: value.seconds, nanoseconds: value.nanoseconds};
}
function compare(a, b) {
  return a.seconds - b.seconds || a.nanoseconds - b.nanoseconds;
}
export function commentStamp(comment) {
  if (stamp(comment?.createdStamp)) return stamp(comment.createdStamp);
  const millis = Date.parse(comment?.createdAt);
  return Number.isFinite(millis) ? {seconds: Math.floor(millis / 1000), nanoseconds: (millis % 1000) * 1e6} : null;
}
export function createCommentReadState({read = () => null, write = () => {}} = {}) {
  const seen = new Map(), latest = new Map();
  function sync() {
    try {
      const saved = JSON.parse(read() || '{}');
      for (const [id, value] of Object.entries(saved)) {
        const valid = stamp(value);
        if (/^(N|J)\d{2}$/.test(id) && valid && (!seen.has(id) || compare(valid, seen.get(id)) > 0)) seen.set(id, valid);
      }
    } catch (_) { /* Restricted or invalid storage falls back to this page. */ }
  }
  function save() {
    // Merge another tab's newer read markers before writing this tab's state.
    sync();
    try { write(JSON.stringify(Object.fromEntries(seen))); } catch (_) {}
  }
  sync();
  return {
    observe(id, value) {
      const current = stamp(value) || zero;
      latest.set(id, current);
      if (!seen.has(id)) { seen.set(id, current); save(); }
    },
    hasUnread(id) {
      return latest.has(id) && seen.has(id) && compare(latest.get(id), seen.get(id)) > 0;
    },
    markSeen(id, value) {
      const current = stamp(value);
      if (current && (!seen.has(id) || compare(current, seen.get(id)) > 0)) { seen.set(id, current); save(); }
    },
    sync,
  };
}
