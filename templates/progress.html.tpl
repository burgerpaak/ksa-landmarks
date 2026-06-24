<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow, noarchive, noimageindex">
<title>Files · KSA Landmarks</title>
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
.main--files { max-width: 1200px; }

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
  max-width: 760px;
}
.page-count {
  margin-top: 18px;
  font-family: var(--mono);
  font-size: 12px;
  color: var(--ink-mute);
}

/* ───── FILES SECTION (작업 / Balady+ 분기) ───── */
.files-section { margin-bottom: 40px; }
.files-section:last-child { margin-bottom: 0; }
.files-section-head {
  display: flex; align-items: baseline; gap: 10px;
  margin: 0 0 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border);
}
.files-section-title {
  font-size: 16px; font-weight: 700;
  color: var(--ink); letter-spacing: -0.01em;
}
.files-section-sub {
  font-size: 12px; color: var(--ink-mute);
}

/* ───── FILES GRID (랜드마크별 파일 카드) ───── */
.files-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
}

.file-card {
  background: var(--bg-elev);
  border: 1px solid var(--border);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  display: flex;
  flex-direction: column;
}

.fc-head {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 14px 16px;
}
.fc-tier { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.fc-num {
  font-family: var(--mono);
  font-size: 11px; font-weight: 500;
  color: var(--ink-mute);
}
.fc-name {
  font-size: 14px; font-weight: 600;
  color: var(--ink);
  letter-spacing: -0.01em;
  flex: 1; min-width: 0;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
  cursor: default;
}
/* 잘린 이름 호버 시 즉시 뜨는 풀텍스트 툴팁 (body 직속 → 카드 클리핑 없음) */
.name-tip {
  position: fixed;
  z-index: 2000;
  background: var(--ink);
  color: var(--bg-elev);
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 12px; font-weight: 500;
  line-height: 1.4;
  padding: 6px 10px;
  border-radius: 8px;
  max-width: 340px;
  box-shadow: var(--shadow-md);
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.06s ease;
}
.name-tip.show { opacity: 1; }
.fc-ref {
  font-size: 13px; color: var(--ink-mute);
  flex-shrink: 0;
  transition: color 0.14s ease;
}
.fc-ref:hover { color: var(--accent); }
.fc-region {
  flex-shrink: 0;
  font-family: var(--mono);
  font-size: 10px; font-weight: 500;
  color: var(--ink-mute);
  letter-spacing: 0.02em;
}
.fc-badge {
  flex-shrink: 0;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px; font-weight: 700;
  letter-spacing: 0.02em;
  padding: 3px 8px; border-radius: 999px;
}
.fc-badge--balady {
  color: var(--dup);
  background: color-mix(in srgb, var(--dup) 16%, var(--bg-elev));
  border: 1px solid color-mix(in srgb, var(--dup) 42%, var(--border));
}

.fc-cover {
  position: relative;
  aspect-ratio: 16 / 10;
  background: var(--bg-sunken);
  overflow: hidden;
}
.fc-cover img { width: 100%; height: 100%; object-fit: cover; }
.fc-cover--3d {
  display: flex; align-items: center; justify-content: center;
  color: var(--border-strong);
}

.fc-actions { padding: 14px 16px 6px; }
/* 버튼이 카드 마지막 요소면(Balady 카드 등) 상하 패딩 대칭 */
.fc-actions:last-child { padding-bottom: 14px; }
.model-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 10px 16px;
  border-radius: 10px;
  background: var(--accent);
  color: #fff;
  font-size: 13px;
  font-weight: 600;
  line-height: 1;
  width: 100%;
  justify-content: center;
  transition: opacity 0.14s ease, transform 0.14s ease;
}
.model-btn:hover { opacity: 0.9; transform: translateY(-1px); }
.model-btn svg { flex-shrink: 0; display: block; }

.fc-dls { padding: 8px 16px 12px; display: flex; flex-direction: column; gap: 6px; }
.fc-dl {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 11px;
  border-radius: 8px;
  background: var(--bg-sunken);
  font-family: var(--mono);
  font-size: 11px;
  color: var(--ink-soft);
  transition: color 0.14s ease, background 0.14s ease;
}
.fc-dl:hover { color: var(--ink); background: color-mix(in srgb, var(--accent) 8%, var(--bg-sunken)); }
.fc-dl svg { flex-shrink: 0; color: var(--accent); }
.fc-dl > span:nth-of-type(1) { flex: 1; min-width: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.fc-dl-size { color: var(--ink-mute); flex-shrink: 0; }

.fc-shots {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(72px, 1fr));
  gap: 6px;
  padding: 4px 16px 16px;
}
.fc-shot {
  position: relative;
  aspect-ratio: 1 / 1;
  border-radius: 8px;
  overflow: hidden;
  cursor: zoom-in;
  border: 1px solid var(--border);
  background: var(--bg-sunken);
  clip-path: inset(0 round 8px);
}
.fc-shot img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
.fc-shot:hover img { transform: scale(1.06); }
.shot-dl {
  position: absolute;
  top: 5px; right: 5px;
  width: 22px; height: 22px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 6px;
  background: color-mix(in srgb, var(--bg-elev) 86%, transparent);
  backdrop-filter: blur(6px);
  border: 1px solid var(--border);
  color: var(--ink-soft);
  opacity: 0;
  transition: opacity 0.14s ease, background 0.14s ease, color 0.14s ease;
}
.fc-shot:hover .shot-dl { opacity: 1; }
.shot-dl:hover { background: var(--accent); color: #fff; border-color: var(--accent); }

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
  .files-grid { grid-template-columns: 1fr; }
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
    <a href="./" class="active">Files</a>
  </nav>
  <div class="topbar-spacer"></div>
  <button class="icon-btn" id="theme-toggle" aria-label="Toggle theme">
    <svg class="sun-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="3" stroke="currentColor" stroke-width="1.4"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3.05 3.05l1.41 1.41M11.54 11.54l1.41 1.41M3.05 12.95l1.41-1.41M11.54 4.46l1.41-1.41" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
    <svg class="moon-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13 9.5A6 6 0 1 1 6.5 3a4.5 4.5 0 0 0 6.5 6.5z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/></svg>
  </button>
</header>

<main class="main main--files">
  <div class="page-head">
    <div class="page-eyebrow">Files</div>
    <h1 class="page-title">Model Files</h1>
    <p class="page-sub">랜드마크별 3D 모델(.glb)과 이미지. 3D Viewer에서 이동·확대·회전하며 모델을 살펴볼 수 있습니다.</p>
    <div class="page-count">{{COUNT}}</div>
  </div>

  {{ENTRIES}}
</main>

<div class="lightbox" id="lightbox"><img id="lightbox-img" alt=""></div>

{{MODEL_MODAL}}

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

  // 3D 모델은 공유 모달이 처리 (.model-btn → window.openModelModal)

  // 잘린 카드 이름 → 호버 즉시 풀텍스트 툴팁 (네이티브 title 지연 회피)
  (function(){
    let tip = null;
    function ensure(){
      if (!tip){ tip = document.createElement('div'); tip.className = 'name-tip'; document.body.appendChild(tip); }
      return tip;
    }
    function show(e){
      const el = e.currentTarget;
      if (el.scrollWidth <= el.clientWidth + 1) return;  // 안 잘렸으면 패스
      const t = ensure();
      t.textContent = el.textContent.trim();
      const r = el.getBoundingClientRect();
      t.style.left = Math.round(r.left) + 'px';
      t.style.top = Math.round(r.bottom + 6) + 'px';
      // 우측 화면 넘침 방지
      const tw = t.offsetWidth;
      if (r.left + tw > window.innerWidth - 12) t.style.left = Math.max(12, window.innerWidth - tw - 12) + 'px';
      t.classList.add('show');
    }
    function hide(){ if (tip) tip.classList.remove('show'); }
    document.querySelectorAll('.fc-name').forEach(el => {
      el.addEventListener('mouseenter', show);
      el.addEventListener('mouseleave', hide);
    });
    window.addEventListener('scroll', hide, true);
  })();

  // lightbox (다운로드 버튼 클릭은 제외)
  const lb = document.getElementById('lightbox');
  const lbImg = document.getElementById('lightbox-img');
  document.querySelectorAll('.fc-shot img').forEach(img => {
    img.addEventListener('click', () => {
      lbImg.src = img.src;
      lb.classList.add('open');
    });
  });
  document.querySelectorAll('.shot-dl').forEach(a => {
    a.addEventListener('click', e => e.stopPropagation());
  });
  lb.addEventListener('click', () => { lb.classList.remove('open'); lbImg.src = ''; });
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') { lb.classList.remove('open'); lbImg.src = ''; }
  });
})();
</script>
</body>
</html>
