<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>KSA Landmarks · 3D Modeling Reference</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>

:root {
  /* Light theme — cool gray palette (iOS doc tone) */
  --bg: #f4f6f9;
  --bg-elev: #ffffff;
  --bg-sunken: #eef1f5;
  --border: #e3e7ed;
  --border-strong: #c8cfd9;
  --ink: #0e131b;
  --ink-soft: #44505f;
  --ink-mute: #8a94a3;
  --accent: #4a6585;
  --accent-soft: #dde5f0;
  /* Tier — 한색 계열, 구분 강화 (deep blue / saturated teal / neutral slate) */
  --tier-1: #2c5588;
  --tier-2: #3a8a78;
  --tier-3: #8696a8;
  /* Alert — cool muted plum (한색 계열 경고) */
  --alert: #8a6878;
  --mono: 'SF Mono', 'JetBrains Mono', ui-monospace, Menlo, monospace;
  --shadow-sm: 0 1px 0 rgba(15, 25, 40, 0.04);
  --shadow-md: 0 4px 16px rgba(15, 25, 40, 0.06);
  --sidebar-width: 280px;
  --topbar-height: 64px;
}

[data-theme="dark"] {
  --bg: #0c1018;
  --bg-elev: #181c24;
  --bg-sunken: #12161e;
  --border: #2a3140;
  --border-strong: #3a4250;
  --ink: #ecf0f7;
  --ink-soft: #b4bcca;
  --ink-mute: #6e7787;
  --accent: #8aa5cc;
  --accent-soft: #1f2530;
  /* Tier — dark: 밝기 보정 + hue 강조 유지 */
  --tier-1: #7ea4d5;
  --tier-2: #6db8a4;
  --tier-3: #a5b3c5;
  --alert: #c39aac;
  --shadow-sm: 0 1px 0 rgba(0, 0, 0, 0.3);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.5);
}

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
  font-feature-settings: "ss01", "cv01";
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; background: none; color: inherit; }

/* ───── TOP BAR ───── */
.topbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  height: var(--topbar-height);
  background: var(--bg-elev);
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  padding: 0 24px;
  gap: 24px;
  z-index: 100;
  backdrop-filter: blur(12px);
  background: color-mix(in srgb, var(--bg-elev) 92%, transparent);
}

.brand {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  gap: 0;
  flex-shrink: 0;
  line-height: 1;
}

.brand-mark {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-weight: 700;
  font-size: 17px;
  letter-spacing: -0.02em;
  color: var(--ink);
  line-height: 1.1;
}

.brand-meta {
  font-family: var(--mono);
  font-size: 9.5px;
  color: var(--ink-mute);
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin-top: 3px;
  line-height: 1;
}

.search-wrap {
  flex: 1;
  max-width: 480px;
  position: relative;
}

.search-input {
  width: 100%;
  height: 36px;
  padding: 0 16px 0 38px;
  background: var(--bg-sunken);
  border: 1px solid transparent;
  border-radius: 10px;
  color: var(--ink);
  font-family: inherit;
  font-size: 13px;
  outline: none;
  transition: border-color 0.15s ease, background 0.15s ease, box-shadow 0.15s ease;
}

.search-input:focus {
  border-color: color-mix(in srgb, var(--accent) 50%, var(--border));
  background: var(--bg-elev);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 12%, transparent);
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--ink-mute);
  pointer-events: none;
}

.search-kbd {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  color: var(--ink-mute);
  background: var(--bg);
  border: 1px solid var(--border);
  padding: 2px 6px;
  border-radius: 4px;
  pointer-events: none;
}

.topbar-actions {
  display: flex;
  gap: 8px;
  align-items: center;
}

.icon-btn {
  width: 36px;
  height: 36px;
  border: 1px solid var(--border);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--ink-soft);
  transition: background 0.14s ease, color 0.14s ease, border-color 0.14s ease;
  background: var(--bg-elev);
}

.icon-btn:hover { background: var(--bg-sunken); color: var(--ink); }

[data-theme="dark"] .sun-icon { display: none; }
[data-theme="light"] .moon-icon { display: none; }

/* ───── LAYOUT ───── */
.layout {
  display: grid;
  grid-template-columns: var(--sidebar-width) 1fr;
  margin-top: var(--topbar-height);
  min-height: calc(100vh - var(--topbar-height));
}

/* ───── SIDEBAR ───── */
.sidebar {
  position: sticky;
  top: var(--topbar-height);
  height: calc(100vh - var(--topbar-height));
  border-right: 1px solid var(--border);
  background: var(--bg-elev);
  overflow-y: auto;
  padding: 20px 0;
}

.sidebar::-webkit-scrollbar { width: 6px; }
.sidebar::-webkit-scrollbar-track { background: transparent; }
.sidebar::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

.sidebar-section {
  padding: 0 20px 20px;
}

.sidebar-heading {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ink-mute);
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.sidebar-heading .count {
  font-weight: 400;
  color: var(--ink-mute);
  font-size: 10px;
}

.filter-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-bottom: 6px;
}

.chip {
  display: inline-flex;
  align-items: center;
  height: 26px;
  padding: 0 12px;
  border: none;
  border-radius: 999px;
  font-size: 11.5px;
  font-weight: 500;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  color: var(--ink-soft);
  background: var(--bg-sunken);
  transition: background 0.14s ease, color 0.14s ease;
  letter-spacing: 0.01em;
}

.chip:hover { background: color-mix(in srgb, var(--ink) 6%, var(--bg-sunken)); color: var(--ink); }

.chip.active {
  background: var(--ink);
  color: var(--bg-elev);
}

.chip[data-tier="tier-1"].active { background: var(--tier-1); color: #fff; }
.chip[data-tier="tier-2"].active { background: var(--tier-2); color: #fff; }
.chip[data-tier="tier-3"].active { background: var(--tier-3); color: #fff; }

.nav-list {
  display: flex;
  flex-direction: column;
}

.nav-item {
  display: grid;
  grid-template-columns: 24px 1fr 8px;
  align-items: center;
  gap: 10px;
  padding: 7px 12px;
  margin: 0 8px;
  font-size: 12.5px;
  color: var(--ink-soft);
  border-radius: 8px;
  transition: background 0.12s ease, color 0.12s ease;
}

.nav-item:hover {
  background: var(--bg-sunken);
  color: var(--ink);
}

.nav-item.active {
  background: var(--accent-soft);
  color: var(--ink);
  font-weight: 500;
}

.nav-num {
  font-family: var(--mono);
  font-size: 10.5px;
  color: var(--ink-mute);
  font-weight: 500;
}

.nav-label {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.nav-tier {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

/* ───── MAIN ───── */
.main {
  padding: 32px 40px 80px;
  min-width: 0;
}

.hero {
  margin-bottom: 48px;
  padding-bottom: 32px;
  border-bottom: 1px solid var(--border);
}

.hero-eyebrow {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 14px;
}

.hero-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-weight: 700;
  font-size: clamp(36px, 4.5vw, 56px);
  line-height: 1.05;
  letter-spacing: -0.025em;
  color: var(--ink);
  margin-bottom: 18px;
  max-width: 18ch;
}

.hero-title em {
  font-style: normal;
  color: var(--accent);
  font-weight: 700;
  letter-spacing: -0.025em;
}

.hero-desc {
  font-size: 15px;
  color: var(--ink-soft);
  max-width: 60ch;
  margin-bottom: 28px;
  line-height: 1.6;
}

.hero-stats {
  display: flex;
  gap: 40px;
  flex-wrap: wrap;
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-num {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 28px;
  font-weight: 600;
  color: var(--ink);
  line-height: 1;
}

.stat-label {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--ink-mute);
}

/* ───── DELIVERY SPEC (글로벌 납품 사양) — iOS doc-style ───── */
.delivery-spec {
  margin-bottom: 40px;
  background: var(--bg-elev);
  border: 1px solid var(--border);
  border-radius: 16px;
  padding: 32px 36px 28px;
  box-shadow: var(--shadow-sm), var(--shadow-md);
}

.delivery-spec-head {
  margin-bottom: 28px;
}

.delivery-spec-eyebrow {
  display: block;
  font-family: var(--mono);
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 8px;
}

.delivery-spec-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 26px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--ink);
  line-height: 1.1;
  margin: 0;
}

.delivery-spec-sub {
  margin: 6px 0 0;
  font-size: 13px;
  color: var(--ink-mute);
  letter-spacing: 0;
}

.spec-group { margin-top: 24px; }
.spec-group:first-of-type { margin-top: 0; }

.spec-group-head {
  font-family: var(--mono);
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--ink-mute);
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border);
}

.delivery-spec .spec-list {
  display: flex;
  flex-direction: column;
  margin: 0;
  background: transparent;
  border: none;
  padding: 0;
  gap: 0;
}

.delivery-spec .spec-item {
  display: grid;
  grid-template-columns: 130px 1fr;
  gap: 28px;
  align-items: baseline;
  padding: 14px 0;
  border-bottom: 1px solid var(--border);
}

.delivery-spec .spec-item:last-child { border-bottom: none; }

.delivery-spec .spec-item dt {
  margin: 0;
  font-size: 13px;
  font-weight: 500;
  color: var(--ink-mute);
}

.delivery-spec .spec-item dd {
  margin: 0;
  font-size: 14px;
  color: var(--ink-soft);
  line-height: 1.55;
  letter-spacing: -0.005em;
}

.delivery-spec .spec-item dd strong {
  color: var(--ink);
  font-weight: 600;
}

.delivery-spec .spec-item dd code {
  display: inline-block;
  font-family: var(--mono);
  font-size: 12.5px;
  font-weight: 500;
  background: var(--bg-sunken);
  color: var(--ink);
  padding: 2px 7px;
  border-radius: 5px;
  letter-spacing: -0.01em;
  border: 1px solid var(--border);
}

.delivery-spec .spec-muted {
  color: var(--ink-mute);
  font-size: 13px;
}

.delivery-spec .spec-item--deprecated { opacity: 0.65; }

.delivery-spec .budget-pill {
  display: inline-block;
  padding: 4px 10px;
  margin: 0 4px 4px 0;
  background: var(--bg-sunken);
  border: 1px solid var(--border);
  border-radius: 999px;
  font-family: var(--mono);
  font-size: 11px;
  color: var(--ink-mute);
  font-variant-numeric: tabular-nums;
}

@media (max-width: 640px) {
  .delivery-spec {
    padding: 24px 22px;
  }
  .spec-item {
    grid-template-columns: 1fr;
    gap: 4px;
  }
}

/* ───── GLOSSARY (collapsible) ───── */
.glossary {
  margin-bottom: 56px;
  border: 1px solid var(--border);
  border-radius: 14px;
  background: var(--bg-elev);
  overflow: hidden;
  box-shadow: 0 1px 0 rgba(15, 25, 40, 0.02);
}

.glossary-head {
  width: 100%;
  padding: 18px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: background 0.12s;
}

.glossary-head:hover { background: var(--bg-sunken); }

.glossary-head-text {
  display: flex;
  align-items: baseline;
  gap: 12px;
}

.glossary-head-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 18px;
  font-weight: 600;
  color: var(--ink);
}

.glossary-head-sub {
  font-size: 12px;
  color: var(--ink-mute);
}

.glossary-arrow {
  transition: transform 0.25s;
  color: var(--ink-soft);
}

.glossary.open .glossary-arrow { transform: rotate(180deg); }

.glossary-body {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.glossary.open .glossary-body { max-height: 6000px; }

.glossary-inner {
  padding: 8px 24px 24px;
  border-top: 1px solid var(--border);
}

.gloss-cat { margin-top: 28px; }
.gloss-cat:first-child { margin-top: 4px; }

.gloss-cat-head { margin-bottom: 8px; }

.gloss-cat-desc {
  font-size: 12px;
  color: var(--ink-mute);
  margin-top: 2px;
}

/* glossary 항목 — hairline-list 위에 얹은 의미적 스타일 */
.gloss-term { padding: 12px 0 14px; }

.gloss-term-row {
  display: flex;
  align-items: baseline;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 4px;
}

.gloss-kr {
  font-size: 14px;
  font-weight: 600;
  color: var(--ink);
  letter-spacing: -0.01em;
}

.gloss-en {
  font-family: var(--mono);
  font-size: 10.5px;
  color: var(--accent);
  letter-spacing: 0.02em;
  font-weight: 500;
}

.gloss-desc {
  font-size: 12.5px;
  color: var(--ink-soft);
  line-height: 1.55;
  margin: 0;
}

.gloss-where {
  font-family: var(--mono);
  font-size: 10.5px;
  color: var(--ink-mute);
  letter-spacing: 0;
  margin: 6px 0 0;
}

.gloss-where::before {
  content: '↳ ';
  color: var(--accent);
}

/* ───── CARD GRID ───── */
.cards-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.cards-header .cards-count {
  margin-left: auto;
}

.cards-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 24px;
  font-weight: 600;
  color: var(--ink);
}

.cards-count {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 12px;
  color: var(--ink-mute);
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 24px;
}

/* ───── TIER GROUP HEADER (메인 콘텐츠 안 구분선) ───── */
.tier-header {
  grid-column: 1 / -1;
  display: flex;
  align-items: baseline;
  gap: 10px;
  padding: 18px 0 10px;
  border-bottom: 1px solid var(--border);
  margin-top: 8px;
}

.tier-header:first-of-type { margin-top: 0; padding-top: 0; }

.tier-header-mark {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  align-self: center;
  flex-shrink: 0;
}

.tier-header-label {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--ink);
}

.tier-header[data-tier="tier-1"] .tier-header-label { color: var(--tier-1); }
.tier-header[data-tier="tier-2"] .tier-header-label { color: var(--tier-2); }
.tier-header[data-tier="tier-3"] .tier-header-label { color: var(--tier-3); }

.tier-header-sub {
  font-size: 12px;
  color: var(--ink-mute);
}

.tier-header-count {
  margin-left: auto;
  font-size: 11px;
  color: var(--ink-mute);
  letter-spacing: 0.04em;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
}

.tier-header.hidden { display: none; }

/* ───── DENSITY TOGGLE (Detailed/Compact) ───── */
.density-toggle {
  display: inline-flex;
  border-radius: 10px;
  padding: 2px;
  background: var(--bg-sunken);
  margin-left: 16px;
}

.density-btn {
  padding: 5px 14px;
  font-size: 11.5px;
  font-weight: 500;
  letter-spacing: 0;
  border-radius: 8px;
  color: var(--ink-soft);
  transition: background 0.14s ease, color 0.14s ease, box-shadow 0.14s ease;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
}

.density-btn:hover { color: var(--ink); }

.density-btn.active {
  background: var(--bg-elev);
  color: var(--ink);
  box-shadow: 0 1px 2px rgba(15, 25, 40, 0.08);
  font-weight: 600;
}

/* compact 모드: 필수요소 + Structure만 노출, Key Points·Modeling Notes 숨김 */
body.density-compact .card-section:not(.card-section--must-have):not(.card-section--structure) {
  display: none;
}

/* ───── CARD — iOS soft elevation ───── */
.card {
  background: var(--bg-elev);
  border: 1px solid var(--border);
  border-radius: 14px;
  display: flex;
  flex-direction: column;
  transition: box-shadow 0.18s ease, border-color 0.18s ease, background 0.18s ease;
  scroll-margin-top: calc(var(--topbar-height) + 20px);
  position: relative;
  box-shadow: 0 1px 0 rgba(15, 25, 40, 0.02);
}

.card:hover {
  border-color: color-mix(in srgb, var(--ink) 14%, var(--border));
  box-shadow: 0 1px 0 rgba(15, 25, 40, 0.03), 0 8px 24px rgba(15, 25, 40, 0.05);
}

.card-image {
  position: relative;
  aspect-ratio: 16 / 10;
  background: var(--bg-sunken);
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
  cursor: zoom-in;
}

/* ───── CARD SLIDER ───── */
.card-slider {
  position: relative;
  width: 100%;
  height: 100%;
}

.card-slide {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  cursor: zoom-in;
  opacity: 0;
  transition: opacity 0.35s ease;
  z-index: 0;
}

.card-slide.active { opacity: 1; z-index: 1; }

.card:hover .card-slide.active { transform: scale(1.04); }

.card-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.55);
  color: #fff;
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  z-index: 5;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 0 2px;
  opacity: 0;
  transition: opacity 0.15s, background 0.15s;
  backdrop-filter: blur(6px);
}

.card:hover .card-arrow { opacity: 1; }
.card-arrow:hover { background: rgba(0, 0, 0, 0.8); }
.card-arrow--prev { left: 8px; padding-right: 4px; }
.card-arrow--next { right: 8px; padding-left: 4px; }

.card-dots {
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 5px;
  z-index: 5;
  padding: 4px 8px;
  background: rgba(0, 0, 0, 0.4);
  border-radius: 10px;
  backdrop-filter: blur(6px);
}

.card-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.55);
  border: none;
  cursor: pointer;
  padding: 0;
  transition: background 0.18s, width 0.18s, border-radius 0.18s;
}

.card-dot:hover { background: rgba(255, 255, 255, 0.85); }

.card-dot.active {
  background: #fff;
  width: 16px;
  border-radius: 3px;
}

.card-counter {
  position: absolute;
  bottom: 10px;
  right: 12px;
  z-index: 5;
  background: rgba(0, 0, 0, 0.55);
  color: rgba(255, 255, 255, 0.95);
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.04em;
  padding: 3px 8px;
  border-radius: 10px;
  backdrop-filter: blur(6px);
  pointer-events: none;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
}

.card:hover .card-image img { transform: scale(1.04); }

.card-image.no-image::before {
  content: '◇';
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  color: var(--border-strong);
}

.card-image-meta {
  position: absolute;
  top: 12px;
  left: 12px;
  right: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  pointer-events: none;
  z-index: 2;
}

.card-num {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.05em;
  color: #fff;
  background: rgba(0,0,0,0.55);
  padding: 4px 8px;
  border-radius: 4px;
  backdrop-filter: blur(8px);
}

.card-tier-pill {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.05em;
  color: #fff;
  background: var(--pill-color);
  padding: 4px 8px;
  border-radius: 4px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.2);
}

.card-image-meta-right {
  display: flex;
  align-items: center;
  gap: 6px;
  pointer-events: auto;
}

.card-warning {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.06em;
  color: #fff;
  background: rgba(194, 90, 60, 0.92);
  padding: 4px 7px;
  border-radius: 4px;
  backdrop-filter: blur(6px);
  box-shadow: 0 2px 6px rgba(0,0,0,0.25);
  cursor: help;
  text-transform: uppercase;
}

.card-warning svg {
  flex-shrink: 0;
}

.card-warning:hover {
  background: rgba(194, 90, 60, 1);
}

.card-content {
  padding: 22px 24px 22px;
  display: flex;
  flex-direction: column;
  gap: 22px;
  flex: 1;
}

.card-header {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.card-meta {
  font-family: var(--mono);
  font-size: 10.5px;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--ink-mute);
  display: flex;
  gap: 8px;
}

.meta-divider { opacity: 0.5; }

.card-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-weight: 700;
  font-size: 22px;
  line-height: 1.2;
  letter-spacing: -0.02em;
  color: var(--ink);
}

.card-subtitle {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 12.5px;
  font-weight: 400;
  color: var(--ink-mute);
  letter-spacing: 0;
  margin-top: -2px;
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  margin-top: 6px;
}

.tag {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10.5px;
  font-weight: 500;
  letter-spacing: 0.01em;
  color: var(--ink-soft);
  background: var(--bg-sunken);
  padding: 4px 9px;
  border-radius: 999px;
  border: none;
  display: inline-flex;
  align-items: center;
}

.tag-alert {
  color: var(--alert);
  background: color-mix(in srgb, var(--alert) 10%, var(--bg-elev));
  font-weight: 600;
}

.card-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* ───── iOS section eyebrow ───── */
.section-eyebrow {
  font-family: var(--mono);
  font-size: 10.5px;
  font-weight: 600;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--ink-mute);
  margin: 0 0 10px;
}

.section-eyebrow--accent {
  color: var(--accent);
}

/* ───── HAIRLINE LIST (iOS Settings 그룹 리스트) ───── */
.hairline-list {
  display: flex;
  flex-direction: column;
  margin: 0;
  padding: 0;
}

.hairline-list--kv { display: block; }

.hl-item {
  padding: 9px 0;
  border-bottom: 1px solid var(--border);
}

.hl-item:first-child { padding-top: 2px; }
.hl-item:last-child { border-bottom: none; padding-bottom: 2px; }

.hl-primary {
  font-size: 13.5px;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.45;
  letter-spacing: -0.005em;
}

.hl-aux {
  margin-top: 3px;
  font-size: 12px;
  font-weight: 400;
  color: var(--ink-mute);
  line-height: 1.5;
  letter-spacing: 0;
}

/* Key/Value 행 (Structure, Part Heights) */
.hl-item--kv {
  display: grid;
  grid-template-columns: 96px 1fr;
  gap: 16px;
  align-items: baseline;
}

.hl-item--kv dt {
  margin: 0;
  font-size: 12px;
  font-weight: 500;
  color: var(--ink-mute);
  letter-spacing: 0;
}

.hl-item--kv dd {
  margin: 0;
  font-size: 13.5px;
  font-weight: 500;
  color: var(--ink);
  letter-spacing: -0.005em;
  font-variant-numeric: tabular-nums;
}

.hl-item--missing dd {
  color: var(--ink-mute);
  font-weight: 400;
  font-style: italic;
}

.hl-item--extra dt { color: var(--ink-mute); }

.hl-item--deprecated dt,
.hl-item--deprecated dd {
  color: var(--ink-mute);
  font-weight: 400;
  text-decoration: line-through;
  text-decoration-color: var(--ink-mute);
}

.hl-item--coord dd {
  font-family: var(--mono);
  font-size: 12px;
  letter-spacing: 0;
}

/* DRAFT 핀 — 카드 헤더의 검증 미완 표지 */
.tag-draft {
  background: var(--bg-sunken);
  color: var(--ink-mute);
  border: 1px dashed var(--border-strong);
  font-weight: 600;
  letter-spacing: 0.1em;
  cursor: help;
  text-transform: uppercase;
}

.tag-draft:hover {
  background: var(--bg);
  color: var(--ink-soft);
}

/* Modeling 메타 뱃지 — 시공 상태 */
.tag-status {
  font-weight: 600;
  letter-spacing: 0.04em;
}

.tag-status-done {
  background: color-mix(in srgb, var(--tier-2) 14%, var(--bg-elev));
  color: var(--tier-2);
  border-color: color-mix(in srgb, var(--tier-2) 30%, var(--border));
}

.tag-status-wip {
  background: color-mix(in srgb, var(--alert) 12%, var(--bg-elev));
  color: var(--alert);
  border-color: color-mix(in srgb, var(--alert) 30%, var(--border));
}

.tag-status-plan {
  background: color-mix(in srgb, var(--tier-3) 14%, var(--bg-elev));
  color: var(--tier-3);
  border-color: color-mix(in srgb, var(--tier-3) 30%, var(--border));
}

/* 작업 구분 (신규제작/기존편집) */
.tag-task {
  font-weight: 500;
}

.tag-task-new {
  background: color-mix(in srgb, var(--accent) 10%, var(--bg-elev));
  color: var(--accent);
  border-color: color-mix(in srgb, var(--accent) 30%, var(--border));
}

.tag-task-edit {
  background: color-mix(in srgb, var(--ink-soft) 10%, var(--bg-elev));
  color: var(--ink-soft);
  border-color: color-mix(in srgb, var(--ink-soft) 25%, var(--border));
}

/* Structure 섹션을 카드 하단에 정렬 (footer 위로) */
.card-content > .card-section--structure {
  margin-top: auto;
}

.card-footer {
  padding-top: 14px;
  border-top: 1px solid var(--border);
}


/* ───── GLOSSARY HOVER MARK ───── */
.gloss-mark {
  border-bottom: 1px dashed var(--accent);
  cursor: help;
}

/* 단일 fixed 툴팁 — 어떤 부모의 overflow에도 영향 없이 viewport 기준 위치 */
.gloss-tooltip {
  position: fixed;
  z-index: 200;
  width: 320px;
  max-width: calc(100vw - 16px);
  pointer-events: none;
  opacity: 0;
  transform: translateY(4px);
  transition: opacity 0.14s, transform 0.14s;
  box-shadow: var(--shadow-md);
  border-radius: 6px;
  overflow: hidden;
}

.gloss-tooltip.open {
  opacity: 1;
  transform: translateY(0);
}

.gloss-tooltip-head {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--accent);
  background: var(--ink);
  padding: 6px 12px 4px;
  white-space: nowrap;
  border-bottom: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
}

.gloss-tooltip-body {
  background: var(--ink);
  color: var(--bg-elev);
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-weight: 400;
  font-size: 12px;
  line-height: 1.55;
  padding: 8px 12px 10px;
  text-align: left;
  white-space: normal;
}

.ref-links {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.ref-link {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 11px;
  color: var(--ink-soft);
  padding: 5px 10px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--bg-elev);
  transition: all 0.12s;
}

.ref-link:hover {
  background: var(--ink);
  color: var(--bg);
  border-color: var(--ink);
}

.ref-link svg { flex-shrink: 0; opacity: 0.6; }
.ref-link:hover svg { opacity: 1; }

/* ───── EMPTY STATE ───── */
.empty-state {
  grid-column: 1 / -1;
  padding: 80px 20px;
  text-align: center;
  color: var(--ink-mute);
}

.empty-state-title {
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 22px;
  font-weight: 600;
  color: var(--ink);
  margin-bottom: 8px;
}

/* ───── LIGHTBOX ───── */
.lightbox {
  position: fixed;
  inset: 0;
  z-index: 200;
  background: rgba(0, 0, 0, 0.88);
  display: none;
  align-items: center;
  justify-content: center;
  cursor: zoom-out;
  padding: 40px;
  backdrop-filter: blur(4px);
  animation: lightbox-fade 0.18s ease;
}

.lightbox.open { display: flex; }

@keyframes lightbox-fade {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.lightbox-img {
  max-width: 100%;
  max-height: calc(100vh - 80px);
  object-fit: contain;
  border-radius: 4px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.6);
  cursor: default;
}

.lightbox-caption {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  color: rgba(255,255,255,0.85);
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 13px;
  text-align: center;
  pointer-events: none;
}

.lightbox-close {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(255,255,255,0.12);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  line-height: 1;
  transition: background 0.15s;
  border: none;
}

.lightbox-close:hover { background: rgba(255,255,255,0.22); }

.lightbox-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: rgba(255,255,255,0.12);
  color: #fff;
  font-size: 28px;
  line-height: 1;
  cursor: pointer;
  z-index: 5;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.15s;
  backdrop-filter: blur(6px);
}

.lightbox-arrow:hover { background: rgba(255,255,255,0.25); }
.lightbox-arrow--prev { left: 24px; padding-right: 4px; }
.lightbox-arrow--next { right: 24px; padding-left: 4px; }

.lightbox-counter {
  position: absolute;
  top: 24px;
  left: 24px;
  color: rgba(255,255,255,0.75);
  font-family: 'Inter', 'Noto Sans KR', sans-serif;
  font-size: 12px;
  letter-spacing: 0.05em;
  pointer-events: none;
  background: rgba(0,0,0,0.4);
  padding: 4px 10px;
  border-radius: 4px;
  backdrop-filter: blur(6px);
}

.lightbox.single .lightbox-arrow,
.lightbox.single .lightbox-counter { display: none; }

/* ───── HIDDEN ───── */
.card.hidden, .nav-item.hidden { display: none; }

/* ───── MOBILE ───── */
.mobile-toggle {
  display: none;
  width: 36px;
  height: 36px;
  border: 1px solid var(--border);
  border-radius: 8px;
  align-items: center;
  justify-content: center;
}

@media (max-width: 1024px) {
  :root { --sidebar-width: 240px; }
  .main { padding: 28px 28px 60px; }
}

@media (max-width: 768px) {
  .layout { grid-template-columns: 1fr; }
  .sidebar {
    position: fixed;
    top: var(--topbar-height);
    left: 0;
    width: 280px;
    height: calc(100vh - var(--topbar-height));
    transform: translateX(-100%);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 90;
    box-shadow: var(--shadow-md);
  }
  .sidebar.open { transform: translateX(0); }
  .mobile-toggle { display: inline-flex; }
  .main { padding: 24px 20px 60px; }
  .cards-grid { grid-template-columns: 1fr; }
  .search-wrap { display: none; }
  .topbar { padding: 0 16px; gap: 12px; }
  .hero-stats { gap: 24px; }
}

/* ───── PRINT ───── */
@media print {
  .topbar, .sidebar, .glossary { display: none; }
  .main { padding: 0; }
  .layout { grid-template-columns: 1fr; margin: 0; }
  .card { break-inside: avoid; box-shadow: none; border: 1px solid #999; }
}

</style>
</head>
<body data-theme="light">

<!-- ───── TOP BAR ───── -->
<header class="topbar">
  <button class="icon-btn mobile-toggle" id="mobile-toggle" aria-label="Toggle sidebar">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M2 4h12M2 8h12M2 12h12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
  </button>

  <div class="brand">
    <span class="brand-mark">KSA Landmarks</span>
    <span class="brand-meta">3D · Reference</span>
  </div>

  <div class="search-wrap">
    <svg class="search-icon" width="14" height="14" viewBox="0 0 14 14" fill="none">
      <circle cx="6" cy="6" r="4.5" stroke="currentColor" stroke-width="1.4"/>
      <path d="M9.5 9.5 L13 13" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
    </svg>
    <input type="text" class="search-input" id="search" placeholder="검색 — 이름, 도시, 타입, 태그..." autocomplete="off">
    <span class="search-kbd">⌘K</span>
  </div>

  <div class="topbar-actions">
    <button class="icon-btn" id="theme-toggle" aria-label="Toggle theme">
      <svg class="sun-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="3" stroke="currentColor" stroke-width="1.4"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3.05 3.05l1.41 1.41M11.54 11.54l1.41 1.41M3.05 12.95l1.41-1.41M11.54 4.46l1.41-1.41" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
      <svg class="moon-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13 9.5A6 6 0 1 1 6.5 3a4.5 4.5 0 0 0 6.5 6.5z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/></svg>
    </button>
  </div>
</header>

<!-- ───── LAYOUT ───── -->
<div class="layout">

  <aside class="sidebar" id="sidebar">

    <div class="sidebar-section">
      <div class="sidebar-heading">Tier</div>
      <div class="filter-chips" data-filter-group="tier">
        <button class="chip active" data-filter="all">All</button>
        <button class="chip" data-filter="tier-1" data-tier="tier-1">T1</button>
        <button class="chip" data-filter="tier-2" data-tier="tier-2">T2</button>
        <button class="chip" data-filter="tier-3" data-tier="tier-3">T3</button>
      </div>
    </div>

    <div class="sidebar-section">
      <div class="sidebar-heading">City</div>
      <div class="filter-chips" data-filter-group="city">
        <button class="chip" data-filter="city-RIYADH">Riyadh</button>
        <button class="chip" data-filter="city-JEDDAH">Jeddah</button>
        <button class="chip" data-filter="city-AL-KHOBAR">Al Khobar</button>
        <button class="chip" data-filter="city-DAMMAM">Dammam</button>
        <button class="chip" data-filter="city-ALULA">AlUla</button>
        <button class="chip" data-filter="city-MAKKAH">Makkah</button>
      </div>
    </div>

    <div class="sidebar-section">
      <div class="sidebar-heading">Type</div>
      <div class="filter-chips" data-filter-group="type">
        <button class="chip" data-filter="type-stadium">Stadium</button>
        <button class="chip" data-filter="type-mosque">Mosque</button>
        <button class="chip" data-filter="type-heritage">Heritage</button>
        <button class="chip" data-filter="type-tower">Tower</button>
        <button class="chip" data-filter="type-mall">Mall</button>
        <button class="chip" data-filter="type-museum">Museum</button>
        <button class="chip" data-filter="type-infra">Infra</button>
        <button class="chip" data-filter="type-edu">Education</button>
        <button class="chip" data-filter="type-park">Park</button>
        <button class="chip" data-filter="type-resort">Resort</button>
        <button class="chip" data-filter="type-nature">Nature</button>
      </div>
    </div>

    <div class="sidebar-section">
      <div class="sidebar-heading">
        <span>Index</span>
        <span class="count" id="visible-count">{{TOTAL}}/{{TOTAL}}</span>
      </div>
      <nav class="nav-list" id="nav-list">
{{SIDEBAR}}
      </nav>
    </div>

  </aside>

  <main class="main">

    <section class="hero">
      <div class="hero-eyebrow">Saudi Arabia · {{TOTAL}} Landmarks</div>
      <h1 class="hero-title">3D Modeling <em>Reference</em> for Map Application</h1>
      <p class="hero-desc">사우디아라비아 {{CITIES}}개 도시의 주요 랜드마크 {{TOTAL}}곳에 대한 3D 모델링 참고 자료. 각 항목별로 모델링 시 놓치면 안 되는 핵심 포인트, 구조 정보, 외부 레퍼런스 링크를 정리했습니다.</p>
      <div class="hero-stats">
        <div class="stat"><span class="stat-num">{{TOTAL}}</span><span class="stat-label">Landmarks</span></div>
        <div class="stat"><span class="stat-num">{{T1}}</span><span class="stat-label">Tier 1 · 핵심</span></div>
        <div class="stat"><span class="stat-num">{{T2}}</span><span class="stat-label">Tier 2 · 주요</span></div>
        <div class="stat"><span class="stat-num">{{T3}}</span><span class="stat-label">Tier 3 · 추가</span></div>
        <div class="stat"><span class="stat-num">{{CITIES}}</span><span class="stat-label">Cities</span></div>
      </div>
    </section>

    <!-- ───── DELIVERY SPEC (글로벌 납품 사양 헤더) ───── -->
    <section class="delivery-spec">
      <header class="delivery-spec-head">
        <span class="delivery-spec-eyebrow">Delivery Spec</span>
        <h2 class="delivery-spec-title">납품 사양</h2>
        <p class="delivery-spec-sub">전 카드 공통 모델링 룰</p>
      </header>

      <div class="spec-group">
        <div class="spec-group-head">Delivery Format</div>
        <dl class="spec-list">
          <div class="spec-item">
            <dt>단위</dt>
            <dd><strong>미터(m)</strong> — 익스포트 전 씬 단위 확인 필수, 불일치 시 납품 불합격</dd>
          </div>
          <div class="spec-item">
            <dt>좌표계</dt>
            <dd><code>EPSG:4326</code> <span class="spec-muted">(WGS84)</span> 경위도 · 소수점 8자리 이상 정밀도</dd>
          </div>
          <div class="spec-item">
            <dt>포맷</dt>
            <dd><code>.glb</code> 바이너리</dd>
          </div>
          <div class="spec-item">
            <dt>텍스처</dt>
            <dd>기본 <strong>미포함</strong></dd>
          </div>
        </dl>
      </div>

      <div class="spec-group">
        <div class="spec-group-head">Geometry Rules</div>
        <dl class="spec-list">
          <div class="spec-item">
            <dt>메시</dt>
            <dd>가시 면(Visible Face)만 · 삼각형 면 · 비가시·하단·접합 면 제외 · Non-manifold 미허용</dd>
          </div>
          <div class="spec-item">
            <dt>Footprint</dt>
            <dd>위탁자 제공 <code>EPSG:3857</code> 폴리곤 기준 위치 정합 + 기저면 정렬</dd>
          </div>
          <div class="spec-item spec-item--deprecated">
            <dt>폴리곤 한도</dt>
            <dd>
              <span class="budget-pill">소형 ≤3,000</span>
              <span class="budget-pill">중형 ≤10,000</span>
              <span class="budget-pill">대형 ≤20,000</span>
              <span class="budget-pill">초대형 ≤50,000</span>
            </dd>
          </div>
        </dl>
      </div>
    </section>

    <section class="glossary" id="glossary">
      <button class="glossary-head" onclick="document.getElementById('glossary').classList.toggle('open')">
        <div class="glossary-head-text">
          <span class="glossary-head-title">Glossary</span>
          <span class="glossary-head-sub">건축 양식 · 용어 사전</span>
        </div>
        <svg class="glossary-arrow" width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M3 5l4 4 4-4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </button>
      <div class="glossary-body">
        <div class="glossary-inner">
{{GLOSSARY}}
        </div>
      </div>
    </section>

    <section>
      <div class="cards-header">
        <h2 class="cards-title">Landmarks</h2>
        <div class="density-toggle" role="group" aria-label="밀도 전환">
          <button class="density-btn active" data-density="expanded">Detailed</button>
          <button class="density-btn" data-density="compact">Compact</button>
        </div>
        <span class="cards-count" id="cards-count">{{TOTAL}} items</span>
      </div>
      <div class="cards-grid" id="cards-grid">
{{CARDS}}
        <div class="empty-state" id="empty-state" style="display:none">
          <div class="empty-state-title">No matches</div>
          <p>다른 필터나 검색어를 시도해보세요.</p>
        </div>
      </div>
    </section>

  </main>
</div>

<!-- ───── GLOSSARY TOOLTIP (single fixed element) ───── -->
<div class="gloss-tooltip" id="gloss-tooltip" role="tooltip" aria-hidden="true">
  <div class="gloss-tooltip-head" id="gloss-tooltip-head"></div>
  <div class="gloss-tooltip-body" id="gloss-tooltip-body"></div>
</div>

<!-- ───── LIGHTBOX ───── -->
<div class="lightbox" id="lightbox" role="dialog" aria-modal="true" aria-label="이미지 확대보기">
  <span class="lightbox-counter" id="lightbox-counter"></span>
  <button class="lightbox-close" id="lightbox-close" aria-label="닫기">×</button>
  <button class="lightbox-arrow lightbox-arrow--prev" id="lightbox-prev" aria-label="이전 이미지">‹</button>
  <button class="lightbox-arrow lightbox-arrow--next" id="lightbox-next" aria-label="다음 이미지">›</button>
  <img class="lightbox-img" id="lightbox-img" alt="">
  <div class="lightbox-caption" id="lightbox-caption"></div>
</div>

<script>

(function(){
  // ─── 새로고침 시 스크롤 복원 막기 — 해시(#card-XX) 있을 때만 그곳으로 ───
  if ('scrollRestoration' in history) history.scrollRestoration = 'manual';

  function jumpTopIfNoHash() {
    if (window.location.hash) return;
    // 부드러운 스크롤 일시 차단 → 즉시 0으로
    const html = document.documentElement;
    const prev = html.style.scrollBehavior;
    html.style.scrollBehavior = 'auto';
    window.scrollTo(0, 0);
    html.style.scrollBehavior = prev;
  }

  jumpTopIfNoHash();
  // 이미지 lazy-load로 레이아웃이 늦게 잡히는 경우 대비해 load 시점에 한 번 더
  window.addEventListener('load', jumpTopIfNoHash, { once: true });

  // ─── THEME ───
  const themeBtn = document.getElementById('theme-toggle');
  const storedTheme = localStorage.getItem('ksa-theme');
  if (storedTheme === 'dark') document.body.setAttribute('data-theme', 'dark');
  themeBtn.addEventListener('click', () => {
    const isDark = document.body.getAttribute('data-theme') === 'dark';
    document.body.setAttribute('data-theme', isDark ? 'light' : 'dark');
    localStorage.setItem('ksa-theme', isDark ? 'light' : 'dark');
  });

  // ─── DENSITY (Detailed / Compact) ───
  const densityBtns = document.querySelectorAll('.density-btn');
  const storedDensity = localStorage.getItem('ksa-density');
  if (storedDensity === 'compact') {
    document.body.classList.add('density-compact');
    densityBtns.forEach(b => b.classList.toggle('active', b.dataset.density === 'compact'));
  }
  densityBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const d = btn.dataset.density;
      densityBtns.forEach(b => b.classList.toggle('active', b === btn));
      document.body.classList.toggle('density-compact', d === 'compact');
      localStorage.setItem('ksa-density', d);
    });
  });
  
  // ─── MOBILE SIDEBAR ───
  const sidebar = document.getElementById('sidebar');
  const mobileToggle = document.getElementById('mobile-toggle');
  if (mobileToggle) {
    mobileToggle.addEventListener('click', () => sidebar.classList.toggle('open'));
  }
  
  // ─── FILTERS ───
  const state = { tier: 'all', cities: new Set(), types: new Set(), search: '' };
  
  document.querySelectorAll('.filter-chips').forEach(group => {
    const groupType = group.dataset.filterGroup;
    group.addEventListener('click', e => {
      const btn = e.target.closest('.chip');
      if (!btn) return;
      const f = btn.dataset.filter;
      
      if (groupType === 'tier') {
        // single select
        group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
        btn.classList.add('active');
        state.tier = f;
      } else {
        // multi select
        const set = groupType === 'city' ? state.cities : state.types;
        if (set.has(f)) {
          set.delete(f);
          btn.classList.remove('active');
        } else {
          set.add(f);
          btn.classList.add('active');
        }
      }
      applyFilters();
    });
  });
  
  // ─── SEARCH ───
  const search = document.getElementById('search');
  search.addEventListener('input', e => {
    state.search = e.target.value.toLowerCase().trim();
    applyFilters();
  });
  
  // ⌘K shortcut
  document.addEventListener('keydown', e => {
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      search.focus();
      search.select();
    }
    if (e.key === 'Escape' && document.activeElement === search) {
      search.value = '';
      state.search = '';
      applyFilters();
      search.blur();
    }
  });
  
  // ─── APPLY ───
  function applyFilters() {
    let visible = 0;
    document.querySelectorAll('.card').forEach(card => {
      const t = card.dataset.tier;
      const c = card.dataset.city;
      const ty = card.dataset.type;
      const s = card.dataset.search || '';
      
      const tierOk = state.tier === 'all' || t === state.tier;
      const cityOk = state.cities.size === 0 || state.cities.has(c);
      const typeOk = state.types.size === 0 || state.types.has(ty);
      const searchOk = !state.search || s.includes(state.search);
      
      const show = tierOk && cityOk && typeOk && searchOk;
      card.classList.toggle('hidden', !show);
      
      // sync nav
      const navItem = document.querySelector(`.nav-item[href="#${card.id}"]`);
      if (navItem) navItem.classList.toggle('hidden', !show);
      
      if (show) visible++;
    });
    
    const countEl = document.getElementById('cards-count');
    const navCountEl = document.getElementById('visible-count');
    const total = {{TOTAL}};
    countEl.textContent = visible === total ? `${total} items` : `${visible} / ${total}`;
    navCountEl.textContent = `${visible}/${total}`;

    // Tier 헤더: 그 tier에 보이는 카드가 없으면 헤더도 숨김
    document.querySelectorAll('.tier-header').forEach(h => {
      const tier = h.dataset.tier;
      const visibleInTier = document.querySelectorAll(`.card[data-tier="${tier}"]:not(.hidden)`).length;
      h.classList.toggle('hidden', visibleInTier === 0);
    });

    document.getElementById('empty-state').style.display = visible === 0 ? 'block' : 'none';
  }
  
  // ─── ACTIVE NAV (scroll spy) ───
  const cards = document.querySelectorAll('.card');
  const navItems = document.querySelectorAll('.nav-item');
  const intersecting = new Set();
  let activeNavId = null;
  let suppressSpyUntil = 0;

  function setActiveCard(cardId, opts = {}) {
    if (!cardId || cardId === activeNavId) return;
    const navItem = document.querySelector(`.nav-item[href="#${cardId}"]`);
    if (!navItem) return;
    navItems.forEach(n => n.classList.remove('active'));
    navItem.classList.add('active');
    activeNavId = cardId;

    // sidebar 자동 스크롤은 nav-item이 사이드바 가시영역을 벗어났을 때만
    const sb = sidebar;
    const navRect = navItem.getBoundingClientRect();
    const sbRect = sb.getBoundingClientRect();
    const outOfView = navRect.top < sbRect.top + 4 || navRect.bottom > sbRect.bottom - 4;
    if (outOfView && !opts.skipScroll) {
      navItem.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }

  function pickTopmost() {
    let best = null;
    let bestTop = Infinity;
    for (const id of intersecting) {
      const c = document.getElementById(id);
      if (!c || c.classList.contains('hidden')) continue;
      const top = c.getBoundingClientRect().top;
      if (top < bestTop) { best = id; bestTop = top; }
    }
    return best;
  }

  const observer = new IntersectionObserver(entries => {
    for (const e of entries) {
      if (e.isIntersecting) intersecting.add(e.target.id);
      else intersecting.delete(e.target.id);
    }
    if (Date.now() < suppressSpyUntil) return;
    const top = pickTopmost();
    if (top) setActiveCard(top);
  }, { rootMargin: '-72px 0px -55% 0px', threshold: 0 });

  cards.forEach(card => observer.observe(card));

  // ─── NAV CLICK ───
  navItems.forEach(item => {
    item.addEventListener('click', () => {
      const href = item.getAttribute('href') || '';
      const id = href.startsWith('#') ? href.slice(1) : '';
      if (id) {
        // 클릭한 항목을 즉시 활성화하고, 부드러운 스크롤이 끝날 때까지 spy를 잠시 멈춤
        suppressSpyUntil = Date.now() + 800;
        navItems.forEach(n => n.classList.remove('active'));
        item.classList.add('active');
        activeNavId = id;
      }
      if (window.innerWidth <= 768) sidebar.classList.remove('open');
    });
  });
  
  // ─── IMAGE ERROR FALLBACK ───
  document.querySelectorAll('.card-image img').forEach(img => {
    img.addEventListener('error', function() {
      try {
        if (this.parentElement) {
          this.style.display = 'none';
          // slider 안에 다른 슬라이드가 있으면 placeholder 처리하지 않음
          const card = this.closest('.card');
          if (card && card.querySelectorAll('.card-slide').length <= 1) {
            const wrap = this.closest('.card-image');
            if (wrap) wrap.classList.add('no-image');
          }
        }
      } catch(e) {}
    });
  });

  // ─── CARD SLIDER ───
  // 각 슬라이더의 현재 인덱스를 별도 보관 (라이트박스 시작점에 사용)
  const sliderState = new WeakMap();

  document.querySelectorAll('.card-slider').forEach(slider => {
    const slides = Array.from(slider.querySelectorAll('.card-slide'));
    if (slides.length === 0) return;
    slides[0].classList.add('active');
    sliderState.set(slider, 0);
    if (slides.length === 1) return;

    const dots = Array.from(slider.querySelectorAll('.card-dot'));
    const prev = slider.querySelector('.card-arrow--prev');
    const next = slider.querySelector('.card-arrow--next');

    const counter = slider.querySelector('.card-counter');
    function go(newIdx) {
      const n = slides.length;
      const i = ((newIdx % n) + n) % n;
      slides.forEach((s, k) => s.classList.toggle('active', k === i));
      dots.forEach((d, k) => d.classList.toggle('active', k === i));
      if (counter) counter.textContent = `${i + 1} / ${n}`;
      sliderState.set(slider, i);
    }

    prev?.addEventListener('click', e => { e.stopPropagation(); go(sliderState.get(slider) - 1); });
    next?.addEventListener('click', e => { e.stopPropagation(); go(sliderState.get(slider) + 1); });
    dots.forEach((d, i) => d.addEventListener('click', e => { e.stopPropagation(); go(i); }));

    // 터치 스와이프 (모바일)
    let touchStartX = null;
    slider.addEventListener('touchstart', e => { touchStartX = e.changedTouches[0].clientX; }, {passive: true});
    slider.addEventListener('touchend', e => {
      if (touchStartX === null) return;
      const dx = e.changedTouches[0].clientX - touchStartX;
      if (Math.abs(dx) > 40) go(sliderState.get(slider) + (dx < 0 ? 1 : -1));
      touchStartX = null;
    }, {passive: true});
  });

  // ─── LIGHTBOX (이미지 확대보기 + 다중 이미지 네비게이션) ───
  const lightbox = document.getElementById('lightbox');
  const lightboxImg = document.getElementById('lightbox-img');
  const lightboxCaption = document.getElementById('lightbox-caption');
  const lightboxCounter = document.getElementById('lightbox-counter');
  const lightboxClose = document.getElementById('lightbox-close');
  const lightboxPrev = document.getElementById('lightbox-prev');
  const lightboxNext = document.getElementById('lightbox-next');

  let lbImages = [];
  let lbIndex = 0;
  let lbCaption = '';

  function showLightboxFrame() {
    if (!lbImages.length) return;
    lightboxImg.src = lbImages[lbIndex];
    lightboxImg.alt = lbCaption || '';
    if (lbImages.length > 1) {
      lightboxCounter.textContent = `${lbIndex + 1} / ${lbImages.length}`;
      lightbox.classList.remove('single');
    } else {
      lightboxCounter.textContent = '';
      lightbox.classList.add('single');
    }
  }

  function openLightbox(images, startIdx, caption) {
    lbImages = images;
    lbIndex = startIdx || 0;
    lbCaption = caption || '';
    lightboxCaption.textContent = caption || '';
    showLightboxFrame();
    lightbox.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeLightbox() {
    lightbox.classList.remove('open');
    lightboxImg.src = '';
    lbImages = [];
    document.body.style.overflow = '';
  }

  function lbStep(d) {
    if (lbImages.length < 2) return;
    const n = lbImages.length;
    lbIndex = ((lbIndex + d) % n + n) % n;
    showLightboxFrame();
  }

  document.querySelectorAll('.card-image img').forEach(img => {
    img.addEventListener('click', e => {
      e.stopPropagation();
      const card = img.closest('.card');
      let title = '';
      if (card) {
        const t = card.querySelector('.card-title');
        title = (t?.innerText || t?.textContent || '').replace(/\s+/g, ' ').trim();
        const sub = card.querySelector('.card-subtitle');
        if (sub) title += ' ' + sub.textContent.trim();
      }
      // 같은 카드의 모든 슬라이드 src 수집
      const slider = img.closest('.card-slider');
      let images = [img.src];
      let startIdx = 0;
      if (slider) {
        const slides = Array.from(slider.querySelectorAll('.card-slide'));
        images = slides.map(s => s.src);
        startIdx = slides.indexOf(img);
        if (startIdx < 0) startIdx = sliderState.get(slider) || 0;
      }
      openLightbox(images, startIdx, title);
    });
  });

  lightbox.addEventListener('click', e => {
    if (e.target === lightboxImg) return;
    if (e.target.closest('.lightbox-arrow')) return;
    closeLightbox();
  });
  lightboxClose.addEventListener('click', e => { e.stopPropagation(); closeLightbox(); });
  lightboxPrev.addEventListener('click', e => { e.stopPropagation(); lbStep(-1); });
  lightboxNext.addEventListener('click', e => { e.stopPropagation(); lbStep(1); });

  document.addEventListener('keydown', e => {
    if (!lightbox.classList.contains('open')) return;
    if (e.key === 'Escape') closeLightbox();
    else if (e.key === 'ArrowLeft') lbStep(-1);
    else if (e.key === 'ArrowRight') lbStep(1);
  });

  // ─── GLOSSARY HOVER ───
  const GLOSS = {{GLOSSARY_JSON}};

  function buildGlossCtx() {
    const sorted = GLOSS.slice().sort((a, b) => b.kr.length - a.kr.length);
    const map = {};
    const patterns = [];
    for (const t of sorted) {
      const key = t.kr.replace(/\s+/g, '');
      if (map[key]) continue; // dedupe by normalized kr
      map[key] = t;
      const escaped = t.kr.replace(/[.*+?^${}()|[\]\\]/g, '\\$&').replace(/\s+/g, '\\s*');
      patterns.push(escaped);
    }
    return { re: new RegExp('(' + patterns.join('|') + ')', 'g'), map };
  }

  function wrapGlossInRoot(root, ctx) {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode(n) {
        if (!n.nodeValue || !n.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
        let p = n.parentNode;
        while (p && p !== root) {
          if (p.nodeType === 1) {
            const tag = p.tagName;
            if (tag === 'A' || tag === 'SCRIPT' || tag === 'STYLE') return NodeFilter.FILTER_REJECT;
            if (p.classList && (p.classList.contains('gloss-mark') || p.classList.contains('section-heading'))) {
              return NodeFilter.FILTER_REJECT;
            }
          }
          p = p.parentNode;
        }
        return ctx.re.test(n.nodeValue) ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_REJECT;
      }
    });

    const targets = [];
    let cur;
    while ((cur = walker.nextNode())) targets.push(cur);

    for (const tn of targets) {
      const text = tn.nodeValue;
      ctx.re.lastIndex = 0;
      const frag = document.createDocumentFragment();
      let last = 0;
      let m;
      while ((m = ctx.re.exec(text)) !== null) {
        const matchText = m[0];
        const start = m.index;
        if (start > last) frag.appendChild(document.createTextNode(text.slice(last, start)));
        const term = ctx.map[matchText.replace(/\s+/g, '')];
        if (term) {
          const span = document.createElement('span');
          span.className = 'gloss-mark';
          span.tabIndex = 0;
          span.setAttribute('data-kr', term.kr);
          span.setAttribute('data-en', term.en);
          span.setAttribute('data-desc', term.desc);
          span.textContent = matchText;
          frag.appendChild(span);
        } else {
          frag.appendChild(document.createTextNode(matchText));
        }
        last = start + matchText.length;
      }
      if (last < text.length) frag.appendChild(document.createTextNode(text.slice(last)));
      tn.parentNode.replaceChild(frag, tn);
    }
  }

  if (GLOSS && GLOSS.length) {
    const ctx = buildGlossCtx();
    document.querySelectorAll('.card-content').forEach(c => wrapGlossInRoot(c, ctx));

    // 단일 fixed 툴팁 — 어떤 컨테이너의 overflow에도 영향 안 받음
    const tip = document.getElementById('gloss-tooltip');
    const tipHead = document.getElementById('gloss-tooltip-head');
    const tipBody = document.getElementById('gloss-tooltip-body');
    const PAD = 8;
    const GAP = 8;
    let activeMark = null;

    function showGloss(mark) {
      activeMark = mark;
      tipHead.textContent = `${mark.dataset.en} · ${mark.dataset.kr}`;
      tipBody.textContent = mark.dataset.desc;
      tip.classList.add('open');
      tip.setAttribute('aria-hidden', 'false');
      positionGloss();
    }

    function hideGloss() {
      activeMark = null;
      tip.classList.remove('open');
      tip.setAttribute('aria-hidden', 'true');
    }

    function positionGloss() {
      if (!activeMark) return;
      const m = activeMark.getBoundingClientRect();
      const vpW = window.innerWidth;
      const vpH = window.innerHeight;
      const tipW = tip.offsetWidth;
      const tipH = tip.offsetHeight;

      // 가로: 마크 좌측 기준으로 두되 양쪽 뷰포트 안에 들어가도록 클램프
      let left = m.left;
      if (left + tipW > vpW - PAD) left = vpW - tipW - PAD;
      if (left < PAD) left = PAD;

      // 세로: 기본 마크 위. 위에 공간 부족하면 아래로
      let top = m.top - tipH - GAP;
      if (top < PAD) top = m.bottom + GAP;
      if (top + tipH > vpH - PAD) top = Math.max(PAD, vpH - tipH - PAD);

      tip.style.left = `${left}px`;
      tip.style.top = `${top}px`;
    }

    document.querySelectorAll('.gloss-mark').forEach(m => {
      m.addEventListener('mouseenter', () => showGloss(m));
      m.addEventListener('mouseleave', hideGloss);
      m.addEventListener('focus', () => showGloss(m));
      m.addEventListener('blur', hideGloss);
    });

    window.addEventListener('scroll', () => { if (activeMark) positionGloss(); }, true);
    window.addEventListener('resize', () => { if (activeMark) positionGloss(); });
  }

})();

</script>
</body>
</html>
