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
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
TEMPLATE_DIR = ROOT / "templates"
IMG_DIR = ROOT / "images"
# 빌드 결과는 docs/ 에 — GitHub Pages 호스팅 디렉토리
OUTPUT_DIR = ROOT / "docs"
OUTPUT = OUTPUT_DIR / "index.html"
OUTPUT_IMG_DIR = OUTPUT_DIR / "images"


def esc(text: str) -> str:
    return htmllib.escape(text or "")


# Tier 색상 매핑
TIER_COLOR = {1: "#c89638", 2: "#7a9e7e", 3: "#7a8ea0"}
TIER_LABEL = {1: "Tier 1", 2: "Tier 2", 3: "Tier 3"}
TIER_SUBTITLE = {1: "핵심", 2: "주요", 3: "추가"}

# Spec sheet 핵심 5라벨 (모든 카드에 동일 순서로 노출)
CORE_STRUCT_LABELS = ["형태", "규모", "재료", "시대", "설계"]


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

    # Modeling Notes (기술 팁 — 분리)
    mn_items = lm.get("modeling_notes", [])
    modeling_notes_html = ""
    if mn_items:
        mn_rows = []
        for note in mn_items:
            primary, aux = _split_paren_aux(note)
            mn_rows.append(_hl_item(primary, aux))
        modeling_notes_html = (
            '<section class="card-section card-section--modeling-notes">'
            '<h4 class="section-eyebrow">Modeling Notes</h4>'
            f'<div class="hairline-list">{"".join(mn_rows)}</div>'
            '</section>'
        )

    # Tags
    tag_html = " ".join(f'<span class="tag">{esc(t)}</span>' for t in lm["tags"])
    remarks_html = " ".join(f'<span class="tag tag-alert">{esc(r)}</span>' for r in lm["remarks"])

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

    # 카드 헤더의 status, task_type 뱃지
    status = modeling.get("status")
    task_type = modeling.get("task_type")
    status_html = ""
    if status:
        status_cls = {
            "완공": "tag-status-done",
            "건설 중": "tag-status-wip",
            "계획": "tag-status-plan",
        }.get(status, "tag-status-done")
        status_html = f'<span class="tag tag-status {status_cls}">{esc(status)}</span>'
    task_html = ""
    if task_type:
        task_cls = "tag-task-new" if task_type == "신규제작" else "tag-task-edit"
        task_html = f'<span class="tag tag-task {task_cls}">{esc(task_type)}</span>'

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
    ])

    return f"""
<article class="card" id="card-{idx_str}"
         data-tier="tier-{tier}"
         data-city="city-{city.upper().replace(' ', '-')}"
         data-type="type-{type_}"
         data-search="{esc(search_str)}">
  <div class="card-image{no_image_class}">
    {img_html}
    <div class="card-image-meta">
      <span class="card-num">№ {idx_str}</span>
      <div class="card-image-meta-right">
        {confidence_html}
        <span class="card-tier-pill" style="--pill-color: {TIER_COLOR[tier]}">T{tier}</span>
      </div>
    </div>
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
      <div class="card-tags">{status_html}{task_html}{tag_html}{remarks_html}{draft_html}</div>
    </header>

    {must_have_html}

    {key_points_html}

    <section class="card-section card-section--structure">
      <h4 class="section-eyebrow">Structure</h4>
      <dl class="hairline-list hairline-list--kv">{struct_rows}</dl>
    </section>

    {part_heights_html}

    {modeling_notes_html}

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
        f'<span class="nav-tier" style="background: {TIER_COLOR[lm["tier"]]}"></span>'
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


def build():
    landmarks = json.loads((DATA_DIR / "landmarks.json").read_text(encoding="utf-8"))
    glossary = json.loads((DATA_DIR / "glossary.json").read_text(encoding="utf-8"))
    template = (TEMPLATE_DIR / "index.html.tpl").read_text(encoding="utf-8")

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
                f'<span class="tier-header-mark" style="background:{TIER_COLOR[current_tier]}"></span>'
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
