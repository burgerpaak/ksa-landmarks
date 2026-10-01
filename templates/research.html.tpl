<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow, noarchive, noimageindex">
<title>Research · KSA Landmarks</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
{{PALETTE}}
/* Section spacing ownership: see UI_LAYOUT.md. Controls belong to each city header. */
:root { --research-section-inset: 24px; --research-section-gap: 28px; }
* { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body { background: var(--bg); color: var(--ink); font: 14px/1.65 'Inter', 'Noto Sans KR', sans-serif; -webkit-font-smoothing: antialiased; word-break: keep-all; overflow-wrap: anywhere; }
a { color: inherit; text-decoration: none; }
button, input, select { font: inherit; color: inherit; }
button { cursor: pointer; }
a:focus-visible, button:focus-visible, summary:focus-visible, select:focus-visible { outline: 2px solid var(--accent-strong); outline-offset: 4px; }
[hidden] { display: none !important; }
.topbar { position: fixed; inset: 0 0 auto; height: var(--topbar-height); z-index: 100; display: flex; align-items: center; gap: 24px; padding: 0 24px; border-bottom: 1px solid var(--border); background: color-mix(in srgb, var(--bg-elev) 94%, transparent); backdrop-filter: blur(12px); }
.brand { display: flex; flex-direction: column; flex-shrink: 0; line-height: 1; }
.brand-mark { font-size: 17px; font-weight: 700; letter-spacing: -.02em; }
.brand-meta { margin-top: 5px; font: 9.5px var(--mono); letter-spacing: .1em; color: var(--ink-mute); text-transform: uppercase; }
.topbar-nav { display: flex; gap: 4px; margin-inline: var(--nav-group-inset); flex-shrink: 0; }
.topbar-nav a { position: relative; padding: 6px var(--nav-link-inset); border-radius: 6px; background: transparent; color: var(--ink-soft); font-size: 12.5px; font-weight: 500; transition: background 0.14s ease, color 0.14s ease; }
.topbar-nav a.active { background: transparent; color: var(--ink); font-weight: 600; }
.topbar-nav a:hover { background: var(--bg-sunken); color: var(--ink); }
.topbar-nav a.active::after { content: ''; position: absolute; left: var(--nav-link-inset); right: var(--nav-link-inset); bottom: 0; height: 2px; border-radius: 1px; background: currentColor; }
@media (max-width: 640px) { .topbar-nav { --nav-link-inset: 8px; --nav-group-inset: 0px; } }
.theme-toggle { margin-left: auto; width: 36px; height: 36px; border: 1px solid var(--border); border-radius: 10px; background: var(--bg-elev); color: var(--ink-soft); font-size: 19px; }
.main { max-width: 1440px; padding: calc(var(--topbar-height) + 32px) 40px 80px; margin: auto; }
.eyebrow { font-size: 11px; color: var(--accent); letter-spacing: .12em; margin-bottom: 12px; }
.page-head { display: flex; gap: 24px; justify-content: space-between; align-items: center; margin-bottom: var(--research-section-inset); }
h1 { font-size: clamp(32px, 3.8vw, 44px); line-height: 1.05; letter-spacing: -.025em; font-weight: 700; }
h1 em { font-style: normal; color: var(--accent); }
.page-sub { color: var(--ink-soft); margin-top: 12px; font-size: 15px; line-height: 1.6; max-width: 60ch; }
.check-date { font: 10px var(--mono); color: var(--ink-mute); white-space: nowrap; }
.overview { display: flex; flex-wrap: wrap; gap: 24px; padding: 18px 0; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
.city-overview { display: flex; align-items: center; gap: 20px; }
.city-overview + .city-overview { border-left: 1px solid var(--border); padding-left: 24px; }
.city-jump { font-size: 16px; font-weight: 600; color: var(--ink); }
.hero-stats { display: flex; align-items: center; gap: 20px; }
.stat { display: flex; align-items: center; gap: 5px; }
.stat-num { font-size: 13px; font-weight: 500; color: var(--ink-soft); }
.stat-label { font-size: 13px; color: var(--ink-soft); }
.jump-link:hover { color: var(--accent-strong); text-decoration: underline; text-underline-offset: 4px; }
.search-wrap { flex: 1; min-width: 120px; max-width: 480px; position: relative; }
.search-input { width: 100%; height: 36px; padding: 0 58px 0 38px; background: var(--bg-sunken); border: 1px solid transparent; border-radius: 10px; color: var(--ink); font-family: inherit; font-size: 13px; outline: none; }
.search-input:focus { border-color: color-mix(in srgb, var(--accent) 50%, var(--border)); background: var(--bg-elev); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 12%, transparent); }
.search-input::-webkit-search-cancel-button { -webkit-appearance: none; appearance: none; }
.search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--ink-mute); pointer-events: none; }
.search-kbd { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); font-size: 10px; color: var(--ink-mute); background: var(--bg); border: 1px solid var(--border); padding: 2px 6px; border-radius: 4px; pointer-events: none; }
.search-clear { position: absolute; right: 6px; top: 50%; transform: translateY(-50%); display: grid; place-items: center; width: 28px; height: 28px; padding: 0; border: 0; border-radius: 7px; background: transparent; color: var(--ink-mute); }
.search-clear:hover { background: var(--bg-sunken); color: var(--ink); }
.search-clear:focus-visible { outline-offset: 0; color: var(--ink); }
.status-control { position: relative; display: inline-flex; align-items: center; flex-shrink: 0; }
.status-control select { appearance: none; cursor: pointer; font-size: 11px; background: var(--bg-elev); border: 1px solid var(--border); border-radius: 7px; padding: 6px 27px 6px 11px; color: var(--ink-soft); }
.status-control .chevron { position: absolute; right: 8px; width: 12px; height: 12px; pointer-events: none; }
/* Hover, keyboard focus and tap share the same help content. */
.display-help { position: relative; }
.help-trigger { display: flex; align-items: center; justify-content: center; width: 32px; height: 32px; border: 0; background: transparent; color: var(--ink-mute); border-radius: 6px; }
.help-trigger:hover, .help-trigger:focus-visible { color: var(--ink); background: var(--bg-sunken); }
.help-trigger svg { width: 18px; height: 18px; fill: none; stroke: currentColor; stroke-width: 1.4; }
.help-trigger .info-dot { fill: currentColor; stroke: none; }
.help-tooltip { position: absolute; top: 100%; right: 0; z-index: 5; width: min(320px, calc(100vw - 40px)); padding: 14px 16px; border: 1px solid var(--border); border-radius: 10px; background: var(--tooltip-surface); box-shadow: 0 6px 18px rgb(0 0 0 / 22%); color: var(--tooltip-text); font-size: 12px; line-height: 1.7; }
.city-section, .scope-section, .research-card { scroll-margin-top: calc(var(--topbar-height) + 20px); }
.city-section { padding-top: var(--research-section-inset); }
.section-head { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px 24px; padding: 0 0 18px; }
.section-title { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
/* The 32px help target already includes 7px on each side of its 18px icon. */
.section-controls { display: flex; align-items: center; gap: 4px; margin-left: auto; }
.section-head h2 { display: inline-flex; align-items: center; font-size: 18px; font-weight: 600; letter-spacing: -.025em; }
.section-count { display: inline-flex; margin-left: 8px; vertical-align: 1px; font: 10px var(--mono); padding: 3px 6px; background: var(--bg-sunken); color: var(--ink-soft); border-radius: 4px; }
.section-title > p { font-size: 11px; color: var(--ink-mute); }
.scope-section { margin-top: 28px; margin-left: 8px; padding-left: 18px; border-left: 2px solid var(--border); }
.scope-head { display: flex; align-items: center; gap: 8px 12px; flex-wrap: wrap; padding: 0 0 16px; }
.scope-head h3 { display: inline-flex; align-items: center; font-size: 14px; font-weight: 600; }
.scope-head > span, .scope-count { color: var(--ink-mute); font-size: 10px; }
.scope-count { margin-left: 6px; font-family: var(--mono); }
.city-section + .city-section { margin-top: var(--research-section-gap); border-top: 1px solid var(--border); }
.cards-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 22px; align-items: start; }
.research-card { background: var(--bg-elev); border: 1px solid var(--border); border-radius: 12px; box-shadow: var(--shadow-sm); min-width: 0; overflow: hidden; }
.research-card:target { border-color: var(--accent-strong); box-shadow: 0 0 0 2px var(--accent-soft); }
.card-visual { position: relative; aspect-ratio: 4 / 3; background: linear-gradient(135deg, color-mix(in srgb, var(--accent) 7%, var(--bg-sunken)), var(--bg-sunken)); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: center; }
.photo-open { position:absolute;inset:0;width:100%;height:100%;padding:0;border:0;background:transparent;cursor:pointer;overflow:hidden; }
.photo-open img { display:block;width:100%;height:100%;object-fit:cover; }
.photo-open:focus-visible { outline:3px solid var(--accent-strong);outline-offset:-3px; }
.card-visual .card-meta { z-index:1;pointer-events:none; }
.photo-kind { position:absolute;left:12px;bottom:12px;padding:3px 7px;border-radius:4px;background:var(--bg-elev);color:var(--ink-soft);font-size:10px;pointer-events:none; }
.photo-gallery { display:grid;gap:20px;margin:10px 0 20px; }
.research-photo { margin:0; }
.photo-original { display:block;width:100%;padding:0;border:0;background:transparent;cursor:zoom-in; }
.research-photo img { display:block;width:100%;height:auto;max-height:440px;object-fit:contain;background:var(--bg-sunken);border-radius:6px; }
.research-photo figcaption p { margin:8px 0 0; }
.research-photo .photo-credit { font-size:11px;color:var(--ink-mute);line-height:1.7; }
.card-meta { position: absolute; top: 13px; left: 13px; right: 13px; display: flex; align-items: flex-start; gap: 8px; }
.badges { margin-left: auto; display: flex; justify-content: flex-end; flex-wrap: wrap; gap: 5px; }
.badge { -webkit-user-select: none; user-select: none; padding: 3px 7px; font-size: 9px; line-height: 1.5; border-radius: 4px; color: var(--ink-soft); background: var(--bg-elev); white-space: nowrap; }
/* Inverse surface distinguishes contextual help from the card in both themes. */
.help-tooltip, .recommendation-tooltip {
 --tooltip-surface: var(--ink);
 --tooltip-text: var(--bg-elev);
}
.recommendation:focus-visible { outline:2px solid var(--accent); outline-offset:3px; }
.recommendation-tooltip { position:fixed; z-index:100; width:max-content; max-width:min(280px, calc(100vw - 24px)); padding:10px 12px; border:1px solid var(--border); border-radius:8px; background:var(--tooltip-surface); color:var(--tooltip-text); box-shadow:0 6px 18px rgb(0 0 0 / 22%); font-size:12px; line-height:1.65; font-weight:400; }
.badge.low { background: color-mix(in srgb, var(--warning) 9%, var(--bg-elev)); color: var(--warning); font-family: var(--mono); font-size: 8px; }
.badge.selected { color: var(--success); background: color-mix(in srgb, var(--success) 9%, var(--bg-elev)); }
.badge.excluded { color: var(--ink-mute); }
.badge.recommendation { border:0; font-family:inherit; cursor:help; color: #fff; font-size: 10px; padding: 3px 8px; flex-shrink: 0; margin-top: 1px; }
.recommendation.priority-1 { background: var(--accent-strong); }
.recommendation.priority-2 { background: color-mix(in srgb, var(--accent-strong) 58%, #1b2431); }
.recommendation.priority-3 { background: #3a4657; }
.placeholder-art { width: 68px; color: var(--ink-mute); opacity: .3; }
.placeholder-art svg { display: block; width: 100%; fill: none; stroke: currentColor; stroke-width: 1.25; }
.placeholder-caption { position: absolute; bottom: 23px; left: 15px; right: 15px; text-align: center; color: var(--ink-mute); font-size: 11px; }
.placeholder-caption small { display: block; font: 8px var(--mono); letter-spacing: .12em; margin-top: 4px; opacity: .65; }
.card-body { padding: 16px 20px 0; }
.card-heading { display: flex; align-items: flex-start; gap: 10px; justify-content: space-between; }
.card-heading h3, .card-heading h4 { min-width: 0; }
.research-card h3, .research-card h4 { font-size: 18px; line-height: 1.35; font-weight: 600; letter-spacing: -.035em; }
.area { margin-top: 6px; font-size: 10px; line-height: 1.65; color: var(--ink-mute); }
.card-tags { display: flex; flex-wrap: wrap; gap: 6px; margin: 10px 0; }
.card-tags span { font-size: 9px; color: var(--ink-soft); border: 1px solid var(--border); border-radius: 4px; padding: 2px 6px; }
.card-tags .type-badge { color: var(--accent); background: color-mix(in srgb, var(--accent) 7%, var(--bg-elev)); border-color: color-mix(in srgb, var(--accent) 22%, var(--border)); -webkit-user-select: none; user-select: none; }
.panel-content > .card-tags { margin: 10px 0 16px; }
.panel-content .type-badge { font-size: 10px; }
.area + .character { margin-top: 10px; }
.connected-building { display:block;max-width:100%;margin:8px 0 0;padding:0;border:0;background:none;color:var(--accent);font:inherit;font-size:11px;line-height:1.65;text-align:left;cursor:pointer; }
.connected-building:hover { text-decoration:underline; }
.connected-building:focus-visible { outline:2px solid currentColor;outline-offset:3px; }
.connected-building + .character { margin-top:10px; }
.building-relation .connected-building { font-size:12px;margin-top:8px; }
.character { color: var(--ink-soft); font-size: 11px; line-height: 1.85; margin-bottom: 13px; }
.model-scope-note { color: var(--accent); font-size: 11px; line-height: 1.75; margin-bottom: 13px; }
.decision-note { margin: 0 0 13px; padding: 7px 9px; border-left: 2px solid color-mix(in srgb, var(--warning) 45%, var(--border)); background: color-mix(in srgb, var(--warning) 4%, var(--bg-elev)); color: var(--ink-soft); font-size: 10px; line-height: 1.75; }
.decision-note > span { color: var(--warning); margin-right: 7px; font-weight: 500; white-space: nowrap; }
.card-actions { display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;column-gap:12px;border-top:1px solid var(--border); }
.card-actions details[open] { flex-basis:100%; }
summary { display: flex; align-items: center; gap: 9px; cursor: pointer; list-style: none; padding: 14px 0; font-size: 11px; font-weight: 500; color: var(--ink-soft); }
summary::-webkit-details-marker { display: none; }
.chevron { width: 15px; height: 15px; flex-shrink: 0; fill: none; stroke: currentColor; stroke-width: 1.5; transition: transform .15s; }
details[open] summary > .chevron { transform: rotate(180deg); }
.card-external-links { display:flex;align-items:center;gap:12px;padding:14px 0; }
.map-link, .image-search-link { font-size:11px;color:var(--ink-mute);white-space:nowrap; }
.map-link:hover, .image-search-link:hover, .sources a:hover { color: var(--accent-strong); text-decoration: underline; }
.detail-body { padding: 0 0 20px; font-size: 11px; color: var(--ink-soft); line-height: 1.85; }
.detail-body h5 { font-size: 10px; font-weight: 500; color: var(--ink-mute); margin: 14px 0 4px; }
.sources { list-style: none; }
.sources li + li { margin-top: 7px; }
.sources a { color: var(--accent); }
.section-empty { border: 1px dashed var(--border); border-radius: 9px; padding: 24px; color: var(--ink-mute); font-size: 12px; }
.footer { color: var(--ink-mute); font-size: 10px; border-top: 1px solid var(--border); margin-top: 40px; padding-top: 18px; }
@media (max-width: 1000px) { .cards-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-width: 800px) {
 :root { --topbar-height: 112px; }
 .topbar { flex-wrap: wrap; align-content: center; gap: 8px 12px; }
 .topbar .search-wrap { order: 4; flex: 0 0 100%; max-width: none; }
}
@media (max-width: 640px) {
 .topbar { padding: 0 12px; gap: 10px; }
 .brand-mark { font-size: 13px; } .brand-meta { font-size: 8px; }
 .topbar-nav { gap: 3px; } .topbar-nav a { padding: 6px 8px; font-size: 11px; }
 .theme-toggle { width: 30px; height: 30px; flex-shrink: 0; }
 .main { padding: calc(var(--topbar-height) + 24px) 20px 60px; }
 .page-head { display: block; } .check-date { margin-top: 10px; }
 .overview { flex-direction: column; align-items: flex-start; gap: 16px; }
 .city-overview + .city-overview { border-left: 0; padding-left: 0; }
 .city-jump { min-width: 52px; }
 .hero-stats { gap: 16px; }
 .cards-grid { grid-template-columns: 1fr; gap: 18px; }
 .section-title { gap: 6px 12px; }
 .section-controls { flex-basis: 100%; justify-content: flex-end; }
 .scope-section { margin-left: 0; padding-left: 10px; }
 .area { margin-top: 8px; } .character { font-size: 12px; }
}
@media (max-width: 375px) {
 :root { --topbar-height: 144px; }
 .topbar { flex-wrap: wrap; align-content: center; gap: 8px 12px; }
 .topbar-nav { order: 3; flex-basis: 100%; justify-content: center; }
}
@media (prefers-reduced-motion: reduce) { html { scroll-behavior: auto; } .chevron { transition: none; } }
@media print { .topbar, .section-controls, .overview { display: none; } .main { padding: 0; } .research-card { break-inside: avoid; } }

/* Detail overlay: same layout as the approved preview. */
html { scrollbar-gutter: stable; }
.detail-panel-trigger { display:flex;align-items:center;gap:9px;border:0;background:transparent;padding:14px 0;font-size:11px;font-weight:500;color:var(--ink-soft); }
.detail-panel-trigger svg { width:15px;height:15px;fill:none;stroke:currentColor;stroke-width:1.5; }
.detail-panel { position:fixed;inset:0 0 0 auto;margin:0;width:min(480px,100vw);height:100dvh;max-width:100vw;max-height:100dvh;border:0;border-left:1px solid var(--border);background:var(--bg-elev);color:var(--ink);padding:0;box-shadow:-12px 0 48px #0e131b20;overflow:hidden; }
.detail-panel[open] { padding-top:64px;display:flex;flex-direction:column;animation:panel-in .2s ease-out; }
.detail-panel::backdrop { background:rgb(14 19 27 / .12); }
.panel-close { position:absolute;top:18px;right:24px;z-index:2;width:36px;height:36px;border:1px solid var(--border);border-radius:8px;background:var(--bg-elev);color:var(--ink-soft);display:grid;place-items:center; }
.panel-close svg { width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:1.5; }
.panel-content { flex:1;min-height:0;padding:8px 24px 24px;overflow:auto;overscroll-behavior:contain; }
.panel-heading { display:flex;align-items:center;gap:12px; }
.panel-heading .badge.recommendation { margin-top:0; }
.panel-heading h2 { min-width:0;font-size:24px;font-weight:600;line-height:1.3;letter-spacing:-.025em; }
.panel-content .area { font-size:12px;margin:10px 0 0; }
.panel-content .character { font-size:13px;margin:20px 0 12px; }
.panel-content .decision-note { font-size:12px;margin-bottom:12px; }
.panel-content .detail-body { border-top:1px solid var(--border);padding-top:4px;font-size:13px; }
.panel-content .detail-body h5 { font-size:13px;font-weight:600;color:var(--ink-soft);margin-top:20px;margin-bottom:6px; }
.panel-content .landmark-intro { font-size:13px;line-height:1.85;margin:20px 0 12px; }
.panel-content .landmark-intro h5 { font-size:13px;font-weight:600;color:var(--ink-soft);margin:0 0 6px; }
.appearance-evidence { margin-top:8px; }
.panel-map { display:inline-block;margin:0 0 20px;font-size:12px;color:var(--accent);white-space:nowrap; }
.panel-external-links { display:flex;flex-wrap:wrap;gap:16px; }
.map-unavailable { color:var(--muted);font-size:12px; }
@keyframes panel-in { from { transform:translateX(100%); } to { transform:translateX(0); } }
.photo-lightbox { position:fixed;inset:0;margin:0;width:100vw;height:100dvh;max-width:none;max-height:none;padding:64px 20px 20px;border:0;background:transparent;color:white;overflow:hidden; }
.photo-lightbox::backdrop { background:rgb(0 0 0 / .88); }
.photo-lightbox[open] { display:grid;grid-template-columns:44px minmax(0,1fr) 44px;grid-template-rows:minmax(0,1fr) auto;gap:12px;align-items:center; }
.lightbox-image { display:block;max-width:100%;max-height:100%;width:auto;height:auto;justify-self:center;object-fit:contain;grid-column:2;grid-row:1; }
.lightbox-control { display:grid;place-items:center;width:44px;height:44px;border:1px solid #ffffff50;border-radius:8px;background:#20242b;color:white;font-size:24px;cursor:pointer; }
.lightbox-control:focus-visible { outline:2px solid white;outline-offset:3px; }
.lightbox-control[hidden] { display:none; }
.lightbox-close { position:absolute;right:20px;top:12px; }
.lightbox-prev { grid-column:1;grid-row:1; }
.lightbox-next { grid-column:3;grid-row:1; }
.lightbox-caption { grid-column:1 / -1;text-align:center;font-size:12px;line-height:1.6;max-height:18dvh;overflow:auto; }
.lightbox-count { display:block;color:#cbd0d8;margin-bottom:4px; }
@media(max-width:640px) { .photo-lightbox[open] { padding:64px 12px 16px;grid-template-columns:44px minmax(0,1fr) 44px;grid-template-rows:minmax(0,1fr) 44px auto;gap:10px; } .lightbox-image { grid-column:1 / -1; } .lightbox-prev { grid-row:2; } .lightbox-next { grid-row:2; } .lightbox-caption { grid-row:3; } .photo-lightbox.single-photo { grid-template-rows:minmax(0,1fr) auto; } .single-photo .lightbox-caption { grid-row:2; } }
@media(max-width:640px) { .detail-panel { width:100vw;border:0; } .panel-content { padding:8px 20px 20px; } .panel-close { top:16px;right:20px; } }
@media(prefers-reduced-motion:reduce) { .detail-panel[open] { animation:none; } }
</style>
</head>
<body data-theme="light">
<header class="topbar">
 <a class="brand" href="../" title="홈으로"><span class="brand-mark">KSA Landmarks</span><span class="brand-meta">3D · Reference</span></a>
 <nav class="topbar-nav" aria-label="주 메뉴"><a href="../">Reference</a><a href="./" class="active" aria-current="page">Research</a><a href="../progress/">Files</a></nav>
 <div class="search-wrap">
  <svg class="search-icon" aria-hidden="true" width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="6" cy="6" r="4.5" stroke="currentColor" stroke-width="1.4"/><path d="M9.5 9.5 L13 13" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
  <input type="search" class="search-input" id="search" aria-label="조사 항목 검색" placeholder="검색 — 이름, 도시, 타입, 태그..." autocomplete="off">
  <span class="search-kbd" aria-hidden="true">⌘K</span>
  <button type="button" class="search-clear" aria-label="검색어 지우기" hidden><svg aria-hidden="true" width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M4 4L10 10M10 4L4 10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg></button>
 </div>
 <button class="theme-toggle" id="theme-toggle" aria-label="다크 모드로 전환" aria-pressed="false">◐</button>
</header>
<main class="main">
 <div class="page-head"><div><p class="eyebrow">SAUDI ARABIA · NEW LANDMARKS</p><h1>Landmark <em>Research</em></h1><p class="page-sub">신규 랜드마크 후보의 외형 특징과 조사 자료를 지역별로 모았습니다.</p></div><p class="check-date">자료 점검 {{CHECK_DATE}}</p></div>
 <nav class="overview" aria-label="도시별 랜드마크 후보">{{OVERVIEW}}</nav>
 {{SECTIONS}}
 <p class="footer">선정·제외 이후에도 조사 기록을 유지합니다.<br>최신 외관·정밀 좌표·치수·보유 모델과의 형상 중복은 추가 확인이 필요합니다. ‘지도’는 대조한 장소로, ‘지도 (좌표)’는 확인한 위치의 핀으로, ‘지도 검색’은 아직 장소를 확정하지 못한 검색 결과로 연결됩니다.</p>
</main>
<script>
(() => {
 const cards = [...document.querySelectorAll('.research-card')];
 const cities = [...document.querySelectorAll('.city-section')];
 const statusSelects = [...document.querySelectorAll('.status-filter')];
 const search = document.getElementById('search');
 const searchClear = document.querySelector('.search-clear');
 const searchShortcut = document.querySelector('.search-kbd');
 const labels = {review: '검토 중인', selected: '선정한', excluded: '제외한'};
 function visibleCount(scope, kind) { return [...scope.querySelectorAll('.research-card')].filter(card => !card.hidden && (!kind || card.dataset.kind === kind)).length; }
 function applyFilters() {
  searchClear.hidden = search.value.length === 0;
  searchShortcut.hidden = search.value.length !== 0;
  const terms = search.value.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
  cities.forEach(section => {
   const filter = section.querySelector('.status-filter').value;
   section.querySelectorAll('.research-card').forEach(card => { card.hidden = !(card.dataset.status === filter && terms.every(term => card.dataset.search.includes(term))); });
   const count = visibleCount(section);
   const empty = section.querySelector('.section-empty');
   section.querySelector('.section-count').textContent = count;
   empty.hidden = count !== 0;
   empty.textContent = terms.length ? '이 지역에 일치하는 조사 항목이 없습니다.' : section.querySelector('.research-card') ? `아직 ${labels[filter]} 항목이 없습니다.` : '아직 등록된 조사 항목이 없습니다.';
   // Keep city anchors available even when a filter has no matches.
  });
  document.querySelectorAll('.scope-section').forEach(section => {
   const count = visibleCount(section);
   section.querySelector('.scope-count').textContent = count;
   section.hidden = count === 0;
  });
  document.querySelectorAll('[data-count-for]').forEach(count => { count.textContent = visibleCount(document.getElementById(count.dataset.countFor), count.dataset.countKind); });
 }
 statusSelects.forEach(select => select.addEventListener('change', applyFilters));
 search.addEventListener('input', applyFilters);
 searchClear.addEventListener('click', () => { search.value = ''; applyFilters(); search.focus(); });
 // One floating tooltip, mounted inside an open dialog when needed.
 const gradeTip=document.createElement('div');gradeTip.id='recommendation-tooltip';
 gradeTip.className='recommendation-tooltip';gradeTip.setAttribute('role','tooltip');gradeTip.hidden=true;
 document.body.append(gradeTip);
 let gradeAnchor=null,gradePinned=false,gradeTimer;
 const closeGradeTip=()=>{clearTimeout(gradeTimer);gradeAnchor?.removeAttribute('aria-describedby');gradeAnchor=null;gradePinned=false;gradeTip.hidden=true;};
 function showGradeTip(button){
  clearTimeout(gradeTimer);
  if(gradeAnchor!==button){closeGradeTip();gradeAnchor=button;}
  (button.closest('dialog')||document.body).append(gradeTip);
  gradeTip.textContent=button.dataset.recommendationReason;gradeTip.hidden=false;
  button.setAttribute('aria-describedby',gradeTip.id);
  const rect=button.getBoundingClientRect(),box=gradeTip.getBoundingClientRect();
  gradeTip.style.left=Math.max(12,Math.min(rect.right-box.width,innerWidth-box.width-12))+'px';
  gradeTip.style.top=Math.max(12,rect.bottom+8+box.height>innerHeight-12?rect.top-box.height-8:rect.bottom+8)+'px';
 }
 const deferGradeClose=()=>{clearTimeout(gradeTimer);gradeTimer=setTimeout(()=>{if(!gradePinned&&document.activeElement!==gradeAnchor)closeGradeTip();},120);};
 document.addEventListener('pointerover',event=>{
  if(event.pointerType==='touch')return;
  const button=event.target.closest('.recommendation[data-recommendation-reason]');
  if(button)showGradeTip(button);else if(gradeTip.contains(event.target))clearTimeout(gradeTimer);
 });
 document.addEventListener('pointerout',event=>{
  if(event.target.closest('.recommendation[data-recommendation-reason]')||gradeTip.contains(event.target)){
   if(!gradeTip.contains(event.relatedTarget)&&!gradeAnchor?.contains(event.relatedTarget))deferGradeClose();
  }
 });
 document.addEventListener('focusin',event=>{if(event.target.matches('.recommendation[data-recommendation-reason]'))showGradeTip(event.target);});
 document.addEventListener('focusout',event=>{if(event.target===gradeAnchor)closeGradeTip();});
 document.addEventListener('click',event=>{
  const button=event.target.closest('.recommendation[data-recommendation-reason]');
  if(!button)return;
  if(gradeAnchor===button&&gradePinned){closeGradeTip();return;}
  showGradeTip(button);gradePinned=true;
 });
 document.addEventListener('pointerdown',event=>{if(gradeAnchor&&!gradeAnchor.contains(event.target)&&!gradeTip.contains(event.target))closeGradeTip();});
 document.addEventListener('keydown',event=>{if(event.key==='Escape'&&!gradeTip.hidden){event.preventDefault();event.stopImmediatePropagation();closeGradeTip();}},true);
 document.addEventListener('scroll',closeGradeTip,true);window.addEventListener('resize',closeGradeTip);
 document.addEventListener('close',closeGradeTip,true);
 const helpClosers = [];
 document.querySelectorAll('.display-help').forEach(help => {
  const trigger = help.querySelector('button');
  const tip = help.querySelector('[role="tooltip"]');
  let pinned = false;
  const close = () => { pinned = false; tip.hidden = true; };
  helpClosers.push(close);
  help.addEventListener('pointerenter', event => { if (event.pointerType !== 'touch') tip.hidden = false; });
  help.addEventListener('pointerleave', () => { if (!pinned && !help.contains(document.activeElement)) tip.hidden = true; });
  trigger.addEventListener('focus', () => { tip.hidden = false; });
  help.addEventListener('focusout', event => { if (!help.contains(event.relatedTarget)) close(); });
  trigger.addEventListener('click', () => { pinned = !pinned; tip.hidden = !pinned; });
  document.addEventListener('pointerdown', event => { if (!help.contains(event.target)) close(); });
 });
 document.addEventListener('keydown', event => { if (event.key === 'Escape') helpClosers.forEach(close => close()); });
 document.addEventListener('keydown', event => {
  if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') { event.preventDefault(); search.focus(); }
 });
 function revealHash() {
  const legacyAnchors = {'phase-1-riyadh': 'riyadh', 'phase-1-jeddah': 'jeddah', 'phase-1': 'riyadh'};
  const hash = location.hash.slice(1);
  const target = document.getElementById(legacyAnchors[hash] || hash);
  if (!target) return;
  if (target.classList.contains('research-card')) { search.value = ''; target.closest('.city-section').querySelector('.status-filter').value = target.dataset.status; applyFilters(); }
  if (target.classList.contains('scope-section') && target.hidden) { search.value = ''; target.closest('.city-section').querySelector('.status-filter').value = 'review'; applyFilters(); }
  if (target.matches('.research-card, .city-section, .scope-section')) target.scrollIntoView({block: 'start'});
 }
 window.addEventListener('hashchange', revealHash);
 applyFilters();
 revealHash();
 const themeButton = document.getElementById('theme-toggle');
 function setTheme(theme) {
  document.body.dataset.theme = theme;
  themeButton.setAttribute('aria-pressed', String(theme === 'dark'));
  themeButton.setAttribute('aria-label', theme === 'dark' ? '라이트 모드로 전환' : '다크 모드로 전환');
 }
 let theme = 'light';
 try { if (localStorage.getItem('ksa-theme') === 'dark') theme = 'dark'; } catch (_) {}
 setTheme(theme);
 themeButton.addEventListener('click', () => {
  const next = document.body.dataset.theme === 'dark' ? 'light' : 'dark';
  setTheme(next);
  try { localStorage.setItem('ksa-theme', next); } catch (_) {}
 });
})();
</script>
<dialog class="detail-panel" id="research-detail-panel" aria-labelledby="panel-title">
 <button class="panel-close" type="button" aria-label="상세 패널 닫기" autofocus><svg aria-hidden="true" viewBox="0 0 16 16"><path d="m3 3 10 10M13 3 3 13"/></svg></button>
 <div class="panel-content"></div>
</dialog>
<dialog class="photo-lightbox" id="research-lightbox" aria-label="랜드마크 사진 크게 보기">
 <button class="lightbox-control lightbox-close" type="button" aria-label="사진 닫기" autofocus>×</button>
 <button class="lightbox-control lightbox-prev" type="button" aria-label="이전 사진">‹</button>
 <img class="lightbox-image" alt="">
 <button class="lightbox-control lightbox-next" type="button" aria-label="다음 사진">›</button>
 <div class="lightbox-caption" aria-live="polite"><span class="lightbox-count"></span><span class="lightbox-description"></span></div>
</dialog>
<script>
(() => {
 const panel=document.querySelector('#research-detail-panel');
 const content=panel.querySelector('.panel-content');
 const lightbox=document.querySelector('#research-lightbox');
 const largeImage=lightbox.querySelector('.lightbox-image');
 let photos=[],photoIndex=0,photoOpener=null;
 function showPhoto(index) {
  photoIndex=(index+photos.length)%photos.length;
  const photo=photos[photoIndex],img=photo.querySelector('img');
  largeImage.src=img.src;largeImage.alt=img.alt;
  lightbox.querySelector('.lightbox-count').textContent=`${photoIndex+1} / ${photos.length}`;
  lightbox.querySelector('.lightbox-description').textContent=photo.closest('figure').querySelector('figcaption > p').textContent;
 }
 content.addEventListener('click',event=>{
  const trigger=event.target.closest('.photo-original');if(!trigger)return;
  photoOpener=trigger;photos=[...content.querySelectorAll('.photo-original')];
  const single=photos.length===1;lightbox.classList.toggle('single-photo',single);
  lightbox.querySelector('.lightbox-prev').hidden=single;lightbox.querySelector('.lightbox-next').hidden=single;
  showPhoto(photos.indexOf(trigger));lightbox.showModal();
 });
 lightbox.querySelector('.lightbox-close').addEventListener('click',()=>lightbox.close());
 lightbox.querySelector('.lightbox-prev').addEventListener('click',()=>showPhoto(photoIndex-1));
 lightbox.querySelector('.lightbox-next').addEventListener('click',()=>showPhoto(photoIndex+1));
 lightbox.addEventListener('click',event=>{if(event.target===lightbox)lightbox.close();});
 lightbox.addEventListener('keydown',event=>{
  if(event.key==='ArrowLeft'||event.key==='ArrowRight'){event.preventDefault();showPhoto(photoIndex+(event.key==='ArrowLeft'?-1:1));}
 });
 lightbox.addEventListener('close',()=>{largeImage.removeAttribute('src');photoOpener?.focus({preventScroll:true});});
 let opener=null, savedY=0;
 const detailsByCard=new Map();
 document.querySelectorAll('.research-card').forEach(card=>{
  const details=card.querySelector('.card-actions details');
  detailsByCard.set(card,details.querySelector('.detail-body').cloneNode(true));
  const button=document.createElement('button');button.type='button';button.className='detail-panel-trigger';
  button.setAttribute('aria-haspopup','dialog');
  button.setAttribute('aria-controls','research-detail-panel');
  button.innerHTML='상세 정보 <svg aria-hidden="true" viewBox="0 0 16 16"><path d="m6 3 5 5-5 5"/></svg>';
  details.replaceWith(button);
  const photoButton=card.querySelector('.photo-open');
  if(photoButton)photoButton.addEventListener('click',()=>{button.click();opener=photoButton;});
  button.addEventListener('click',()=>{
   if(!panel.open){opener=button;savedY=window.scrollY;}content.replaceChildren();
   const heading=document.createElement('div');heading.className='panel-heading';
   const title=document.createElement('h2');title.id='panel-title';title.textContent=card.querySelector('.card-heading h3,.card-heading h4').textContent;heading.append(title,card.querySelector('.recommendation').cloneNode(true));content.append(heading);
   const body=detailsByCard.get(card).cloneNode(true);
   const area=card.querySelector('.area');if(area)content.append(area.cloneNode(true));
   const type=card.querySelector('.type-badge');if(type){const tags=document.createElement('div');tags.className='card-tags';tags.append(type.cloneNode(true));content.append(tags);}
   const intro=body.querySelector('.landmark-intro');if(intro)content.append(intro);
   const decision=card.querySelector('.decision-note');if(decision)content.append(decision.cloneNode(true));
   const links=document.createElement('div');links.className='panel-external-links';
   card.querySelectorAll('.card-external-links a, .card-external-links .map-unavailable').forEach(el=>{const a=el.cloneNode(true);if(a.tagName==='A')a.className='panel-map';links.append(a);});content.append(links);
   content.append(body);
   document.documentElement.style.overflow='hidden';if(!panel.open)panel.showModal();content.scrollTop=0;
   panel.querySelector('.panel-close').focus({preventScroll:true});
  });
 });
 document.addEventListener('click',event=>{
  const related=event.target.closest('[data-related-card]');if(!related)return;
  const target=document.getElementById(related.dataset.relatedCard)?.querySelector('.detail-panel-trigger');
  if(!target)return;
  const fromPanel=panel.open;target.click();if(!fromPanel)opener=related;
 });
 panel.querySelector('.panel-close').addEventListener('click',()=>panel.close());
 panel.addEventListener('keydown',event=>{
  if(event.key!=='Tab')return;
  const focusable=[...panel.querySelectorAll('button:not([disabled]), a[href]')];
  const first=focusable[0],last=focusable[focusable.length-1];
  if(event.shiftKey&&document.activeElement===first){event.preventDefault();last.focus();}
  else if(!event.shiftKey&&document.activeElement===last){event.preventDefault();first.focus();}
 });
 panel.addEventListener('click',event=>{if(event.target===panel && event.clientX<panel.getBoundingClientRect().left)panel.close();});
 panel.addEventListener('close',()=>{
  document.documentElement.style.overflow='';
  window.scrollTo({top:savedY,behavior:'instant'});opener?.focus({preventScroll:true});
 });
})();
</script>

</body>
</html>
