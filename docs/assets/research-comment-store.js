// Firebase configuration is public; access is enforced by firestore.rules.
// Use Firestore Lite and one-time reads rather than permanent listeners.
const SDK = 'https://www.gstatic.com/firebasejs/12.19.0/';

export function createCommentStore(config) {
  const configured = !!(config?.apiKey && config?.projectId && config?.appId);
  let connection;
  let viewerId = null;
  const viewerListeners = new Set();
  let activeReads = 0;
  const waitingReads = [];
  async function read(operation) {
    if (activeReads >= 2) await new Promise(resolve => waitingReads.push(resolve));
    else activeReads += 1;
    try {
      for (let attempt = 0; ; attempt += 1) {
        try { return await operation(); }
        catch (error) {
          if (attempt >= 2 || !['unavailable', 'deadline-exceeded', 'internal', 'unknown'].includes(error.code)) throw error;
          await new Promise(resolve => setTimeout(resolve, 300 * (attempt + 1)));
        }
      }
    } finally {
      if (waitingReads.length) waitingReads.shift()();
      else activeReads -= 1;
    }
  }
  async function connect() {
    if (!configured) throw Object.assign(new Error('Storage is not configured'), {code: 'not-configured'});
    if (!connection) {
      connection = Promise.all([
        import(`${SDK}firebase-app.js`), import(`${SDK}firebase-auth.js`),
        import(`${SDK}firebase-firestore-lite.js`),
      ]).then(([appSdk, authSdk, dbSdk]) => {
        const app = appSdk.initializeApp(config, 'research-comments');
        const auth = authSdk.getAuth(app);
        authSdk.onAuthStateChanged(auth, user => {
          viewerId = user?.uid || null;
          viewerListeners.forEach(listener => listener());
        });
        return {auth, authSdk, db: dbSdk.getFirestore(app), sdk: dbSdk};
      }).catch(error => { connection = null; throw error; });
    }
    return connection;
  }
  function toComment(snapshot) {
    const data = snapshot.data();
    return {id: snapshot.id, author: data.author, text: data.body,
      authorId: data.authorId, createdAt: data.createdAt.toDate().toISOString(),
      updatedAt: data.updatedAt?.toDate().toISOString() || null};
  }
  function collectionRef({sdk, db}, landmarkId) {
    return sdk.collection(db, 'landmarkComments', landmarkId, 'comments');
  }
  return {
    configured,
    owns(comment) { return !!viewerId && comment.authorId === viewerId; },
    onViewerChange(listener) {
      viewerListeners.add(listener);
      return () => viewerListeners.delete(listener);
    },
    async count(landmarkId) {
      const connection = await connect(), {sdk} = connection;
      const count = await read(() => sdk.getCount(collectionRef(connection, landmarkId)));
      return count.data().count;
    },
    async recent(landmarkId) {
      const connection = await connect(), {sdk} = connection;
      const ref = collectionRef(connection, landmarkId);
      const [rows, count] = await read(() => Promise.all([
        sdk.getDocs(sdk.query(ref, sdk.orderBy('createdAt', 'desc'), sdk.limit(2))),
        sdk.getCount(ref),
      ]));
      return {comments: rows.docs.map(toComment), total: count.data().count};
    },
    async page(landmarkId, cursor = null) {
      const connection = await connect(), {sdk} = connection;
      const constraints = [sdk.orderBy('createdAt', 'desc')];
      if (cursor) constraints.push(sdk.startAfter(cursor));
      constraints.push(sdk.limit(20));
      const rows = await read(() => sdk.getDocs(sdk.query(collectionRef(connection, landmarkId), ...constraints)));
      return {comments: rows.docs.map(toComment), cursor: rows.docs.at(-1) || cursor,
        hasMore: rows.size === 20};
    },
    async add(landmarkId, attempt) {
      const connection = await connect(), {auth, authSdk, sdk, db} = connection;
      await auth.authStateReady();
      const user = auth.currentUser || (await authSdk.signInAnonymously(auth)).user;
      viewerId = user.uid;
      const ref = sdk.doc(collectionRef(connection, landmarkId), attempt.id);
      const writerRef = sdk.doc(db, 'commentWriters', user.uid);
      await sdk.runTransaction(db, async transaction => {
        // Retrying an uncertain submission with the same ID cannot duplicate it.
        const existing = await transaction.get(ref);
        if (existing.exists()) {
          if (existing.data().authorId !== user.uid) throw new Error('Comment ID conflict');
          return;
        }
        const writer = await transaction.get(writerRef);
        if (writer.exists() && Date.now() - writer.data().lastCreatedAt.toMillis() < 10000) {
          throw Object.assign(new Error('Please wait before posting again'), {code: 'comment-rate-limit'});
        }
        transaction.set(ref, {author: attempt.author, body: attempt.text,
          authorId: user.uid, createdAt: sdk.serverTimestamp()});
        transaction.set(writerRef, {lastCreatedAt: sdk.serverTimestamp(),
          lastCommentId: attempt.id, lastLandmarkId: landmarkId});
      });
      const comment = toComment(await read(() => sdk.getDoc(ref)));
      // Counting is optional after a confirmed write; a failed count must not
      // turn a saved comment into a submission error.
      let total = null;
      try { total = (await read(() => sdk.getCount(collectionRef(connection, landmarkId)))).data().count; }
      catch (_) { /* Keep the saved comment visible and refresh on next load. */ }
      return {comment, total};
    },
    async edit(landmarkId, commentId, text) {
      const {auth, sdk, db} = await connect();
      await auth.authStateReady();
      if (!auth.currentUser) throw Object.assign(new Error('Author session missing'), {code: 'comment-not-owner'});
      const ref = sdk.doc(db, 'landmarkComments', landmarkId, 'comments', commentId);
      await sdk.runTransaction(db, async transaction => {
        const existing = await transaction.get(ref);
        if (!existing.exists()) throw Object.assign(new Error('Comment no longer exists'), {code: 'comment-not-found'});
        if (existing.data().authorId !== auth.currentUser.uid) {
          throw Object.assign(new Error('Not the author'), {code: 'comment-not-owner'});
        }
        transaction.update(ref, {body: text, updatedAt: sdk.serverTimestamp()});
      });
      return toComment(await read(() => sdk.getDoc(ref)));
    },
    async remove(landmarkId, commentId) {
      const {auth, sdk, db} = await connect();
      await auth.authStateReady();
      if (!auth.currentUser) throw Object.assign(new Error('Author session missing'), {code: 'comment-not-owner'});
      const ref = sdk.doc(db, 'landmarkComments', landmarkId, 'comments', commentId);
      await sdk.runTransaction(db, async transaction => {
        const existing = await transaction.get(ref);
        // An uncertain deletion can be retried without creating another write.
        if (!existing.exists()) return;
        if (existing.data().authorId !== auth.currentUser.uid) {
          throw Object.assign(new Error('Not the author'), {code: 'comment-not-owner'});
        }
        transaction.delete(ref);
      });
    },
  };
}

export function commentErrorMessage(error, action = 'load') {
  if (error?.code === 'comment-not-owner') return '작성한 브라우저에서만 수정·삭제할 수 있습니다.';
  if (error?.code === 'comment-not-found') return '이미 삭제된 코멘트입니다. 목록을 다시 불러와주세요.';
  if (error?.code === 'comment-rate-limit') return '잠시 후 다시 등록해주세요.';
  if (error?.code === 'not-configured') return '코멘트 저장소 연결 준비 중입니다.';
  if (action === 'save') return '등록을 확인하지 못했습니다. 입력한 내용은 유지됩니다. 다시 등록해주세요.';
  if (action === 'edit') return '수정을 확인하지 못했습니다. 입력한 내용은 유지됩니다. 다시 저장해주세요.';
  if (action === 'delete') return '삭제를 확인하지 못했습니다. 다시 시도해주세요.';
  return '코멘트를 불러오지 못했습니다. 다시 시도해주세요.';
}
