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
.topbar { position: fixed; inset: 0 0 auto; height: var(--topbar-height); z-index: 100; display: flex; align-items: center; gap: 24px; padding: 0 24px; border-bottom: 1px solid var(--border); background: color-mix(in srgb, var(--bg-elev) 94%, transparent); backdrop-filter: blur(12px); line-height: 1.55; user-select: none; -webkit-user-select: none; }
.topbar input, .topbar textarea { user-select: text; -webkit-user-select: text; }
.topbar a, .topbar svg { -webkit-user-drag: none; }
.brand { display: flex; flex-direction: column; align-items: flex-start; justify-content: center; gap: 0; flex-shrink: 0; line-height: 1; }
.brand-mark { font-size: 17px; font-weight: 700; letter-spacing: -.02em; line-height: 1.1; }
.brand-meta { margin-top: 3px; font-family: var(--mono); font-size: 9.5px; line-height: 1; letter-spacing: .1em; color: var(--ink-mute); text-transform: uppercase; }
.topbar-nav { display: flex; gap: 4px; margin-inline: var(--nav-group-inset); flex-shrink: 0; }
.topbar-nav a { position: relative; padding: 6px var(--nav-link-inset); border-radius: 6px; background: transparent; color: var(--ink-soft); font-size: 12.5px; font-weight: 500; transition: background 0.14s ease, color 0.14s ease; }
.topbar-nav a.active { background: transparent; color: var(--ink); font-weight: 600; }
.topbar-nav a:hover { background: var(--bg-sunken); color: var(--ink); }
.topbar-nav a.active::after { content: ''; position: absolute; left: var(--nav-link-inset); right: var(--nav-link-inset); bottom: 0; height: 2px; border-radius: 1px; background: currentColor; }
@media (max-width: 640px) { .topbar-nav { --nav-link-inset: 8px; --nav-group-inset: 0px; } }
.theme-toggle { margin-left: auto; width: 36px; height: 36px; flex-shrink: 0; border: 1px solid var(--border); border-radius: 10px; background: var(--bg-elev); color: var(--ink-soft); display: flex; align-items: center; justify-content: center; transition: background 0.14s ease, color 0.14s ease, border-color 0.14s ease; }
.theme-toggle:hover { background: var(--bg-sunken); color: var(--ink); }
[data-theme="dark"] .sun-icon { display: none; }
[data-theme="light"] .moon-icon { display: none; }
.moon-icon { transform: translate(1px, -1px); }
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
.comment-thumbnail-badge { position:absolute;right:12px;bottom:12px;z-index:2;display:inline-flex;align-items:center;gap:5px;min-height:28px;padding:4px 8px;border:1px solid rgb(255 255 255 / 25%);border-radius:6px;background:rgb(16 23 33 / 88%);color:#fff;font-size:11px;font-weight:500;box-shadow:0 1px 4px rgb(0 0 0 / 12%);user-select:none; }
.comment-thumbnail-badge:hover { background:#101721; }
.comment-thumbnail-badge:focus-visible { outline:2px solid #fff;outline-offset:2px; }
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
.model-scope-link { color: inherit; text-decoration: underline; text-decoration-color: color-mix(in srgb, currentColor 45%, transparent); text-underline-offset: 3px; }
.model-scope-link:hover { text-decoration-color: currentColor; }
.decision-note { margin: 0 0 13px; padding: 7px 9px; border-left: 2px solid color-mix(in srgb, var(--warning) 45%, var(--border)); background: color-mix(in srgb, var(--warning) 4%, var(--bg-elev)); color: var(--ink-soft); font-size: 10px; line-height: 1.75; }
.decision-note > span { color: var(--warning); margin-right: 7px; font-weight: 500; white-space: nowrap; }
.card-actions { display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;column-gap:12px;border-top:1px solid var(--border); }
.card-actions details[open] { flex-basis:100%; }
.card-comments { border-top: 1px solid var(--border); padding: 14px 0 16px; }
.comment-heading { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
.comment-count { font-size: 11px; font-weight: 500; color: var(--ink-soft); }
.comment-write, .comment-expand, .comment-text-toggle, .comment-cancel, .comment-author-change { padding: 0; min-height: 28px; border: 0; background: transparent; font-size: 11px; color: var(--ink-soft); }
.comment-write { display: flex; align-items: center; gap: 5px; }
.comment-write svg { width: 12px; height: 12px; fill: none; stroke: currentColor; stroke-width: 1.5; }
.comment-write:hover, .comment-expand:hover, .comment-text-toggle:hover, .comment-cancel:hover, .comment-author-change:hover { color: var(--ink); text-decoration: underline; text-underline-offset: 3px; }
.comment-list { list-style: none; display: grid; gap: 14px; margin-top: 12px; }
.comment-meta { display: flex; align-items: center; flex-wrap: wrap; gap: 8px; min-height:24px; font-size: 10px; color: var(--ink-mute); }
.comment-manage { display:grid;place-items:center;margin-left:auto;width:28px;height:28px;padding:0;border:0;border-radius:6px;background:transparent;color:var(--ink-mute); }
.comment-manage:hover, .comment-manage[aria-expanded="true"] { color:var(--ink);background:var(--bg-sunken); }
.comment-menu { position:fixed;z-index:110;width:112px;padding:4px;border:1px solid var(--border);border-radius:8px;background:var(--bg-elev);box-shadow:var(--shadow-md); }
.comment-menu button { display:block;width:100%;padding:8px 10px;border:0;border-radius:4px;background:transparent;color:var(--ink-soft);font-size:12px;text-align:left; }
.comment-menu button:hover, .comment-menu button:focus-visible { background:var(--bg-sunken);color:var(--ink); }
.comment-edit-form { display:grid;gap:8px;margin-top:5px; }
.comment-edit-form .comment-buttons { justify-content:flex-end; }
.comment-delete-confirm { display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px;margin-top:8px;font-size:11px;color:var(--ink-soft); }
.comment-delete-confirm .comment-buttons { margin-left:auto; }
.comment-author { font-weight: 500; color: var(--ink-soft); overflow-wrap: anywhere; }
.comment-text { margin-top: 5px; font-size: 12px; line-height: 1.7; color: var(--ink-soft); white-space: pre-wrap; overflow-wrap: anywhere; }
.comment-text.is-collapsed { display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 3; overflow: hidden; }
.comment-text-toggle { min-height: 24px; }
.comment-expand { margin-top: 8px; }
.comment-list-actions { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.comment-composer { display: grid; gap: 10px; margin-top: 12px; }
.comment-identity { display: flex; align-items: center; gap: 12px; min-width: 0; font-size: 11px; color: var(--ink-soft); }
.comment-identity > span { min-width: 0; overflow-wrap: anywhere; }
.comment-identity-name { font-weight: 500; }
.comment-author-change { flex-shrink: 0; color: var(--ink-mute); }
.comment-field { display: grid; gap: 5px; color: var(--ink-soft); font-size: 11px; }
.comment-field input, .comment-field textarea { width: 100%; min-width: 0; border: 1px solid var(--border); border-radius: 6px; padding: 9px 10px; background: var(--bg-elev); color: var(--ink); font: inherit; font-size: 12px; }
.comment-field textarea { min-height: 84px; resize: vertical; line-height: 1.6; }
.comment-field input::placeholder, .comment-field textarea::placeholder { color: var(--ink-mute); }
.comment-field input:focus-visible, .comment-field textarea:focus-visible { outline: 2px solid var(--accent-strong); outline-offset: 2px; }
.comment-composer-actions { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px; }
.comment-storage-note { font-size: 10px; color: var(--ink-mute); }
.comment-buttons { display: flex; align-items: center; gap: 12px; margin-left: auto; }
.comment-submit { border: 0; border-radius: 6px; padding: 7px 11px; background: var(--ink); color: var(--bg-elev); font-size: 11px; }
.comment-submit:disabled { opacity: .35; cursor: default; }
.comment-submit:not(:disabled):hover { opacity: .8; }
.comment-feedback { margin-top: 8px; font-size: 10px; line-height: 1.6; color: var(--ink-mute); }
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
@media (max-width: 768px) {
 .topbar { padding: 0 16px; gap: 12px; }
 .search-wrap { display: none; }
}
@media (max-width: 640px) {
 .topbar { padding: 0 10px; gap: 8px; }
 .brand-mark { font-size: 13px; } .brand-meta { font-size: 8px; }
 .topbar-nav { gap: 3px; } .topbar-nav a { padding: 6px 8px; font-size: 11px; }
 .theme-toggle { width: 30px; height: 30px; flex-shrink: 0; }
 .main { padding: calc(var(--topbar-height) + 24px) 20px 60px; }
 .comment-field input, .comment-field textarea { font-size: 16px; }
 .comment-write, .comment-expand, .comment-text-toggle, .comment-cancel, .comment-submit, .comment-author-change { min-height: 44px; }
 .comment-text-toggle, .comment-cancel, .comment-submit, .comment-author-change { min-width: 44px; }
 .comment-manage { width:44px;height:44px; }
 .comment-menu button { min-height:44px; }
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
@media (pointer: coarse) {
 .comment-write, .comment-expand, .comment-text-toggle, .comment-cancel, .comment-submit, .comment-author-change { min-height: 44px; }
 .comment-text-toggle, .comment-cancel, .comment-submit, .comment-author-change { min-width: 44px; }
 .comment-manage { width:44px;height:44px; }
 .comment-menu button { min-height:44px; }
}
@media (max-width: 375px) {
 :root { --topbar-height: 96px; }
 .topbar { flex-wrap: wrap; align-content: center; gap: 8px 12px; }
 .topbar-nav { order: 3; flex-basis: 100%; justify-content: center; }
}
@media (prefers-reduced-motion: reduce) { html { scroll-behavior: auto; } .chevron { transition: none; } }
@media print { .topbar, .section-controls, .overview { display: none; } .main { padding: 0; } .research-card { break-inside: avoid; } }

/* Detail overlay: same layout as the approved preview. */
html { scrollbar-gutter: stable; }
.detail-panel-trigger { display:flex;align-items:center;gap:9px;border:0;background:transparent;padding:14px 0;font-size:11px;font-weight:500;color:var(--ink-soft); }
.detail-panel-trigger svg { width:15px;height:15px;fill:none;stroke:currentColor;stroke-width:1.5; }
.detail-panel { position:fixed;inset:0 0 0 auto;margin:0;width:min(480px,100vw);height:100vh;height:100dvh;max-width:100vw;max-height:100vh;max-height:100dvh;border:0;border-left:1px solid var(--border);background:var(--bg-elev);color:var(--ink);padding:0;box-shadow:-12px 0 48px #0e131b20;overflow:hidden; }
.detail-panel[open] { display:flex;flex-direction:column;animation:panel-in .2s ease-out; }
.detail-panel::backdrop { background:rgb(14 19 27 / .12); }
.panel-toolbar { flex-shrink:0;min-height:64px;display:flex;justify-content:flex-end;align-items:center;padding:14px 24px; }
.panel-close { flex-shrink:0;width:36px;height:36px;border:1px solid var(--border);border-radius:8px;background:var(--bg-elev);color:var(--ink-soft);display:flex;align-items:center;justify-content:center;gap:6px; }
.panel-close:hover { background:var(--bg-sunken);color:var(--ink); }
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
@media(max-width:640px) {
 .detail-panel { inset:0;width:100%;max-width:none;border:0; }
 .detail-panel[open] { animation:none; }
 .panel-toolbar { padding:calc(10px + env(safe-area-inset-top, 0px)) max(20px, env(safe-area-inset-right, 0px)) 10px 20px; }
 .panel-content { padding:8px 20px calc(20px + env(safe-area-inset-bottom, 0px)); }
 .panel-close { width:44px;height:44px;padding:0;border:0;background:var(--bg-sunken); }
}
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
 <button class="theme-toggle" id="theme-toggle" aria-label="다크 모드로 전환" aria-pressed="false">
      <svg aria-hidden="true" class="sun-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="3" stroke="currentColor" stroke-width="1.4"/><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3.05 3.05l1.41 1.41M11.54 11.54l1.41 1.41M3.05 12.95l1.41-1.41M11.54 4.46l1.41-1.41" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/></svg>
      <svg aria-hidden="true" class="moon-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13 9.5A6 6 0 1 1 6.5 3a4.5 4.5 0 0 0 6.5 6.5z" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/></svg>
 </button>
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
 <div class="panel-toolbar"><button class="panel-close" type="button" aria-label="상세 패널 닫기" autofocus><svg aria-hidden="true" viewBox="0 0 16 16"><path d="m3 3 10 10M13 3 3 13"/></svg></button></div>
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

<script id="research-firebase-config" type="application/json">{{FIREBASE_CONFIG}}</script>
<script type="module">
import {createCommentStore, commentErrorMessage} from '../assets/research-comment-store.js';
(() => {
 const topbar = document.querySelector('.topbar');
 topbar.querySelectorAll('a').forEach(link => { link.draggable = false; });
 topbar.addEventListener('dragstart', event => {
  if (!event.target.closest('input, textarea')) event.preventDefault();
 });

 const store = createCommentStore(JSON.parse(document.getElementById('research-firebase-config').textContent));
 const cardControls = new Map();
 const commentMenu = document.createElement('div');
 commentMenu.className = 'comment-menu'; commentMenu.id = 'comment-actions-menu';
 commentMenu.role = 'menu'; commentMenu.setAttribute('aria-label', '코멘트 관리'); commentMenu.hidden = true;
 const menuEdit = document.createElement('button'), menuDelete = document.createElement('button');
 menuEdit.type = menuDelete.type = 'button'; menuEdit.role = menuDelete.role = 'menuitem';
 menuEdit.textContent = '수정'; menuDelete.textContent = '삭제';
 commentMenu.append(menuEdit, menuDelete); document.body.append(commentMenu);
 let menuTarget = null;
 function closeCommentMenu(restoreFocus = false) {
  const target = menuTarget; menuTarget = null; commentMenu.hidden = true;
  target?.trigger.setAttribute('aria-expanded', 'false');
  if (restoreFocus) target?.trigger.focus({preventScroll:true});
 }
 function openCommentMenu(trigger, edit, remove) {
  if (menuTarget?.trigger === trigger) { closeCommentMenu(true); return; }
  closeCommentMenu(); menuTarget = {trigger, edit, remove};
  trigger.setAttribute('aria-expanded', 'true'); commentMenu.hidden = false;
  const box = trigger.getBoundingClientRect();
  commentMenu.style.left = `${Math.max(8, Math.min(box.right - commentMenu.offsetWidth, innerWidth - commentMenu.offsetWidth - 8))}px`;
  commentMenu.style.top = `${box.bottom + commentMenu.offsetHeight + 6 <= innerHeight - 8 ? box.bottom + 4 : Math.max(8, box.top - commentMenu.offsetHeight - 4)}px`;
  menuEdit.focus({preventScroll:true});
 }
 menuEdit.addEventListener('click', () => { const target = menuTarget; closeCommentMenu(); target?.edit(); });
 menuDelete.addEventListener('click', () => { const target = menuTarget; closeCommentMenu(); target?.remove(); });
 commentMenu.addEventListener('keydown', event => {
  if (['ArrowDown','ArrowUp','Home','End'].includes(event.key)) {
   event.preventDefault();
   (event.key === 'Home' ? menuEdit : event.key === 'End' ? menuDelete : document.activeElement === menuEdit ? menuDelete : menuEdit).focus();
  }
 });
 document.addEventListener('keydown', event => {
  if (!menuTarget) return;
  if (event.key === 'Escape') { event.preventDefault(); event.stopImmediatePropagation(); closeCommentMenu(true); }
  if (event.key === 'Tab') closeCommentMenu(true);
 }, true);
 document.addEventListener('click', event => {
  if (menuTarget && !commentMenu.contains(event.target) && !menuTarget.trigger.contains(event.target)) closeCommentMenu();
 });
 window.addEventListener('scroll', () => closeCommentMenu(), true);
 window.addEventListener('resize', () => closeCommentMenu());
 store.onViewerChange(() => cardControls.forEach(control => control.refreshOwnership()));
 const commentsObserver = typeof IntersectionObserver === 'function' ? new IntersectionObserver(entries => {
  entries.forEach(entry => {
   if (entry.isIntersecting && !entry.target.hidden) cardControls.get(entry.target)?.load();
  });
 }, {rootMargin: '200px 0px'}) : null;
 const authorStorageKey = 'ksa-comment-author';
 function normalizeAuthor(value) { return typeof value === 'string' ? value.trim().slice(0, 40) : ''; }
 let rememberedAuthor = '';
 try { rememberedAuthor = normalizeAuthor(localStorage.getItem(authorStorageKey)); } catch (_) {}
 const authorControls = [];
 function rememberAuthor(value) {
  const name = normalizeAuthor(value);
  if (!name) return;
  rememberedAuthor = name;
  try { localStorage.setItem(authorStorageKey, name); } catch (_) {}
  authorControls.forEach(control => control.refresh());
 }
 window.addEventListener('storage', event => {
  if (event.key !== authorStorageKey && event.key !== null) return;
  rememberedAuthor = normalizeAuthor(event.key === null ? null : event.newValue);
  authorControls.forEach(control => control.refresh());
 });
 const textChecks = new Map();
 const dateFormat = new Intl.DateTimeFormat('ko-KR', {month: '2-digit', day: '2-digit'});
 function checkText(card) {
  if (card.hidden || !card.getBoundingClientRect().width) return;
  (textChecks.get(card) || []).forEach(({text, toggle}) => {
   toggle.hidden = text.classList.contains('is-collapsed') && text.scrollHeight <= text.clientHeight + 1;
  });
 }
 const resizeObserver = typeof ResizeObserver === 'function' ? new ResizeObserver(entries => {
  requestAnimationFrame(() => entries.forEach(entry => checkText(entry.target)));
 }) : null;
 document.querySelectorAll('.research-card').forEach(card => {
  const section = card.querySelector('.card-comments');
  const form = section.querySelector('.comment-composer');
  const author = form.elements.namedItem('author');
  const authorField = form.querySelector('.comment-author-field');
  const identity = form.querySelector('.comment-identity');
  const identityName = form.querySelector('.comment-identity-name');
  const changeAuthor = form.querySelector('.comment-author-change');
  const message = form.elements.namedItem('comment');
  const write = section.querySelector('.comment-write');
  const submit = section.querySelector('.comment-submit');
  const count = section.querySelector('.comment-count');
  const list = section.querySelector('.comment-list');
  const expand = section.querySelector('.comment-list-actions .comment-expand');
  const more = section.querySelector('.comment-more');
  const retry = section.querySelector('.comment-retry');
  const cancel = section.querySelector('.comment-cancel');
  const feedback = section.querySelector('.comment-feedback');
  const thumbnailBadge = card.querySelector('.comment-thumbnail-badge');
  section.tabIndex = -1;
  list.id = `comment-list-${card.id}`;
  expand.setAttribute('aria-controls', list.id);
  let comments = [], total = 0, loaded = false, loading = false, revision = 0;
  let submitting = false, paging = false, pageLoaded = false, cursor = null, hasMore = false;
  let mutating = false, editingId = null, deletingId = null;
  let ownershipControls = [];
  let attempt = null;
  let expanded = false;
  let editingAuthor = false;
  function interacting() { return submitting || paging || mutating || editingId !== null || deletingId !== null; }
  function updateSubmit() {
   submit.disabled = interacting() || !store.configured || !author.value.trim() || !message.value.trim();
   write.disabled = expand.disabled = more.disabled = interacting();
   refreshOwnership();
  }
  function refreshOwnership() {
   ownershipControls.forEach(({button, comment}) => {
    button.hidden = !store.owns(comment); button.disabled = interacting();
   });
  }
  function refreshAuthor() {
   identityName.textContent = rememberedAuthor;
   if (!editingAuthor) author.value = rememberedAuthor;
   authorField.hidden = !!rememberedAuthor && !editingAuthor;
   identity.hidden = !rememberedAuthor || editingAuthor;
   updateSubmit();
  }
  authorControls.push({refresh: refreshAuthor});
  refreshAuthor();
  async function load(force = false) {
   if (loading || interacting() || (loaded && !force) || !store.configured) return;
   loading = true;
   const startedAt = revision;
   try {
    const result = await store.recent(card.id);
    if (interacting() || startedAt !== revision) return;
    if (!pageLoaded) {
     comments = startedAt === revision ? result.comments : [...new Map([...comments, ...result.comments].map(comment => [comment.id, comment])).values()];
    }
    total = startedAt === revision ? result.total : Math.max(total, result.total); loaded = true;
    retry.hidden = true; feedback.hidden = true; render();
   } catch (error) {
    feedback.textContent = commentErrorMessage(error); feedback.hidden = false; retry.hidden = false;
   } finally { loading = false; }
  }
  function render() {
   if (menuTarget && card.contains(menuTarget.trigger)) closeCommentMenu();
   count.hidden = total === 0;
   count.textContent = `코멘트 ${total}`;
   thumbnailBadge.hidden = total === 0;
   thumbnailBadge.querySelector('span').textContent = String(total);
   thumbnailBadge.setAttribute('aria-label', `코멘트 ${total}개 보기`);
   list.hidden = comments.length === 0;
   list.replaceChildren();
   ownershipControls = [];
   const checks = [];
   (expanded ? comments : comments.slice(0, 2)).forEach(comment => {
    const item = document.createElement('li');
    const meta = document.createElement('div'); meta.className = 'comment-meta';
    const name = document.createElement('span'); name.className = 'comment-author'; name.textContent = comment.author;
    const date = document.createElement('time'); date.dateTime = comment.createdAt; date.textContent = dateFormat.format(new Date(comment.createdAt));
    if (comment.updatedAt) { const edited = document.createElement('span'); edited.textContent = '수정됨'; meta.append(edited); }
    const text = document.createElement('p'); text.className = 'comment-text is-collapsed'; text.id = comment.id; text.textContent = comment.text;
    const toggle = document.createElement('button'); toggle.type = 'button'; toggle.className = 'comment-text-toggle'; toggle.textContent = '더 보기'; toggle.hidden = true;
    toggle.setAttribute('aria-expanded', 'false'); toggle.setAttribute('aria-controls', text.id);
    toggle.addEventListener('click', () => {
     const collapsed = text.classList.toggle('is-collapsed');
     toggle.textContent = collapsed ? '더 보기' : '접기';
     toggle.setAttribute('aria-expanded', String(!collapsed));
    });
    meta.prepend(name, date);
    const manage = document.createElement('button'); manage.type = 'button'; manage.className = 'comment-manage';
    manage.setAttribute('aria-label', `${comment.author} 코멘트 관리`); manage.setAttribute('aria-haspopup', 'menu');
    manage.setAttribute('aria-expanded', 'false'); manage.setAttribute('aria-controls', commentMenu.id);
    manage.innerHTML = '<svg aria-hidden="true" width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><circle cx="3" cy="8" r="1.2"/><circle cx="8" cy="8" r="1.2"/><circle cx="13" cy="8" r="1.2"/></svg>';
    manage.addEventListener('click', () => {
     if (!interacting() && store.owns(comment)) openCommentMenu(manage, () => editComment(comment, item, text, toggle), () => confirmRemoval(comment, item));
    });
    ownershipControls.push({button:manage, comment}); meta.append(manage);
    item.append(meta, text, toggle); list.append(item);
    checks.push({text, toggle});
   });
   textChecks.set(card, checks);
   expand.hidden = total <= 2;
   expand.textContent = expanded ? '접기' : `전체 코멘트 ${total}개 보기`;
   expand.setAttribute('aria-expanded', String(expanded));
   more.hidden = !expanded || !hasMore;
   refreshOwnership();
   requestAnimationFrame(() => checkText(card));
  }
  function operationFeedback(error, action) {
   feedback.textContent = commentErrorMessage(error, action); feedback.hidden = false;
  }
  function actionButton(label, className) {
   const button = document.createElement('button'); button.type = 'button'; button.className = className; button.textContent = label;
   return button;
  }
  function endInteraction(focusId) {
   editingId = deletingId = null; mutating = false; render(); updateSubmit();
   const owner = ownershipControls.find(control => control.comment.id === focusId);
   (owner?.button || write).focus({preventScroll:true});
  }
  function editComment(comment, item, text, toggle) {
   if (interacting() || !store.owns(comment)) return;
   editingId = comment.id; updateSubmit(); feedback.hidden = true;
   const editor = document.createElement('form'); editor.className = 'comment-edit-form';
   const label = document.createElement('label'); label.className = 'comment-field'; label.textContent = '코멘트 수정';
   const input = document.createElement('textarea'); input.value = comment.text; input.maxLength = 1000; input.required = true;
   label.append(input);
   const actions = document.createElement('div'); actions.className = 'comment-buttons';
   const discard = actionButton('취소', 'comment-cancel'), save = actionButton('저장', 'comment-submit'); save.type = 'submit';
   const updateSave = () => { save.disabled = mutating || !input.value.trim() || input.value.trim() === comment.text; };
   input.addEventListener('input', updateSave);
   discard.addEventListener('click', () => { if (!mutating) { feedback.hidden = true; endInteraction(comment.id); } });
   editor.addEventListener('keydown', event => {
    if (event.key === 'Escape' && !mutating) { event.preventDefault(); discard.click(); }
   });
   editor.addEventListener('submit', async event => {
    event.preventDefault(); if (mutating || !input.value.trim() || !editor.reportValidity()) return;
    mutating = true; save.textContent = '저장 중…'; input.disabled = discard.disabled = true; updateSave(); editor.setAttribute('aria-busy','true'); feedback.hidden = true;
    try {
     const saved = await store.edit(card.id, comment.id, input.value.trim());
     comments = comments.map(current => current.id === saved.id ? saved : current); revision += 1;
     endInteraction(comment.id); feedback.textContent = '코멘트를 수정했습니다.'; feedback.hidden = false;
    } catch (error) {
     mutating = false; save.textContent = '저장'; input.disabled = discard.disabled = false;
     editor.removeAttribute('aria-busy'); updateSave(); operationFeedback(error, 'edit');
    }
   });
   actions.append(discard, save); editor.append(label, actions); text.hidden = toggle.hidden = true; item.append(editor);
   updateSave(); input.focus({preventScroll:true});
  }
  function confirmRemoval(comment, item) {
   if (interacting() || !store.owns(comment)) return;
   deletingId = comment.id; updateSubmit(); feedback.hidden = true;
   const confirmation = document.createElement('div'); confirmation.className = 'comment-delete-confirm';
   const question = document.createElement('span'); question.textContent = '이 코멘트를 삭제할까요?';
   const actions = document.createElement('div'); actions.className = 'comment-buttons';
   const discard = actionButton('취소', 'comment-cancel'), remove = actionButton('삭제', 'comment-submit');
   discard.addEventListener('click', () => { if (!mutating) { feedback.hidden = true; endInteraction(comment.id); } });
   confirmation.addEventListener('keydown', event => {
    if (event.key === 'Escape' && !mutating) { event.preventDefault(); discard.click(); }
   });
   remove.addEventListener('click', async () => {
    if (mutating) return;
    mutating = true; remove.textContent = '삭제 중…'; remove.disabled = discard.disabled = true;
    confirmation.setAttribute('aria-busy','true'); feedback.hidden = true;
    try {
     await store.remove(card.id, comment.id); comments = comments.filter(current => current.id !== comment.id);
     total = Math.max(0, total - 1); revision += 1; endInteraction();
     feedback.textContent = '코멘트를 삭제했습니다.'; feedback.hidden = false;
     // Refill the recent-two preview after removing a comment.
     if (!pageLoaded && total > comments.length) load(true);
    } catch (error) {
     mutating = false; remove.textContent = '삭제'; remove.disabled = discard.disabled = false;
     confirmation.removeAttribute('aria-busy'); operationFeedback(error, 'delete');
    }
   });
   actions.append(discard, remove); confirmation.append(question, actions); item.append(confirmation); discard.focus({preventScroll:true});
  }
  function compose(open) {
   form.hidden = !open; write.hidden = open; write.setAttribute('aria-expanded', String(open));
   if (open) {
    feedback.hidden = true; refreshAuthor(); load();
    if (!store.configured) { feedback.textContent = '코멘트 저장소 연결 준비 중입니다.'; feedback.hidden = false; }
    (authorField.hidden ? message : author).focus({preventScroll: true});
   } else { editingAuthor = false; refreshAuthor(); write.focus({preventScroll: true}); }
  }
  changeAuthor.addEventListener('click', () => {
   editingAuthor = true; refreshAuthor(); author.focus({preventScroll: true}); author.select();
  });
  author.addEventListener('change', () => {
   // Keep the field visible until the next open, so editing does not move focus.
   if (normalizeAuthor(author.value)) { editingAuthor = true; rememberAuthor(author.value); }
  });
  write.addEventListener('click', () => compose(true));
  cancel.addEventListener('click', () => {
   if (submitting) return;
   rememberAuthor(author.value); message.value = ''; attempt = null; compose(false);
  });
  form.addEventListener('input', updateSubmit);
  form.addEventListener('submit', async event => {
   event.preventDefault();
   const name = author.value.trim(), text = message.value.trim();
   if (interacting() || !store.configured || !name || !text || !form.reportValidity()) return;
   if (!attempt || attempt.author !== name || attempt.text !== text) {
    attempt = {id: crypto.randomUUID(), author: name, text};
   }
   rememberAuthor(name);
   submitting = true; submit.textContent = '등록 중…'; updateSubmit();
   author.disabled = message.disabled = cancel.disabled = changeAuthor.disabled = true;
   form.setAttribute('aria-busy', 'true'); feedback.hidden = true;
   try {
    const {comment, total: confirmedTotal} = await store.add(card.id, attempt);
    revision += 1;
    const alreadyShown = comments.some(existing => existing.id === comment.id);
    comments = [comment, ...comments.filter(existing => existing.id !== comment.id)];
    if (confirmedTotal !== null) total = confirmedTotal;
    else if (!alreadyShown) total += 1;
    message.value = ''; attempt = null; render(); compose(false);
    feedback.textContent = '코멘트를 등록했습니다.'; feedback.hidden = false;
   } catch (error) {
    feedback.textContent = commentErrorMessage(error, 'save'); feedback.hidden = false;
   } finally {
    submitting = false; submit.textContent = '등록';
    author.disabled = message.disabled = cancel.disabled = changeAuthor.disabled = false;
    form.removeAttribute('aria-busy'); updateSubmit();
   }
  });
  async function loadPage() {
   if (interacting()) return;
   paging = true; expand.disabled = more.disabled = true; updateSubmit();
   try {
    const result = await store.page(card.id, pageLoaded ? cursor : null);
    comments = pageLoaded ? [...new Map([...comments, ...result.comments].map(comment => [comment.id, comment])).values()] : result.comments;
    cursor = result.cursor; hasMore = result.hasMore; pageLoaded = true; expanded = true;
    feedback.hidden = true; render();
   } catch (error) { feedback.textContent = commentErrorMessage(error); feedback.hidden = false; }
   finally { paging = false; updateSubmit(); }
  }
  expand.addEventListener('click', () => {
   if (expanded || pageLoaded) { expanded = !expanded; render(); } else loadPage();
  });
  more.addEventListener('click', loadPage);
  retry.addEventListener('click', () => load(true));
  thumbnailBadge.addEventListener('click', () => { section.scrollIntoView({block:'center',behavior:'smooth'}); section.focus({preventScroll:true}); });
  cardControls.set(card, {load, refreshOwnership}); commentsObserver?.observe(card);
  if (!commentsObserver) load();
  render(); section.hidden = false; resizeObserver?.observe(card);
 });
 if (!resizeObserver) window.addEventListener('resize', () => textChecks.forEach((_, card) => checkText(card)));
})();
</script>
</body>
</html>
