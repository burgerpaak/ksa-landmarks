<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Progress · KSA Landmarks</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script type="module" src="https://unpkg.com/@google/model-viewer@3.5.0/dist/model-viewer.min.js"></script>
<style>

{{PALETTE}}

* { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }
body {
  background: var(--bg);
  color: var(--ink);
  font-family: 'Inter', 'Noto Sans KR', -apple-system, sans-serif;
  font-size: 14px;
  line-height: 1.55;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; background: none; color: inherit; }

/* ───── TOP BAR ───── */
.topbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  height: var(--topbar-height);
  display: flex;
  align-items: center;
  padding: 0 24px;
  gap: 18px;
  z-index: 100;
  border-bottom: 1px solid var(--border);
  backdrop-filter: blur(12px);
  background: color-mix(in srgb, var(--bg-elev) 92%, transparent);
  user-select: none;
}

.brand {
  display: flex;
  flex-direction: column;
  justify-content: center;
  line-height: 1;
}
.brand-mark { font-weight: 700; font-size: 17px; letter-spacing: -0.02em; color: var(--ink); line-height: 1.1; }
.brand-meta {
  font-family: var(--mono);
  font-size: 9.5px; color: var(--ink-mute);
  letter-spacing: 0.1em; text-transform: uppercase;
  margin-top: 3px; line-height: 1;
}

.topbar-nav {
  display: flex;
  gap: 4px;
  margin-left: 12px;
}
.topbar-nav a {
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 12.5px;
  font-weight: 500;
  color: var(--ink-soft);
  background: var(--bg-sunken);
  transition: background 0.14s ease, color 0.14s ease;
}
.topbar-nav a:hover { color: var(--ink); }
.topbar-nav a.active { background: var(--ink); color: var(--bg-elev); }

.topbar-spacer { flex: 1; }

.icon-btn {
  width: 36px; height: 36px;
  border: 1px solid var(--border);
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  color: var(--ink-soft);
  background: var(--bg-elev);
  transition: background 0.14s ease, color 0.14s ease;
}
.icon-btn:hover { background: var(--bg-sunken); color: var(--ink); }
[data-theme="dark"] .sun-icon { display: none; }
[data-theme="light"] .moon-icon { display: none; }
.moon-icon { transform: translate(1px, -1px); }

/* ───── MAIN ───── */
.main {
  max-width: 920px;
  margin: 0 auto;
  padding: calc(var(--topbar-height) + 40px) 32px 100px;
}

.page-head { margin-bottom: 44px; }
.page-eyebrow {
  font-family: var(--mono);
  font-size: 11px; font-weight: 500;
  letter-spacing: 0.12em; text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 10px;
}
.page-title {
  font-size: clamp(30px, 4vw, 42px);
  font-weight: 700;
  letter-spacing: -0.025em;
  line-height: 1.05;
  color: var(--ink);
}
.page-sub {
  margin-top: 14px;
  font-size: 15px;
  color: var(--ink-soft);
  max-width: 60ch;
}
.page-count {
  margin-top: 18px;
  font-family: var(--mono);
  font-size: 12px;
  color: var(--ink-mute);
}

/* ───── TIMELINE ───── */
.timeline { position: relative; }

.entry {
  position: relative;
  padding: 0 0 40px 32px;
  border-left: 2px solid var(--border);
}
.entry:last-child { border-left-color: transparent; padding-bottom: 0; }

.entry::before {
  content: '';
  position: absolute;
  left: -7px; top: 4px;
  width: 12px; height: 12px;
  border-radius: 50%;
  background: var(--accent);
  border: 3px solid var(--bg);
}

.entry-date {
  font-family: var(--mono);
  font-size: 12px;
  color: var(--ink-mute);
  letter-spacing: 0.02em;
  margin-bottom: 10px;
}

.entry-card {
  background: var(--bg-elev);
  border: 1px solid var(--border);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.entry-head {
  padding: 18px 22px 0;
}

.entry-landmark {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}
.entry-num {
  font-family: var(--mono);
  font-size: 11px;
  font-weight: 500;
  color: var(--ink-mute);
}
.entry-landmark-name {
  font-size: 12.5px;
  font-weight: 500;
  color: var(--ink-soft);
}
.entry-tier {
  width: 8px; height: 8px; border-radius: 50%;
}

.entry-title {
  font-size: 19px;
  font-weight: 700;
  letter-spacing: -0.015em;
  color: var(--ink);
  margin-bottom: 8px;
}

.entry-notes {
  font-size: 13.5px;
  color: var(--ink-soft);
  line-height: 1.6;
  margin-bottom: 16px;
}

.entry-tri {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 18px;
  font-family: var(--mono);
  font-size: 11.5px;
  color: var(--ink-mute);
}
.entry-tri-bar {
  flex: 0 0 120px;
  height: 5px;
  background: var(--bg-sunken);
  border-radius: 3px;
  overflow: hidden;
}
.entry-tri-fill {
  height: 100%;
  background: var(--accent);
  border-radius: 3px;
}

/* model-viewer */
.entry-model {
  position: relative;
  width: 100%;
  height: 360px;
  background: var(--bg-sunken);
  border-top: 1px solid var(--border);
}
.entry-model model-viewer {
  width: 100%; height: 100%;
  --poster-color: transparent;
}
.entry-model-bar {
  position: absolute;
  bottom: 12px; right: 12px;
  display: flex; gap: 8px;
  z-index: 5;
}
.model-dl {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 12px;
  border-radius: 8px;
  background: color-mix(in srgb, var(--bg-elev) 90%, transparent);
  backdrop-filter: blur(8px);
  border: 1px solid var(--border);
  font-family: var(--mono);
  font-size: 11px;
  color: var(--ink-soft);
  transition: background 0.14s ease, color 0.14s ease;
}
.model-dl:hover { color: var(--ink); background: var(--bg-elev); }

/* screenshots */
.entry-shots {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 8px;
  padding: 0 22px 20px;
}
.entry-shots:first-child { padding-top: 18px; }
.entry-shot {
  aspect-ratio: 4 / 3;
  border-radius: 8px;
  overflow: hidden;
  cursor: zoom-in;
  border: 1px solid var(--border);
  background: var(--bg-sunken);
}
.entry-shot img {
  width: 100%; height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}
.entry-shot:hover img { transform: scale(1.04); }

.entry-foot { padding: 16px 22px 18px; border-top: 1px solid var(--border); }
.entry-ref-link {
  font-family: var(--mono);
  font-size: 11px;
  color: var(--accent);
}

/* 빈 상태 */
.empty {
  padding: 80px 20px;
  text-align: center;
  color: var(--ink-mute);
}
.empty-title { font-size: 18px; font-weight: 600; color: var(--ink); margin-bottom: 8px; }

/* lightbox */
.lightbox {
  position: fixed; inset: 0; z-index: 200;
  background: rgba(0,0,0,0.88);
  display: none; align-items: center; justify-content: center;
  cursor: zoom-out; padding: 40px;
  backdrop-filter: blur(4px);
}
.lightbox.open { display: flex; }
.lightbox img {
  max-width: 100%; max-height: calc(100vh - 80px);
  object-fit: contain; border-radius: 4px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.6);
}

@media (max-width: 640px) {
  .main { padding: calc(var(--topbar-height) + 28px) 18px 60px; }
  .entry { padding-left: 24px; }
}

</style>
</head>
<body data-theme="light">

<header class="topbar">
  <div class="brand">
    <span class="brand-mark">KSA Landmarks</span>
    <span class="brand-meta">3D · Reference</span>
  </div>
  <nav class="topbar-nav">
    <a href="../">Reference</a>
    <a href="./" class="active">Progress</a>
  </nav>
  <div class="topbar-spacer"></div>
  <button class="icon-btn" id="theme-toggle" aria-label="Toggle theme">
    <svg class="sun-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="3" stroke="currentColor" stroke-width="1.4"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3.05 3.05l1.41 1.41M11.54 11.54l1.41 1.41M3.05 12.95l1.41-1.41M11.54 4.46l1.41-1.41" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
    <svg class="moon-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13 9.5A6 6 0 1 1 6.5 3a4.5 4.5 0 0 0 6.5 6.5z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/></svg>
  </button>
</header>

<main class="main">
  <div class="page-head">
    <div class="page-eyebrow">Work in Progress</div>
    <h1 class="page-title">진행 상황 공유</h1>
    <p class="page-sub">모델링 진행 중 중간 공유 기록. 스크린샷·3D 모델(.glb)을 시간순으로 정리합니다.</p>
    <div class="page-count">{{COUNT}}</div>
  </div>

  <div class="timeline">
{{ENTRIES}}
  </div>
</main>

<div class="lightbox" id="lightbox"><img id="lightbox-img" alt=""></div>

<script>
(function(){
  // theme (메인과 같은 localStorage 키 공유)
  const stored = localStorage.getItem('ksa-theme');
  if (stored === 'dark') document.body.setAttribute('data-theme', 'dark');
  document.getElementById('theme-toggle').addEventListener('click', () => {
    const isDark = document.body.getAttribute('data-theme') === 'dark';
    document.body.setAttribute('data-theme', isDark ? 'light' : 'dark');
    localStorage.setItem('ksa-theme', isDark ? 'light' : 'dark');
  });

  // lightbox
  const lb = document.getElementById('lightbox');
  const lbImg = document.getElementById('lightbox-img');
  document.querySelectorAll('.entry-shot img').forEach(img => {
    img.addEventListener('click', () => {
      lbImg.src = img.src;
      lb.classList.add('open');
    });
  });
  lb.addEventListener('click', () => { lb.classList.remove('open'); lbImg.src = ''; });
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') { lb.classList.remove('open'); lbImg.src = ''; }
  });
})();
</script>
</body>
</html>
