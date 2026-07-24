#!/usr/bin/env python3
"""
data/landmarks.json + data/glossary.json을 읽어 단일 HTML 파일을 생성.

사용법:
    python scripts/build.py             # output/index.html 생성
    python scripts/build.py --watch     # 파일 변경 감지 (간단 폴링)

생성된 HTML은 self-contained 단일 파일이며 images/ 폴더의 이미지를 상대경로로 참조.
"""
import argparse
import html as htmllib
import json
import re
import struct
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
TEMPLATE_DIR = ROOT / "templates"
IMG_DIR = ROOT / "images"
PROGRESS_SRC_DIR = ROOT / "progress"  # 진행 보고용 glb·스크린샷 원본
BALADY_SRC_DIR = ROOT / "balady_plus"  # Balady+ 참조 모델(MOMRAH 기존 자산) glb
# 빌드 결과는 docs/ 에 — GitHub Pages 호스팅 디렉토리
OUTPUT_DIR = ROOT / "docs"
OUTPUT = OUTPUT_DIR / "index.html"
OUTPUT_IMG_DIR = OUTPUT_DIR / "images"
OUTPUT_PROGRESS_DIR = OUTPUT_DIR / "progress"
OUTPUT_PROGRESS_ASSETS = OUTPUT_PROGRESS_DIR / "assets"


def esc(text: str) -> str:
    return htmllib.escape(text or "")


# Tier 색상 매핑 — 한색 계열 구분 강화 (deep blue / saturated teal / neutral slate)
TIER_LABEL = {1: "Tier 1", 2: "Tier 2", 3: "Tier 3"}
TIER_SUBTITLE = {1: "핵심", 2: "주요", 3: "추가"}

# Spec sheet 핵심 5라벨 (모든 카드에 동일 순서로 노출)
CORE_STRUCT_LABELS = ["형태", "규모", "재료", "시대", "설계"]

# 랜드마크별 최신 진행 업데이트 날짜 (build_progress가 채움 → 카드 배지용)
PROGRESS_LATEST = {}
# 랜드마크별 대표 3D 모델 (Reference 카드 3D 버튼용)
PROGRESS_REP_MODELS = {}

# ── glb 다운로드 버튼 토글 ──────────────────────────────────────────
# True  → Files 카드·3D 모달에 glb 다운로드 버튼 표시
# False → glb 다운로드 버튼 제거 (3D 뷰어·이미지 다운로드는 그대로 유지)
# 끄거나 켠 뒤 `python3 scripts/build.py` 만 다시 돌리면 즉시 반영.
GLB_DOWNLOAD = False

# 3D 모달 다운로드 버튼 HTML (GLB_DOWNLOAD=False면 빈 문자열로 대체)
MODAL_DL_BTN = (
    '<a class="model-dl" id="modal-dl" download title="모델 다운로드">'
    '<svg width="11" height="11" viewBox="0 0 11 11" fill="none"><path d="M5.5 1 L5.5 7 M3 5 L5.5 7.5 L8 5 M2 9.5 L9 9.5" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/></svg>'
    '<span id="modal-dl-label"></span></a>'
) if GLB_DOWNLOAD else ""


# 공유 3D 모델 모달 — Reference·Worklog 양쪽에 주입. {{ASSET_BASE}}만 페이지별로 다름.
MODEL_MODAL = """
<!-- ───── SHARED 3D MODEL MODAL ───── -->
<div class="model-modal" id="model-modal" aria-hidden="true">
  <div class="model-modal-panel" role="dialog" aria-modal="true" aria-label="3D 모델 뷰어">
    <button class="model-modal-close" id="model-modal-close" aria-label="닫기">&times;</button>
    <div class="model-modal-stage">
      <model-viewer id="modal-mv" camera-controls auto-rotate environment-image="legacy" exposure="0.55" shadow-intensity="1.3" shadow-softness="0.2" tone-mapping="agx" interaction-prompt="none"></model-viewer>
    </div>
    <div class="model-modal-foot">
      <div class="model-modal-tabs" id="modal-tabs"></div>
      <span class="model-tri" id="modal-tri" hidden></span>
      <button class="model-wire-toggle" id="modal-wire" aria-pressed="false" title="와이어프레임 토글">
        <svg width="13" height="13" viewBox="0 0 13 13" fill="none"><path d="M6.5 1 L11.5 3.6 L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12 M1.5 6.5 L11.5 6.5 M6.5 1 L6.5 6.3" stroke="currentColor" stroke-width="1" stroke-linejoin="round"/></svg>
        <span>와이어프레임</span>
      </button>
      {{DL_BTN}}
    </div>
  </div>
</div>
<style>
.model-modal {
  position: fixed; inset: 0; z-index: 250;
  display: none; align-items: center; justify-content: center;
  background: rgba(8, 12, 20, 0.78);
  backdrop-filter: blur(6px);
  padding: 40px;
}
.model-modal.open { display: flex; }
.model-modal-panel {
  position: relative;
  width: min(880px, 100%);
  background: var(--bg-elev);
  border: 1px solid var(--border);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 24px 70px rgba(0,0,0,0.4);
}
.model-modal-close {
  position: absolute; top: 12px; right: 12px; z-index: 10;
  width: 34px; height: 34px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  background: color-mix(in srgb, var(--bg-elev) 80%, transparent);
  backdrop-filter: blur(6px);
  border: 1px solid var(--border);
  color: var(--ink-soft); font-size: 20px; line-height: 1;
}
.model-modal-close:hover { color: var(--ink); background: var(--bg-sunken); }
.model-modal-stage {
  width: 100%; height: min(64vh, 540px);
  background: radial-gradient(circle at 50% 38%, #5b6573 0%, #3a414d 55%, #272c34 100%);
}
.model-modal-stage model-viewer { width: 100%; height: 100%; --poster-color: transparent; }
.model-modal-foot {
  display: flex; align-items: center; gap: 12px;
  padding: 14px 18px;
  border-top: 1px solid var(--border);
  flex-wrap: wrap;
}
.model-modal-tabs { display: flex; flex-wrap: wrap; gap: 6px; flex: 1; min-width: 0; }
.model-modal-tab {
  padding: 6px 12px; border-radius: 8px;
  background: var(--bg-sunken); border: 1px solid var(--border);
  font-size: 12.5px; font-weight: 500; color: var(--ink-soft);
  display: inline-flex; align-items: baseline; gap: 6px;
}
.model-modal-tab:hover { color: var(--ink); }
.model-modal-tab.active { border-color: var(--accent); color: var(--ink); }
.model-tri {
  font-family: var(--mono);
  font-size: 11px;
  color: var(--ink-mute);
  padding: 6px 10px;
  border-radius: 8px;
  background: var(--bg-sunken);
  flex-shrink: 0;
  white-space: nowrap;
}
.model-wire-toggle {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 7px 12px; border-radius: 8px;
  background: var(--bg-sunken); border: 1px solid var(--border);
  font-size: 11.5px; font-weight: 500; color: var(--ink-soft);
  flex-shrink: 0;
  transition: background 0.14s ease, color 0.14s ease, border-color 0.14s ease;
}
.model-wire-toggle:hover { color: var(--ink); }
.model-wire-toggle[aria-pressed="true"] {
  background: var(--accent); color: #fff; border-color: var(--accent);
}
.model-wire-toggle svg { flex-shrink: 0; }
.model-modal .model-dl {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 8px 14px; border-radius: 8px;
  background: var(--ink); color: var(--bg-elev);
  font-family: var(--mono); font-size: 11px;
  flex-shrink: 0;
}
.model-modal .model-dl:hover { opacity: 0.88; }
@media (max-width: 640px) {
  .model-modal { padding: 16px; }
  .model-modal-stage { height: 48vh; }
}
</style>
<script>
(function(){
  const ASSET_BASE = '{{ASSET_BASE}}';
  const modal = document.getElementById('model-modal');
  if (!modal) return;
  const mv = document.getElementById('modal-mv');
  const tabsEl = document.getElementById('modal-tabs');
  const dl = document.getElementById('modal-dl');
  const dlLabel = document.getElementById('modal-dl-label');
  const wireBtn = document.getElementById('modal-wire');
  const triEl = document.getElementById('modal-tri');
  let wireOn = false;
  let currentTris = null;  // 빌드 시 정확 계산된 값

  // model-viewer 내부 Three.js scene 접근 (와이어프레임용)
  function getScene(){
    const sym = Object.getOwnPropertySymbols(mv).find(s => s.description === 'scene');
    return sym ? mv[sym] : null;
  }
  function applyWire(){
    const scene = getScene();
    if (!scene) return;
    scene.traverse(o => { if (o.isMesh && o.material) {
      (Array.isArray(o.material) ? o.material : [o.material]).forEach(mat => mat.wireframe = wireOn);
    }});
    if (typeof scene.queueRender === 'function') scene.queueRender();
  }
  function updateTri(){
    // 빌드 시 glTF accessor로 정확히 계산한 값 사용 (뷰어 실시간 카운트는 그림자 평면 포함 오차)
    if (currentTris == null) { triEl.hidden = true; return; }
    triEl.hidden = false;
    triEl.textContent = '△ ' + currentTris.toLocaleString() + ' tris';
  }
  // 모델 로드 완료 때마다 와이어 상태 반영
  mv.addEventListener('load', () => { applyWire(); });

  function load(models, idx){
    const m = models[idx];
    const src = ASSET_BASE + m.file;
    mv.setAttribute('src', src);
    const name = m.file.split('/').pop();
    if (dl) {  // 다운로드 버튼이 꺼져 있으면(GLB_DOWNLOAD=False) 없을 수 있음
      dl.href = src;
      dl.setAttribute('download', name);
      dlLabel.textContent = name + ' (' + (m.mb!=null? m.mb.toFixed(1):'0.0') + ' MB)';
    }
    currentTris = (m.tris != null) ? m.tris : null;
    updateTri();
    tabsEl.querySelectorAll('.model-modal-tab').forEach((t,i)=> t.classList.toggle('active', i===idx));
  }

  wireBtn.addEventListener('click', () => {
    wireOn = !wireOn;
    wireBtn.setAttribute('aria-pressed', wireOn ? 'true' : 'false');
    applyWire();
  });

  window.openModelModal = function(models, startIdx){
    if (!models || !models.length) return;
    // 와이어프레임 상태 초기화 (이전 세션이 남지 않게)
    wireOn = false;
    wireBtn.setAttribute('aria-pressed', 'false');
    triEl.hidden = true;
    tabsEl.innerHTML = '';
    // 모델 1개면 탭 숨김
    if (models.length > 1) {
      models.forEach((m, i) => {
        const b = document.createElement('button');
        b.className = 'model-modal-tab';
        b.innerHTML = (m.label || m.file);
        b.addEventListener('click', () => load(models, i));
        tabsEl.appendChild(b);
      });
    }
    load(models, startIdx || 0);
    modal.classList.add('open');
    document.body.style.overflow = 'hidden';
  };

  function close(){ modal.classList.remove('open'); mv.removeAttribute('src'); document.body.style.overflow=''; }
  document.getElementById('model-modal-close').addEventListener('click', close);
  modal.addEventListener('click', e => { if (e.target === modal) close(); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape' && modal.classList.contains('open')) close(); });

  // 모든 .model-btn 트리거 연결
  document.querySelectorAll('.model-btn').forEach(btn => {
    btn.addEventListener('click', e => {
      e.preventDefault(); e.stopPropagation();
      try {
        const models = JSON.parse(btn.getAttribute('data-models'));
        window.openModelModal(models, parseInt(btn.getAttribute('data-start')||'0', 10));
      } catch(err) {}
    });
  });
})();
</script>
"""


def render_card(lm: dict) -> str:
    idx = lm["idx"]
    idx_str = lm["id"]
    tier = lm["tier"]
    city = lm["city"]
    type_ = lm["type"]
    modeling = lm.get("modeling", {})

    # 폴더에서 idx 매칭되는 모든 이미지 자동 수집 (알파벳순)
    # 메인은 보통 짧은 슬러그, 추가본은 _2/_3 접미어로 정렬 가능
    prefix = f"{idx_str}_"
    valid_ext = (".jpg", ".jpeg", ".png", ".webp")
    image_files = []
    if IMG_DIR.exists():
        image_files = sorted([
            f for f in IMG_DIR.iterdir()
            if f.is_file()
            and not f.name.startswith(".")
            and f.name.startswith(prefix)
            and f.suffix.lower() in valid_ext
        ], key=lambda p: p.name)

    img_html = ""
    no_image_class = ""
    if image_files:
        slides = []
        for f in image_files:
            cb = f"?v={int(f.stat().st_mtime)}"
            slides.append(
                f'<img class="card-slide" src="images/{f.name}{cb}" '
                f'alt="{esc(lm["name"])}" loading="lazy">'
            )
        nav_html = ""
        if len(image_files) > 1:
            dots = "".join(
                f'<button class="card-dot{" active" if i == 0 else ""}" '
                f'data-idx="{i}" aria-label="이미지 {i + 1}/{len(image_files)}"></button>'
                for i in range(len(image_files))
            )
            nav_html = (
                '<button class="card-arrow card-arrow--prev" aria-label="이전 이미지">‹</button>'
                '<button class="card-arrow card-arrow--next" aria-label="다음 이미지">›</button>'
                f'<div class="card-dots">{dots}</div>'
                f'<span class="card-counter">1 / {len(image_files)}</span>'
            )
        img_html = f'<div class="card-slider">{"".join(slides)}{nav_html}</div>'
    elif lm["image"].get("url"):
        img_html = f'<img class="card-slide active" src="{esc(lm["image"]["url"])}" alt="{esc(lm["name"])}" loading="lazy">'
    elif lm["image"].get("fallback"):
        img_html = f'<img class="card-slide active" src="{esc(lm["image"]["fallback"])}" alt="{esc(lm["name"])}" loading="lazy">'
    else:
        no_image_class = " no-image"

    # 이름 (여러 줄 지원) + 선택적 부제 (대체명 등)
    name_lines_html = "<br>".join(esc(l) for l in lm["name_lines"]) if lm.get("name_lines") else esc(lm["name"])
    subtitle_html = f'<p class="card-subtitle">{esc(lm["subtitle"])}</p>' if lm.get("subtitle") else ""

    # 헤어라인 리스트 항목 헬퍼
    def _hl_item(primary: str, aux: str = "", cls: str = "") -> str:
        aux_html = f'<div class="hl-aux">{esc(aux)}</div>' if aux else ""
        return f'<div class="hl-item{cls}"><div class="hl-primary">{esc(primary)}</div>{aux_html}</div>'

    def _hl_kv(label: str, value: str, cls: str = "") -> str:
        return f'<div class="hl-item hl-item--kv{cls}"><dt>{esc(label)}</dt><dd>{esc(value)}</dd></div>'

    # must_have / key_points: 마지막 괄호를 보조 텍스트로 분리
    def _split_paren_aux(s: str) -> tuple:
        m = re.match(r"^(.*?)\s*\(([^()]+)\)\s*$", s.strip())
        if m:
            return m.group(1).strip(), m.group(2).strip()
        return s.strip(), ""

    # Must-have (필수 모델링 요소)
    mh_items = lm.get("must_have", [])
    must_have_html = ""
    if mh_items:
        rows = []
        for item in mh_items:
            primary, aux = _split_paren_aux(item)
            rows.append(_hl_item(primary, aux))
        must_have_html = (
            '<section class="card-section card-section--must-have">'
            '<h4 class="section-eyebrow section-eyebrow--accent">Essentials</h4>'
            f'<div class="hairline-list">{"".join(rows)}</div>'
            '</section>'
        )

    # Key Points
    kps_data = lm.get("key_points", [])
    key_points_html = ""
    if kps_data:
        rows = []
        for kp in kps_data:
            primary, aux = _split_paren_aux(kp)
            rows.append(_hl_item(primary, aux))
        key_points_html = (
            '<section class="card-section">'
            '<h4 class="section-eyebrow">Key Points</h4>'
            f'<div class="hairline-list">{"".join(rows)}</div>'
            '</section>'
        )

    # Structure: 핵심 라벨 5종 + 추가 라벨 + 모델링 메타 (폴리곤·좌표)
    structure = [s for s in lm.get("structure", []) if s["label"] != "확인필요"]
    struct_map = {s["label"]: s["value"] for s in structure}
    extras = [s for s in structure if s["label"] not in CORE_STRUCT_LABELS]
    rows_html = []
    for label in CORE_STRUCT_LABELS:
        val = struct_map.get(label, "—")
        cls = "" if val != "—" else " hl-item--missing"
        rows_html.append(_hl_kv(label, val, cls))
    for s in extras:
        rows_html.append(_hl_kv(s["label"], s["value"], " hl-item--extra"))

    # Modeling 메타 (폴리곤 예산 — 취소선, WGS84 좌표)
    size_class = modeling.get("size_class")
    tri_budget = modeling.get("tri_budget")
    wgs84 = modeling.get("wgs84")
    if size_class:
        if tri_budget:
            budget_val = f"≤{tri_budget:,} tris · {size_class}"
        else:
            budget_val = f"별도 협의 · {size_class}"
        rows_html.append(_hl_kv("폴리곤 예산", budget_val, " hl-item--deprecated"))
    if wgs84:
        lat = wgs84.get("lat")
        lon = wgs84.get("lon")
        coord_val = f"{lat:.7f}, {lon:.7f}"
        rows_html.append(_hl_kv("WGS84", coord_val, " hl-item--coord"))
    struct_rows = "".join(rows_html)

    # Part Heights
    ph_items = modeling.get("part_heights", [])
    part_heights_html = ""
    if ph_items:
        ph_rows = "".join(_hl_kv(p["part"], p["value"]) for p in ph_items)
        part_heights_html = (
            '<section class="card-section">'
            '<h4 class="section-eyebrow">Part Heights</h4>'
            f'<dl class="hairline-list hairline-list--kv">{ph_rows}</dl>'
            '</section>'
        )

    # Modeling Notes 섹션 제거됨

    # Tags
    tag_html = " ".join(f'<span class="tag">{esc(t)}</span>' for t in lm["tags"])
    remarks_html = " ".join(f'<span class="tag tag-alert">{esc(r)}</span>' for r in lm["remarks"])

    # Balady/MOMRAH 50 리스트와 중복되는 랜드마크 표시
    dup_html = ""
    if lm.get("balady_dup"):
        dup_html = (
            '<span class="tag tag-dup" title="Balady/MOMRAH 50 리스트와 중복 — 기존 3D 자산 존재">'
            'Balady +</span>'
        )

    # 검증 미완(=기존 '확인필요' 행) → 카드 헤더 DRAFT 핀으로 분리
    uncertain_items = [s["value"] for s in lm.get("structure", []) if s["label"] == "확인필요"]
    draft_html = ""
    if uncertain_items:
        joined = " · ".join(uncertain_items)
        draft_html = f'<span class="tag tag-draft" title="검증 미완: {esc(joined)}">DRAFT</span>'

    # 데이터 신뢰도 — LOW일 때 이미지에 경고 아이콘
    confidence = modeling.get("data_confidence")
    confidence_note = modeling.get("data_confidence_note", "")
    confidence_html = ""
    if confidence == "low":
        confidence_html = (
            f'<span class="card-warning" title="권위 자료 부족 — {esc(confidence_note)}">'
            f'<svg width="11" height="11" viewBox="0 0 11 11" aria-hidden="true">'
            f'<path d="M5.5 1 L10 9.5 L1 9.5 Z" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linejoin="round"/>'
            f'<path d="M5.5 4.5 L5.5 7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>'
            f'<circle cx="5.5" cy="8.4" r="0.6" fill="currentColor"/>'
            f'</svg>'
            f'<span>DATA LOW</span>'
            f'</span>'
        )

    # 진행 업데이트 배지 — progress.json에 해당 카드 엔트리가 있으면 이미지에 표시
    progress_badge_html = ""
    upd_date = PROGRESS_LATEST.get(idx_str)
    if upd_date:
        short = upd_date[5:] if len(upd_date) >= 10 else upd_date  # MM-DD
        progress_badge_html = (
            f'<a class="card-progress-badge" href="progress/" '
            f'title="Worklog 업데이트 {esc(upd_date)} — Worklog 페이지에서 보기">'
            f'<svg width="9" height="9" viewBox="0 0 9 9" aria-hidden="true">'
            f'<circle cx="4.5" cy="4.5" r="3.5" fill="none" stroke="currentColor" stroke-width="1.1"/>'
            f'<path d="M4.5 2.6 L4.5 4.5 L5.9 5.4" stroke="currentColor" stroke-width="1.1" stroke-linecap="round"/>'
            f'</svg>'
            f'<span>Updated {esc(short)}</span></a>'
        )

    # 카드 헤더의 status 뱃지 (task_type 태그는 전 카드 동일값이라 미표시)
    status = modeling.get("status")
    status_html = ""
    if status:
        status_cls = {
            "완공": "tag-status-done",
            "건설 중": "tag-status-wip",
            "계획": "tag-status-plan",
        }.get(status, "tag-status-done")
        status_html = f'<span class="tag tag-status {status_cls}">{esc(status)}</span>'

    # Links
    links_parts = []
    # Google Maps 링크 — xlsx의 정확한 핀 URL이 있으면 우선, 없으면 검색 URL
    if lm["links"].get("google_maps_url"):
        gmaps_url = lm["links"]["google_maps_url"]
    else:
        gmaps_q = lm["links"]["google_maps_query"]
        gmaps_url = f"https://www.google.com/maps/search/?api=1&query={esc(gmaps_q.replace(' ', '+'))}"
    links_parts.append(
        f'<a class="ref-link" href="{esc(gmaps_url)}" target="_blank" rel="noopener">'
        f'<span>Google Maps</span><svg width="10" height="10" viewBox="0 0 10 10">'
        f'<path d="M2 8 L8 2 M3.5 2 L8 2 L8 6.5" stroke="currentColor" stroke-width="1" fill="none" stroke-linecap="square"/>'
        f'</svg></a>'
    )
    # Google Earth (3D 오블리크 뷰) — wgs84 좌표가 있으면 자동 생성
    wgs = modeling.get("wgs84")
    if wgs and wgs.get("lat") is not None and wgs.get("lon") is not None:
        lat, lon = wgs["lat"], wgs["lon"]
        # @lat,lon,altitude_a,distance_d,fov_y,heading_h,tilt_t,roll_r
        # 탑뷰 + 좁은 FOV로 orthographic 느낌 (1500m 거리, 20° FOV, 기울기 0)
        gearth_url = (
            f"https://earth.google.com/web/@{lat},{lon},"
            f"0a,1500d,20y,0h,0t,0r"
        )
        links_parts.append(
            f'<a class="ref-link" href="{esc(gearth_url)}" target="_blank" rel="noopener">'
            f'<span>Google Earth</span><svg width="10" height="10" viewBox="0 0 10 10">'
            f'<path d="M2 8 L8 2 M3.5 2 L8 2 L8 6.5" stroke="currentColor" stroke-width="1" fill="none" stroke-linecap="square"/>'
            f'</svg></a>'
        )
        # OpenStreetMap (실제 building footprint 확인) — 줌 19로 건물 외곽선 보이게
        osm_url = f"https://www.openstreetmap.org/?mlat={lat}&mlon={lon}#map=19/{lat}/{lon}"
        links_parts.append(
            f'<a class="ref-link" href="{esc(osm_url)}" target="_blank" rel="noopener">'
            f'<span>OSM (footprint)</span><svg width="10" height="10" viewBox="0 0 10 10">'
            f'<path d="M2 8 L8 2 M3.5 2 L8 2 L8 6.5" stroke="currentColor" stroke-width="1" fill="none" stroke-linecap="square"/>'
            f'</svg></a>'
        )
    for extra in lm["links"]["extras"]:
        links_parts.append(
            f'<a class="ref-link" href="{esc(extra["url"])}" target="_blank" rel="noopener">'
            f'<span>{esc(extra["label"])}</span><svg width="10" height="10" viewBox="0 0 10 10">'
            f'<path d="M2 8 L8 2 M3.5 2 L8 2 L8 6.5" stroke="currentColor" stroke-width="1" fill="none" stroke-linecap="square"/>'
            f"</svg></a>"
        )
    # 3D 모델 버튼 — 이 랜드마크 대표 모델이 있으면 공유 모달 호출
    rep = PROGRESS_REP_MODELS.get(idx_str)
    if rep:
        rep_payload = esc(json.dumps([rep], ensure_ascii=False))
        links_parts.insert(0,
            f'<button class="ref-link ref-link--3d model-btn" data-models="{rep_payload}" data-start="0">'
            f'<svg width="11" height="11" viewBox="0 0 13 13" fill="none">'
            f'<path d="M6.5 1 L11.5 3.6 L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/>'
            f'<path d="M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/>'
            f'</svg><span>3D Viewer</span></button>'
        )
    links_html = "".join(links_parts)

    # 검색용 데이터 속성 (스펙 시트: must_have + structure + key_points까지 포함)
    search_str = " ".join([
        lm["name"].lower(),
        lm["city"].lower(),
        lm["type"].lower(),
        " ".join(lm["tags"]).lower(),
        " ".join(lm.get("must_have", [])).lower(),
        " ".join(s.get("value", "") for s in lm.get("structure", [])).lower(),
        " ".join(lm.get("key_points", [])).lower(),
        "balady 중복 momrah" if lm.get("balady_dup") else "",
    ])

    has_3d = "yes" if PROGRESS_REP_MODELS.get(idx_str) else "no"
    dup_flag = "yes" if lm.get("balady_dup") else "no"

    return f"""
<article class="card" id="card-{idx_str}"
         data-tier="tier-{tier}"
         data-city="city-{city.upper().replace(' ', '-')}"
         data-type="type-{type_}"
         data-has3d="{has_3d}"
         data-dup="{dup_flag}"
         data-search="{esc(search_str)}">
  <div class="card-image{no_image_class}">
    {img_html}
    <div class="card-image-meta">
      <span class="card-num">№ {idx_str}</span>
      <div class="card-image-meta-right">
        {confidence_html}
        <span class="card-tier-pill tier-{tier}">T{tier}</span>
      </div>
    </div>
    {progress_badge_html}
  </div>
  <div class="card-content">
    <header class="card-header">
      <div class="card-meta">
        <span class="meta-item">{esc(lm["city"])}</span>
        <span class="meta-divider">/</span>
        <span class="meta-item">{esc(type_.title())}</span>
      </div>
      <h3 class="card-title">{name_lines_html}</h3>
      {subtitle_html}
      <div class="card-tags">{status_html}{dup_html}{tag_html}{remarks_html}{draft_html}</div>
    </header>

    {must_have_html}

    {key_points_html}

    <section class="card-section card-section--structure">
      <h4 class="section-eyebrow">Structure</h4>
      <dl class="hairline-list hairline-list--kv">{struct_rows}</dl>
    </section>

    {part_heights_html}

    <footer class="card-footer">
      <div class="ref-links">{links_html}</div>
    </footer>
  </div>
</article>"""


def render_sidebar_item(lm: dict) -> str:
    idx_str = lm["id"]
    return (
        f'<a href="#card-{idx_str}" class="nav-item" '
        f'data-tier="tier-{lm["tier"]}" '
        f'data-city="city-{lm["city"].upper().replace(" ", "-")}" '
        f'data-type="type-{lm["type"]}" '
        f'data-search="{esc(lm["name"].lower())}">'
        f'<span class="nav-num">{idx_str}</span>'
        f'<span class="nav-label">{esc(lm["name"])}</span>'
        f'<span class="nav-tier tier-{lm["tier"]}"></span>'
        f"</a>"
    )


def render_glossary(glossary: list) -> str:
    parts = []
    for cat in glossary:
        terms_html = "".join(
            f'<div class="hl-item gloss-term">'
            f'<div class="gloss-term-row">'
            f'<span class="gloss-kr">{esc(t["kr"])}</span>'
            f'<span class="gloss-en">{esc(t["en"])}</span>'
            f"</div>"
            f'<p class="gloss-desc">{esc(t["desc"])}</p>'
            f'<p class="gloss-where">{esc(t["where"])}</p>'
            f"</div>"
            for t in cat["terms"]
        )
        parts.append(f"""
<div class="gloss-cat">
  <div class="gloss-cat-head">
    <h3 class="section-eyebrow section-eyebrow--accent">{esc(cat["category"])}</h3>
    <p class="gloss-cat-desc">{esc(cat["desc"])}</p>
  </div>
  <div class="hairline-list">{terms_html}</div>
</div>""")
    return "".join(parts)


def extract_palette(template_text: str) -> str:
    """메인 템플릿에서 :root + [data-theme=dark] 팔레트 블록 추출 (progress 페이지 색 동기화)"""
    blocks = []
    for pat in (r":root\s*\{[^}]*\}", r'\[data-theme="dark"\]\s*\{[^}]*\}'):
        m = re.search(pat, template_text)
        if m:
            blocks.append(m.group(0))
    return "\n\n".join(blocks)


def glb_triangle_count(path: Path):
    """glb 파일을 직접 파싱해 삼각형 수 계산 (glTF accessor 기준 — 정확). 실패 시 None"""
    try:
        data = path.read_bytes()
        magic, _ver, length = struct.unpack("<III", data[:12])
        if magic != 0x46546C67:
            return None
        off, gltf = 12, None
        while off < length:
            clen, ctype = struct.unpack("<I4s", data[off:off + 8])
            if ctype == b"JSON":
                gltf = json.loads(data[off + 8:off + 8 + clen])
                break
            off += 8 + clen
        if not gltf:
            return None
        accessors = gltf.get("accessors", [])
        nodes = gltf.get("nodes", [])
        meshes = gltf.get("meshes", [])

        def prim_tris(p):
            if p.get("mode", 4) != 4:  # TRIANGLES만 정확 카운트
                return 0
            if "indices" in p:
                return accessors[p["indices"]]["count"] // 3
            pos = p.get("attributes", {}).get("POSITION")
            return accessors[pos]["count"] // 3 if pos is not None else 0

        mesh_tris = [sum(prim_tris(p) for p in m.get("primitives", [])) for m in meshes]
        scenes = gltf.get("scenes", [])
        roots = scenes[gltf.get("scene", 0)]["nodes"] if scenes else range(len(nodes))
        total = 0
        seen = set()

        def walk(ni):
            nonlocal total
            if ni in seen:  # 순환 방지
                return
            seen.add(ni)
            n = nodes[ni]
            if "mesh" in n:
                total += mesh_tris[n["mesh"]]
            for c in n.get("children", []):
                walk(c)
        for ni in roots:
            walk(ni)
        return total
    except Exception:
        return None


def glb_has_material(path: Path) -> bool:
    """glb에 머티리얼/텍스처가 있는지 (있으면 뷰어에 색/텍스처 표시됨)"""
    try:
        data = path.read_bytes()
        if struct.unpack("<I", data[:4])[0] != 0x46546C67:
            return False
        off, length = 12, struct.unpack("<I", data[8:12])[0]
        while off < length:
            clen, ctype = struct.unpack("<I4s", data[off:off + 8])
            if ctype == b"JSON":
                g = json.loads(data[off + 8:off + 8 + clen])
                return len(g.get("materials", [])) > 0 or len(g.get("textures", [])) > 0
            off += 8 + clen
    except Exception:
        pass
    return False


def parse_landmark_id(filename: str):
    """파일명에서 랜드마크 번호 추출. KSA-01.glb / 01-1.png / 013-1_0090.png → '01'/'13'"""
    m = re.match(r"(?:KSA[-_]?)?0*(\d{1,3})", filename, re.IGNORECASE)
    if not m:
        return None
    n = int(m.group(1))
    return f"{n:02d}" if 1 <= n <= 40 else None


def scan_progress_files(landmarks: list, src_dir: Path = PROGRESS_SRC_DIR, asset_prefix: str = "") -> dict:
    """src_dir 폴더 스캔 → 랜드마크 번호별 {models, shots} 그룹핑 (자동 감지).
    asset_prefix: 모델 file 경로 앞에 붙는 에셋 하위경로(예: 'balady/')."""
    groups = {}
    if not src_dir.exists():
        return groups
    MODEL_EXT = (".glb",)
    IMG_EXT = (".png", ".jpg", ".jpeg", ".webp")
    for f in sorted(src_dir.iterdir(), key=lambda p: p.name.lower()):
        if not f.is_file() or f.name.startswith(".") or f.name.lower() == "readme.md":
            continue
        ext = f.suffix.lower()
        lid = parse_landmark_id(f.name)
        if lid is None:
            continue
        g = groups.setdefault(lid, {"models": [], "shots": []})
        if ext in MODEL_EXT:
            mb = f.stat().st_size / (1024 * 1024)
            textured = glb_has_material(f)
            g["models"].append({
                "file": asset_prefix + f.name,
                "label": "텍스처" if textured else "기본",
                "mb": round(mb, 2),
                "tris": glb_triangle_count(f),  # 빌드 시 정확 계산
                "_textured": textured,
            })
        elif ext in IMG_EXT:
            g["shots"].append(f.name)

    from collections import Counter
    for g in groups.values():
        # 텍스처 버전을 항상 앞으로 (기본 활성 탭) — 같은 상태끼린 파일명 순
        g["models"].sort(key=lambda m: (not m["_textured"], m["file"].lower()))
        # 동일 라벨 충돌 방지(같은 상태 모델 2개 이상) — 번호 붙임
        cnt = Counter(m["label"] for m in g["models"])
        seen = {}
        for m in g["models"]:
            if cnt[m["label"]] > 1:
                seen[m["label"]] = seen.get(m["label"], 0) + 1
                m["label"] = f'{m["label"]} {seen[m["label"]]}'
    return groups


def scan_balady_catalog() -> list:
    """data/balady_50.json + balady_plus/ → Balady 50종 카탈로그(모델 메타 포함)."""
    cat_path = ROOT / "data" / "balady_50.json"
    if not cat_path.exists() or not BALADY_SRC_DIR.exists():
        return []
    catalog = json.loads(cat_path.read_text(encoding="utf-8"))
    out = []
    for e in catalog:
        f = BALADY_SRC_DIR / e["file"]
        if not f.exists():
            continue
        mb = f.stat().st_size / (1024 * 1024)
        # 뷰어 첫 프레임 캡처 썸네일 (있으면 카드 커버로 사용)
        tid = e["file"].rsplit(".", 1)[0]  # B01.glb → B01
        thumb_fs = OUTPUT_PROGRESS_ASSETS / "balady" / "thumbs" / f"{tid}.png"
        thumb = f"assets/balady/thumbs/{tid}.png" if thumb_fs.exists() else None
        out.append({**e, "thumb": thumb, "model": {
            "file": "balady/" + e["file"], "label": "Balady",
            "mb": round(mb, 2), "tris": glb_triangle_count(f),
            "_textured": glb_has_material(f),
        }})
    out.sort(key=lambda e: e["num"])
    return out


def balady_grouped(cat: list) -> list:
    """Balady 50종을 클러스터+지역 혼합으로 그룹핑 → [{title, sub, items}]."""
    by_num = {e["num"]: e for e in cat}
    used = set()
    groups = []

    def take(nums, title, sub):
        items = [by_num[n] for n in nums if n in by_num]
        used.update(n for n in nums if n in by_num)
        if items:
            groups.append({"title": title, "sub": sub, "items": items})

    # 단지 클러스터 먼저
    take(range(1, 9), "KAFD 단지", "Riyadh · KAFD 금융지구")
    take(range(18, 26), "Boulevard World", "Riyadh · 테마파크")
    take(range(26, 30), "Boulevard City", "Riyadh · 엔터테인먼트")
    # 나머지는 지역별
    rest = [e for e in cat if e["num"] not in used]
    region_order = ["Riyadh", "Makkah Prov.", "Eastern", "Madinah", "Asir", "Tabuk"]
    seen_regions = [r for r in region_order if any(e["region"] == r for e in rest)]
    seen_regions += sorted({e["region"] for e in rest if e["region"] not in region_order})
    for reg in seen_regions:
        items = [e for e in rest if e["region"] == reg]
        if items:
            label = (reg or "기타") + (" 개별" if reg == "Riyadh" else "")
            groups.append({"title": label, "sub": f"{len(items)}종", "items": items})
    return groups


def render_balady_card(entry: dict) -> str:
    """Balady+ 참조 카드 (우리 40종과 무관한 자체 번호·이름·지역)."""
    name, num, region = entry["name"], entry["num"], entry.get("region", "")
    payload = esc(json.dumps([entry["model"]], ensure_ascii=False))
    region_html = f'<span class="fc-region">{esc(region)}</span>' if region else ""
    cube = ('<svg width="34" height="34" viewBox="0 0 13 13" fill="none"><path d="M6.5 1 L11.5 3.6 '
            'L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12" '
            'stroke="currentColor" stroke-width="0.8" stroke-linejoin="round"/></svg>')
    viewer = ('<svg width="13" height="13" viewBox="0 0 13 13" fill="none" aria-hidden="true">'
              '<path d="M6.5 1 L11.5 3.6 L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/>'
              '<path d="M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/></svg>')
    # 커버 = 뷰어 첫 프레임 썸네일 (없으면 큐브 플레이스홀더)
    if entry.get("thumb"):
        cover = f'<div class="fc-cover fc-cover--model"><img src="{esc(entry["thumb"])}" alt="{esc(name)}" loading="lazy"></div>'
    else:
        cover = f'<div class="fc-cover fc-cover--3d">{cube}</div>'
    search_str = " ".join([
        name.lower(), f"{num:02d}", str(num), region.lower(),
        entry["model"]["file"].split("/")[-1].lower(), "balady",
    ])
    return f"""
<article class="file-card" data-search="{esc(search_str)}">
  <header class="fc-head">
    <span class="fc-num">№ {num:02d}</span>
    <span class="fc-name">{esc(name)}</span>
    {region_html}
    <span class="fc-badge fc-badge--balady">Balady +</span>
  </header>
  {cover}
  <div class="fc-actions"><button class="model-btn fc-3d" data-models="{payload}" data-start="0">{viewer}<span>3D Viewer</span></button></div>
</article>"""


def render_file_card(lid: str, group: dict, lm_map: dict, variant: str = "work") -> str:
    lm = lm_map.get(lid)
    lm_name = lm["name"] if lm else ""
    tier = lm["tier"] if lm else 0
    tier_dot = f'<span class="fc-tier tier-{tier}"></span>' if lm else ""
    badge_html = ""

    dl_svg = (
        '<svg width="11" height="11" viewBox="0 0 11 11" fill="none">'
        '<path d="M5.5 1 L5.5 7 M3 5 L5.5 7.5 L8 5 M2 9.5 L9 9.5" stroke="currentColor" '
        'stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/></svg>'
    )
    models = group["models"]
    shots = group["shots"]

    # 커버 = 첫 스크린샷 (없으면 3D placeholder)
    if shots:
        cover = (
            f'<div class="fc-cover"><img src="assets/{esc(shots[0])}" alt="{esc(lm_name)}" loading="lazy"></div>'
        )
    elif models:
        cover = '<div class="fc-cover fc-cover--3d"><svg width="34" height="34" viewBox="0 0 13 13" fill="none"><path d="M6.5 1 L11.5 3.6 L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12" stroke="currentColor" stroke-width="0.8" stroke-linejoin="round"/></svg></div>'
    else:
        cover = ""

    # 3D 보기 버튼 (모델 있으면) + 모델별 다운로드 칩
    actions = []
    if models:
        payload = esc(json.dumps(models, ensure_ascii=False))
        actions.append(
            f'<button class="model-btn fc-3d" data-models="{payload}" data-start="0">'
            f'<svg width="13" height="13" viewBox="0 0 13 13" fill="none" aria-hidden="true">'
            f'<path d="M6.5 1 L11.5 3.6 L11.5 9.4 L6.5 12 L1.5 9.4 L1.5 3.6 Z" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/>'
            f'<path d="M1.5 3.6 L6.5 6.3 L11.5 3.6 M6.5 6.3 L6.5 12" stroke="currentColor" stroke-width="1.1" stroke-linejoin="round"/>'
            f'</svg><span>3D Viewer</span></button>'
        )
    actions_html = f'<div class="fc-actions">{"".join(actions)}</div>' if actions else ""

    # glb 다운로드 — 모델별 활성 링크 (GLB_DOWNLOAD 토글로 on/off)
    dls = "".join(
        f'<a class="fc-dl" href="assets/{esc(m["file"])}" download title="{esc(m["file"])} 다운로드">'
        f'{dl_svg}<span>{esc(m["file"])}</span><span class="fc-dl-size">{m["mb"]:.1f} MB</span></a>'
        for m in models
    ) if GLB_DOWNLOAD else ""
    dls_html = f'<div class="fc-dls">{dls}</div>' if dls else ""

    # 스크린샷 썸네일 (커버 포함 전체 — 클릭 시 라이트박스, 개별 다운로드)
    thumbs = "".join(
        f'<div class="fc-shot">'
        f'<img src="assets/{esc(s)}" alt="{esc(lm_name)}" loading="lazy">'
        f'<a class="shot-dl" href="assets/{esc(s)}" download title="{esc(s)} 다운로드">{dl_svg}</a>'
        f'</div>'
        for s in shots
    )
    thumbs_html = f'<div class="fc-shots">{thumbs}</div>' if thumbs else ""

    search_str = " ".join([
        lm_name.lower(), lid, str(int(lid)),
        (lm.get("city", "") if lm else "").lower(),
        (lm.get("type", "") if lm else "").lower(),
        " ".join(m["file"].split("/")[-1].lower() for m in models),
    ])

    return f"""
<article class="file-card" data-search="{esc(search_str)}">
  <header class="fc-head">
    {tier_dot}
    <span class="fc-num">№ {esc(lid)}</span>
    <span class="fc-name">{esc(lm_name)}</span>
    {badge_html}
    <a class="fc-ref" href="../#card-{esc(lid)}" title="레퍼런스 카드 보기">↗</a>
  </header>
  {cover}
  {actions_html}
  {dls_html}
  {thumbs_html}
</article>"""


def build_files(landmarks: list, palette: str):
    """Files 페이지 렌더링 (폴더 자동 스캔) → docs/progress/index.html"""
    lm_map = {lm["id"]: lm for lm in landmarks}
    groups = scan_progress_files(landmarks)

    # 랜드마크 번호 오름차순 정렬
    sorted_ids = sorted(groups.keys())

    # Balady+ 참조 모델 — CSV 카탈로그 기반 50종 (우리 40종과 별개)
    balady_cat = scan_balady_catalog()

    def _section_html(title, sub, cards):
        return (
            f'<section class="files-section">'
            f'<div class="files-section-head">'
            f'<h2 class="files-section-title">{esc(title)}</h2>'
            f'<span class="files-section-sub">{esc(sub)}</span></div>'
            f'<div class="files-grid">\n{cards}\n    </div></section>'
        )

    template = (TEMPLATE_DIR / "progress.html.tpl").read_text(encoding="utf-8")

    def fill(entries, count, eyebrow, title, sub, back=""):
        o = template.replace("{{PALETTE}}", palette)
        o = o.replace("{{ENTRIES}}", entries)
        o = o.replace("{{COUNT}}", count)
        o = o.replace("{{PAGE_BACK}}", back)
        o = o.replace("{{PAGE_EYEBROW}}", eyebrow)
        o = o.replace("{{PAGE_TITLE}}", esc(title))
        o = o.replace("{{PAGE_SUB}}", esc(sub))
        o = o.replace("{{MODEL_MODAL}}", MODEL_MODAL.replace("{{ASSET_BASE}}", "assets/").replace("{{DL_BTN}}", MODAL_DL_BTN))
        return o

    # ── 메인 Files 페이지: 작업 파일 + Balady+ 진입 배너 ──
    work_section = ""
    if sorted_ids:
        work_cards = "\n".join(render_file_card(lid, groups[lid], lm_map) for lid in sorted_ids)
        work_section = _section_html("작업 파일", "팀이 제작 중인 3D 모델 · 캡처", work_cards)
    entry = ""
    if balady_cat:
        entry = (
            '<a class="balady-entry" href="balady.html">'
            '<span class="balady-entry-badge">Balady +</span>'
            '<span class="balady-entry-text">'
            '<span class="balady-entry-title">Balady+ 참조 모델</span>'
            f'<span class="balady-entry-sub">MOMRAH/Balady 기존 3D 자산 {len(balady_cat)}종 · 클러스터·지역별 정리 · 참조용</span>'
            '</span><span class="balady-entry-arrow">→</span></a>'
        )
    main_entries = "\n".join(x for x in (entry, work_section) if x) or (
        '<div class="empty"><div class="empty-title">아직 업로드된 파일이 없습니다</div>'
        '<p>progress/ 폴더에 KSA-NN.glb · NN-1.png 형식으로 파일을 넣으세요.</p></div>'
    )
    n_work = sum(len(g["models"]) + len(g["shots"]) for g in groups.values())
    main_count = f"작업 {len(sorted_ids)} · {n_work}개 파일   |   Balady+ 참조 {len(balady_cat)}종 →"

    OUTPUT_PROGRESS_DIR.mkdir(parents=True, exist_ok=True)
    (OUTPUT_PROGRESS_DIR / "index.html").write_text(
        fill(main_entries, main_count, "Files", "Model Files",
             "랜드마크별 3D 모델(.glb)과 이미지. 3D Viewer에서 이동·확대·회전하며 모델을 살펴볼 수 있습니다."),
        encoding="utf-8")

    # ── Balady+ 하위 페이지: 클러스터+지역 그룹 ──
    if balady_cat:
        groups_b = balady_grouped(balady_cat)
        bal_entries = "\n".join(
            _section_html(g["title"], g["sub"], "\n".join(render_balady_card(e) for e in g["items"]))
            for g in groups_b
        )
        bal_count = f"{len(balady_cat)}종 · {len(groups_b)}개 그룹"
        (OUTPUT_PROGRESS_DIR / "balady.html").write_text(
            fill(bal_entries, bal_count, "Files · Balady+", "Balady+ 참조 모델",
                 "MOMRAH/Balady 기존 3D 자산 50종 · 클러스터·지역별 정리 · 참조용 (다운로드 비활성)",
                 '<a class="page-back" href="./">← Files</a>'),
            encoding="utf-8")

    # 에셋 동기화: progress/ → docs/progress/assets/
    OUTPUT_PROGRESS_ASSETS.mkdir(parents=True, exist_ok=True)
    copied = 0
    if PROGRESS_SRC_DIR.exists():
        import shutil
        src_files = {f.name for f in PROGRESS_SRC_DIR.iterdir() if f.is_file() and not f.name.startswith(".")}
        dst_files = {f.name for f in OUTPUT_PROGRESS_ASSETS.iterdir() if f.is_file() and not f.name.startswith(".")}
        for name in src_files:
            src, dst = PROGRESS_SRC_DIR / name, OUTPUT_PROGRESS_ASSETS / name
            if not dst.exists() or src.stat().st_mtime > dst.stat().st_mtime:
                shutil.copy2(src, dst)
                copied += 1
        for name in dst_files - src_files:
            (OUTPUT_PROGRESS_ASSETS / name).unlink()

    # Balady+ 에셋 동기화: balady_plus/ → docs/progress/assets/balady/
    balady_dst = OUTPUT_PROGRESS_ASSETS / "balady"
    if BALADY_SRC_DIR.exists():
        import shutil
        balady_dst.mkdir(parents=True, exist_ok=True)
        b_src = {f.name for f in BALADY_SRC_DIR.iterdir() if f.is_file() and not f.name.startswith(".")}
        b_dst = {f.name for f in balady_dst.iterdir() if f.is_file() and not f.name.startswith(".")}
        for name in b_src:
            src, dst = BALADY_SRC_DIR / name, balady_dst / name
            if not dst.exists() or src.stat().st_mtime > dst.stat().st_mtime:
                shutil.copy2(src, dst)
                copied += 1
        for name in b_dst - b_src:
            (balady_dst / name).unlink()

    # Reference 카드 3D 버튼용: 랜드마크별 대표 모델(첫 glb)
    rep_models = {}
    for lid, g in groups.items():
        if g["models"]:
            rep_models[lid] = g["models"][0]

    print(f"✓ {(OUTPUT_PROGRESS_DIR / 'index.html').relative_to(ROOT)} ({len(sorted_ids)} landmarks + Balady+ {len(balady_cat)}, +{copied} assets, {len(rep_models)} 3D models)")
    return {"dates": {lid: "" for lid in groups}, "rep_models": rep_models}


def build():
    global PROGRESS_LATEST, PROGRESS_REP_MODELS
    landmarks = json.loads((DATA_DIR / "landmarks.json").read_text(encoding="utf-8"))
    glossary = json.loads((DATA_DIR / "glossary.json").read_text(encoding="utf-8"))
    template = (TEMPLATE_DIR / "index.html.tpl").read_text(encoding="utf-8")

    # Files 페이지 먼저 빌드 → Reference 카드 3D 버튼용 맵 확보
    palette = extract_palette(template)
    prog = build_files(landmarks, palette)
    PROGRESS_LATEST = prog["dates"]
    PROGRESS_REP_MODELS = prog["rep_models"]

    # 정렬: tier 1 → 2 → 3, 같은 tier 내에서는 idx 순서
    landmarks_sorted = sorted(landmarks, key=lambda x: (x["tier"], x["idx"]))

    # Tier별로 그룹 헤더 삽입 (cards-grid 안에서 grid-column: 1/-1 span)
    parts = []
    current_tier = None
    for lm in landmarks_sorted:
        if lm["tier"] != current_tier:
            current_tier = lm["tier"]
            count = sum(1 for x in landmarks_sorted if x["tier"] == current_tier)
            parts.append(
                f'<div class="tier-header" data-tier="tier-{current_tier}">'
                f'<span class="tier-header-mark tier-{current_tier}"></span>'
                f'<span class="tier-header-label">{TIER_LABEL[current_tier]}</span>'
                f'<span class="tier-header-sub">· {TIER_SUBTITLE[current_tier]}</span>'
                f'<span class="tier-header-count">{count} items</span>'
                f"</div>"
            )
        parts.append(render_card(lm))
    cards_html = "\n".join(parts)
    sidebar_html = "\n".join(render_sidebar_item(lm) for lm in landmarks_sorted)
    glossary_html = render_glossary(glossary)

    total = len(landmarks)
    t1 = sum(1 for l in landmarks if l["tier"] == 1)
    t2 = sum(1 for l in landmarks if l["tier"] == 2)
    t3 = sum(1 for l in landmarks if l["tier"] == 3)
    cities = len({l["city"] for l in landmarks})

    # 카드 본문에서 호버 툴팁용 - 카테고리 평탄화
    flat_terms = [
        {"kr": t["kr"], "en": t["en"], "desc": t["desc"]}
        for cat in glossary
        for t in cat["terms"]
    ]
    glossary_json = json.dumps(flat_terms, ensure_ascii=False).replace("</", "<\\/")

    output = template
    replacements = {
        "{{CARDS}}": cards_html,
        "{{SIDEBAR}}": sidebar_html,
        "{{GLOSSARY}}": glossary_html,
        "{{GLOSSARY_JSON}}": glossary_json,
        "{{MODEL_MODAL}}": MODEL_MODAL.replace("{{ASSET_BASE}}", "progress/assets/").replace("{{DL_BTN}}", MODAL_DL_BTN),
        "{{TOTAL}}": str(total),
        "{{T1}}": str(t1),
        "{{T2}}": str(t2),
        "{{T3}}": str(t3),
        "{{CITIES}}": str(cities),
    }
    for k, v in replacements.items():
        output = output.replace(k, v)

    OUTPUT_DIR.mkdir(exist_ok=True)
    OUTPUT.write_text(output, encoding="utf-8")

    # 검색엔진 색인 차단 — robots.txt
    (OUTPUT_DIR / "robots.txt").write_text("User-agent: *\nDisallow: /\n", encoding="utf-8")

    # 방법론 PDF 동기화: 자료수집_방법론.pdf → docs/methodology.pdf
    import shutil as _sh
    _pdf = ROOT / "자료수집_방법론.pdf"
    if _pdf.exists():
        _sh.copy2(_pdf, OUTPUT_DIR / "methodology.pdf")

    # 이미지 동기화: images/ → docs/images/
    OUTPUT_IMG_DIR.mkdir(exist_ok=True)
    if IMG_DIR.exists():
        import shutil
        src_files = {f.name for f in IMG_DIR.iterdir() if f.is_file() and not f.name.startswith(".")}
        dst_files = {f.name for f in OUTPUT_IMG_DIR.iterdir() if f.is_file() and not f.name.startswith(".")}
        # 추가/변경: src에는 있지만 dst에 없거나 mtime 다른 것
        copied = 0
        for name in src_files:
            src = IMG_DIR / name
            dst = OUTPUT_IMG_DIR / name
            if not dst.exists() or src.stat().st_mtime > dst.stat().st_mtime:
                shutil.copy2(src, dst)
                copied += 1
        # 삭제: dst에 있는데 src에서 없어진 것
        removed = 0
        for name in dst_files - src_files:
            (OUTPUT_IMG_DIR / name).unlink()
            removed += 1

    # 빈 이미지 카운트
    no_img = sum(1 for l in landmarks if not l["image"].get("local_path") and not l["image"].get("url") and not l["image"].get("fallback"))

    print(f"✓ {OUTPUT.relative_to(ROOT)} ({len(output):,} chars)")
    print(f"  landmarks: {total} (T1: {t1} / T2: {t2} / T3: {t3})")
    print(f"  glossary:  {sum(len(g['terms']) for g in glossary)} terms in {len(glossary)} categories")
    if IMG_DIR.exists():
        print(f"  images sync: +{copied} copied, -{removed} removed → {OUTPUT_IMG_DIR.relative_to(ROOT)}/")
    if no_img:
        print(f"  ⚠ 이미지 없는 카드: {no_img}개")


def watch():
    """간단한 파일 변경 감지 — data/와 templates/ 폴더 mtime 폴링"""
    print("👀 watch mode — Ctrl+C로 종료\n")
    last_mtimes = {}

    def collect_mtimes():
        files = list(DATA_DIR.glob("*.json")) + list(TEMPLATE_DIR.glob("*"))
        return {f: f.stat().st_mtime for f in files if f.is_file()}

    build()
    last_mtimes = collect_mtimes()

    try:
        while True:
            time.sleep(0.5)
            current = collect_mtimes()
            if current != last_mtimes:
                changed = [f.name for f, m in current.items() if last_mtimes.get(f) != m]
                print(f"\n🔄 변경 감지: {', '.join(changed)}")
                try:
                    build()
                except Exception as e:
                    print(f"  ✗ 빌드 실패: {e}")
                last_mtimes = current
    except KeyboardInterrupt:
        print("\n👋 종료")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--watch", action="store_true")
    args = parser.parse_args()
    if args.watch:
        watch()
    else:
        build()
