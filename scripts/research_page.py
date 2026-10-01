"""Render landmark research by city, independently of review status."""
import html
import json
from pathlib import Path
from urllib.parse import urlsplit, urlencode

REVIEW_STATES = {"검토 중": "review", "선정": "selected", "제외": "excluded"}
PRIORITIES = {"추천": 1, "검토": 2, "보류": 3}
LANDMARK_TYPES = {
    "tower": ("Tower", "타워"),
    "mosque": ("Mosque", "모스크"),
    "heritage": ("Heritage", "역사 건축물"),
    "infra": ("Infra", "기반 시설"),
    "government": ("Government", "관공서"),
    "complex": ("Complex", "복합 단지"),
    "event-venue": ("Event Venue", "행사 시설"),
    "sculpture": ("Sculpture", "조형물"),
}
CITIES = (
    ("riyadh", "Riyadh", "King Fahd Road 주변 랜드마크 건축물"),
    ("jeddah", "Jeddah", "랜드마크 건축물 · 조형물"),
)


def esc(value):
    return html.escape(str(value), quote=True)


def source_label(url):
    host = urlsplit(url).hostname or "출처"
    labels = {
        "www.skyscrapercenter.com": "Skyscraper Center",
        "saudipedia.com": "Saudipedia",
        "rsp.design": "RSP · 설계사",
        "motoon.com.sa": "Motoon · 운영사",
        "www.hilton.com": "Hilton · 호텔 공식",
        "www.csbe.org": "CSBE · 건축 연구",
        "s3.eu-central-2.wasabisys.com": "Alkhabeer · 자산평가 보고서",
        "www.alkhabeer.com": "Alkhabeer · 공식 자료",
    }
    return labels.get(host, host.removeprefix("www."))


def link(url, label, class_name=""):
    if urlsplit(url).scheme not in {"https", "http"}:
        raise ValueError(f"Unsupported research URL: {url}")
    return (f'<a class="{class_name}" href="{esc(url)}" target="_blank" '
            f'rel="noopener noreferrer">{esc(label)} <span aria-hidden="true">↗</span></a>')


def load_candidates(root):
    folder = root / "research"
    map_records = json.loads((folder / "map-links.json").read_text(encoding="utf-8"))["candidates"]
    riyadh = json.loads((folder / "phase1-king-fahd-road/candidates.json").read_text(encoding="utf-8"))
    jeddah = json.loads((folder / "phase1-jeddah/candidates.json").read_text(encoding="utf-8"))
    image_file = folder / "phase1-king-fahd-road/images.json"
    images = json.loads(image_file.read_text(encoding="utf-8"))["candidates"] if image_file.exists() else {}
    jeddah_image_file = folder / "phase1-jeddah/images.json"
    jeddah_images = json.loads(jeddah_image_file.read_text(encoding="utf-8"))["candidates"] if jeddah_image_file.exists() else {}
    candidates = []
    for item in riyadh["candidates"]:
        candidates.append({**item, "images": images.get(item["id"], []), "city": "Riyadh", "city_key": "riyadh",
                           "phase_key": "extended" if item["scope_group"] == "권역 확장" else "phase-1",
                           "tag": item["road_relationship"], "kind": "building",
                           "sources": [(source_label(url), url) for url in item["sources"]]})
    for item in jeddah["candidates"]:
        candidates.append({**item, "images": jeddah_images.get(item["id"], []), "city_key": "jeddah", "phase_key": "phase-1", "tag": item["type"],
                           "kind": {"건축물": "building", "조형물": "sculpture"}[item["type"]],
                           "review_status": "검토 중" if item["review_status"] == "선정 전" else item["review_status"],
                           # Same recommendation scale, unified wording for the website; not a Tier assignment.
                           "selection_suggestion": {"높음": "추천", "보통": "검토", "낮음": "보류"}[item["visual_recommendation"]],
                           "visual_character": item["character"], "verification_notes": item["followup"],
                           "sources": [(s["title"], s["url"]) for s in item["sources"]]})
    if len({c["id"] for c in candidates}) != len(candidates):
        raise ValueError("Duplicate Research IDs")
    if set(map_records) != {c["id"] for c in candidates}:
        raise ValueError("Research map audit IDs must match the candidate list")
    for item in candidates:
        REVIEW_STATES[item["review_status"]]
        LANDMARK_TYPES[item["landmark_type"]]
        record = map_records[item["id"]]
        if record["status"] not in {"matched", "coordinate_matched", "unresolved"}:
            raise ValueError(f"Unknown map audit status: {item['id']}")
        if record["status"] == "matched":
            cid = str(record.get("cid", ""))
            if not cid.isdecimal() or record.get("url") != f"https://www.google.com/maps?cid={cid}":
                raise ValueError(f"Invalid audited place link: {item['id']}")
        if record["status"] == "coordinate_matched":
            lat, lon = record["coordinate_strings"]
            if not (16 <= float(lat) <= 33 and 34 <= float(lon) <= 56):
                raise ValueError(f"Coordinate outside Saudi Arabia: {item['id']}")
            expected = "https://www.google.com/maps/search?" + urlencode({"api": 1, "query": f"{lat},{lon}"})
            if record["url"].replace("/search/?", "/search?") != expected:
                raise ValueError(f"Invalid coordinate map link: {item['id']}")
        item["map_record"] = record
    # N08 was excluded before web admission. Do not import the preliminary exclusion file.
    checked_date = max(riyadh["fact_check_date"], *(c["fact_check"]["date"] for c in candidates),
                       *(c["catalogue_location"]["checked_at"] for c in candidates if c.get("catalogue_location")))
    return sorted(candidates, key=lambda c: (PRIORITIES[c["selection_suggestion"]], c["id"])), checked_date


def render_image_gallery(images):
    figures = []
    for photo in images:
        if photo.get("thumbnail_only"):
            continue
        source_text = link(photo['source_url'], photo['source']) if photo.get('source_url') else esc(photo['source'])
        license_text = (link(photo["license_url"], photo["license"]) if photo.get("license_url")
                        else esc(photo["license"]))
        figures.append(f'''<figure class="research-photo">
          <button class="photo-original" type="button" aria-haspopup="dialog" aria-controls="research-lightbox" aria-label="{esc(photo['alt'])} 크게 보기">
            <img src="../images/{esc(photo['file'])}" alt="{esc(photo['alt'])}" width="{photo['width']}" height="{photo['height']}" loading="lazy" decoding="async"></button>
          <figcaption><p>{esc(photo['caption'])}</p>
            <p class="photo-credit">{source_text} · {esc(photo['kind'])}<br>
              촬영·제작: {esc(photo['photographer'] or '미확인')} · 시점: {esc(photo['date_note'])}<br>
              사용 조건: {license_text} · {esc(photo['processing'])}</p></figcaption></figure>''')
    return '<h5>외형 이미지</h5><div class="photo-gallery">' + "".join(figures) + '</div>' if figures else ''


def render_card(item):
    map_record = item["map_record"]
    catalogue_location = item.get("catalogue_location")
    place_verified = map_record["status"] == "matched"
    coordinate_verified = map_record["status"] == "coordinate_matched"
    map_url = map_record["url"] if place_verified or coordinate_verified else item["map_search_url"]
    map_label = "지도 (좌표)" if coordinate_verified else "지도" if place_verified else "지도 검색"
    # Catalogue Location is a named area, not a verified sculpture pin. Keep the
    # place audit intact; the user's catalogue view deliberately uses area search.
    if catalogue_location:
        map_url = 'https://www.google.com/maps/search/?' + urlencode({
            'api': 1, 'query': catalogue_location['map_query']
        })
        map_label = '지도 검색'
    suppress_map = (not catalogue_location.get('map_search_available', True) if catalogue_location
                    else map_record.get('suppress_search', False))
    map_control = ('<span class="map-unavailable">위치 미확인</span>'
                   if suppress_map else link(map_url, map_label, 'map-link'))
    area_text = f'사이트 기재 위치 · {item["area"]}' if catalogue_location else item["area"]
    location_detail = (f'<section class="location-record"><h5>위치 기록</h5>'
                       f'<p>{esc(catalogue_location["note"])}</p></section>' if catalogue_location else '')
    image_search_url = 'https://www.google.com/search?' + urlencode({
        'tbm': 'isch', 'q': item.get("image_search_name", item["name"])
    })
    state = REVIEW_STATES[item["review_status"]]
    check = item["fact_check"]
    type_label, type_description = LANDMARK_TYPES[item["landmark_type"]]
    search = " ".join(str(item.get(k, "")) for k in (
        "id", "name", "city", "area", "scope_group", "tag", "visual_character", "verification_notes", "selection_suggestion"
    )) + f" {type_label} {type_description}" + (" 리야드" if item["city_key"] == "riyadh" else " 제다")
    low = '<span class="badge low" title="정확한 모델링을 위한 자료 부족">DATA LOW</span>' if item["confidence"] == "low" else ""
    status = f'<span class="badge {state}">{esc(item["review_status"])}</span>' if state != "review" else ""
    decision_note = (f'<p class="decision-note"><span>선정 전 확인</span>{esc(item["decision_note"])}</p>'
                     if item.get("decision_note") else "")
    title_tag = "h4" if item["phase_key"] == "extended" else "h3"
    rank = PRIORITIES[item["selection_suggestion"]]
    assessment = item.get("recommendation_assessment", {})
    tip_reason = assessment.get("reason", "")
    if tip_reason.startswith(("기존 조사에서", "기존 형태 검토", "대상 대응 또는")) or not tip_reason:
        tip_reason = item.get("recommendation_review", {}).get("reason") or check["remaining"]
    type_badge = f'<span class="type-badge" aria-label="Type: {esc(type_label)}" title="{esc(type_description)}">{esc(type_label)}</span>'
    relationship_tag = (f'<span>{esc(item["tag"])}</span>'
                        if item["city_key"] == "riyadh" and item["phase_key"] != "extended" else "")
    tag = f'<div class="card-tags">{type_badge}{relationship_tag}</div>'
    sources = "".join(f'<li>{link(url, label)}</li>' for label, url in item["sources"])
    reason = f'<h5>제외 사유</h5><p>{esc(item.get("exclusion_reason", "사용자 제외 결정"))}</p>' if state == "excluded" else ""
    overview = f'<section class="landmark-intro"><h5>랜드마크 소개</h5><p>{esc(item["overview"])}</p></section>'
    relations = [("연결 건물", item["connected_building"])] if item.get("connected_building") else []
    relations += [("인접 건물", entry) for entry in item.get("adjacent_buildings", [])]
    relation_links = [f'<button type="button" class="connected-building" data-related-card="{esc(entry["id"])}" aria-haspopup="dialog" aria-controls="research-detail-panel">{kind} · {esc(entry["label"])} <span aria-hidden="true">→</span></button>' for kind, entry in relations]
    related_link = "".join(relation_links)
    relation_notes = "".join(f'<p>{esc(note)}</p>' for note in item.get("relation_notes", []))
    relation_detail = ('<section class="building-relation"><h5>인접·연결 관계</h5>' + "".join(f'<p>{esc(entry["description"])}</p>{control}' for (_, entry), control in zip(relations, relation_links)) + relation_notes + '</section>') if relations or relation_notes else ''
    appearance = f'<h5>외관 특징</h5><p>{esc(item.get("appearance_description", item["visual_character"]))}</p>'
    if check.get('checked_scope') == 'appearance':
        appearance += f'<p class="appearance-evidence">확인 근거: {esc(check["checked"])}</p>'
        checked = ''
    else:
        checked = f'<h5>조사 요약</h5><p>{esc(check["checked"])}</p>'
    images = item.get("images", [])
    if images:
        photo = images[0]
        visual = f'''<button class="photo-open" type="button" aria-label="{esc(item['name'])} 사진과 상세 정보 보기">
          <img src="../images/{esc(photo['file'])}" alt="{esc(photo['alt'])}" width="{photo['width']}" height="{photo['height']}" style="object-position:{esc(photo.get('thumbnail_position', '50% 50%'))}" loading="lazy" decoding="async"></button>'''
        if photo['kind'] != '외관 사진':
            visual += f'<span class="photo-kind">{esc(photo["kind"])}</span>'
    else:
        visual = f'''<div class="placeholder-art" role="img" aria-label="{esc(item['name'])} 외관 사진 준비 중"><svg aria-hidden="true" viewBox="0 0 80 64"><rect x="9" y="9" width="62" height="46" rx="4"/><circle cx="29" cy="25" r="5"/><path d="m12 48 17-14 12 9 12-18 16 23"/></svg></div>
        <span class="placeholder-caption">외관 사진 준비 중 <small>PHOTO PENDING</small></span>'''
    return f'''<article class="research-card" id="{esc(item['id'])}" data-status="{state}"
      data-kind="{item['kind']}" data-type="{esc(item['landmark_type'])}" data-priority="{rank}" data-search="{esc(search.casefold())}" aria-labelledby="title-{esc(item['id'])}">
      <div class="card-visual">
        <div class="card-meta"><div class="badges">
          {status}{low}</div></div>
        {visual}
      </div>
      <div class="card-body"><div class="card-heading"><{title_tag} id="title-{esc(item['id'])}">{esc(item['name'])}</{title_tag}>
        <button type="button" class="badge recommendation priority-{rank}" data-recommendation-reason="{esc(tip_reason)}" aria-label="추천 등급: {esc(item['selection_suggestion'])}">{esc(item['selection_suggestion'])}</button></div>
        <p class="area">{esc(area_text)}</p>
        {related_link}
        {tag}
        <p class="character">{esc(item['visual_character'])}</p>
        {decision_note}
        <div class="card-actions"><details><summary>상세 정보 <svg class="chevron" aria-hidden="true" viewBox="0 0 16 16"><path d="m4 6 4 4 4-4"/></svg></summary>
          <div class="detail-body">{overview}{location_detail}{reason}{relation_detail}{appearance}{checked}
            <h5>미확인 사항</h5><p>{esc(check['remaining'])}</p>
            <h5>검토 메모</h5><p>{esc(item['verification_notes'])}</p>
            <h5>출처</h5><ul class="sources">{sources}</ul>{render_image_gallery(images)}</div>
        </details><div class="card-external-links">{map_control}{link(image_search_url, 'Google 이미지', 'image-search-link')}</div></div>
      </div>
    </article>'''


def build_research(root: Path, output_dir: Path, palette: str):
    candidates, date = load_candidates(root)
    counts = {key: sum(REVIEW_STATES[c["review_status"]] == key for c in candidates) for key in REVIEW_STATES.values()}
    overview, sections = [], []
    for city_key, city, description in CITIES:
        section_id = city_key
        items = [c for c in candidates if c["city_key"] == city_key]
        type_stats = "".join(
            f'<div class="stat"><span class="stat-label">{label}</span><span class="stat-num" data-count-for="{section_id}" data-count-kind="{kind}">{sum(c["kind"] == kind for c in items)}</span></div>'
            for kind, label in (("building", "건축물"), ("sculpture", "조형물"))
            if city_key != "riyadh" or kind == "building"
        )
        overview.append(f'<div class="city-overview"><a class="jump-link city-jump" href="#{section_id}">{city}</a><div class="hero-stats">{type_stats}</div></div>')
        core = [c for c in items if c["phase_key"] != "extended"]
        extended = [c for c in items if c["phase_key"] == "extended"]
        cards = "\n".join(render_card(c) for c in core)
        extended_section = ""
        if extended:
            extended_cards = "\n".join(render_card(c) for c in extended)
            extended_section = f'''<section class="scope-section" id="extended" aria-labelledby="heading-extended">
              <header class="scope-head"><h3 id="heading-extended">권역 확장 <span class="scope-count">{len(extended)}</span></h3><span>구도심·Al Nakheel 등 Riyadh 내 다른 지역까지 조사 범위 확대</span></header>
              <div class="cards-grid">{extended_cards}</div></section>'''
        empty = " hidden" if items else ""
        sections.append(f'''<section class="city-section" id="{section_id}" aria-labelledby="heading-{section_id}">
          <header class="section-head"><div class="section-title"><h2 id="heading-{section_id}">{city}<span class="section-count" aria-live="polite">{len(items)}</span></h2><p>{description}</p></div>
            <div class="section-controls"><div class="status-control"><select class="status-filter" aria-label="{city} 선정 상태">
              <option value="review">상태: 검토 중</option><option value="selected">상태: 선정</option><option value="excluded">상태: 제외</option>
            </select><svg class="chevron" aria-hidden="true" viewBox="0 0 16 16"><path d="m4 6 4 4 4-4"/></svg></div>
            <div class="display-help"><button type="button" class="help-trigger" aria-label="{city} 표시 기준" aria-describedby="help-{section_id}"><svg aria-hidden="true" viewBox="0 0 20 20"><circle cx="10" cy="10" r="7.5"/><path d="M10 9v5"/><circle class="info-dot" cx="10" cy="6" r=".8"/></svg></button>
              <p class="help-tooltip" id="help-{section_id}" role="tooltip" hidden>사진의 출처·시점은 상세 정보에서 확인할 수 있습니다. 미확보 이미지는 준비 중으로 표시합니다. 건수는 검색어와 해당 도시의 선정 상태 필터를 반영합니다. 카드는 추천 → 검토 → 보류 순으로 표시하며, 추천 등급은 기존 조건·모델링 리소스·캐릭터성을 함께 평가한 의견입니다. 추천은 우선 후보, 검토는 조건이나 자료 보완이 필요한 후보, 보류는 판단 근거가 부족한 후보입니다. 최종 선정과는 구분합니다.</p>
            </div></div></header>
          <div class="cards-grid">{cards}</div>{extended_section}<p class="section-empty" aria-live="polite"{empty}>아직 등록된 조사 항목이 없습니다.</p></section>''')
    replacements = {
        "{{PALETTE}}": palette, "{{TOTAL}}": str(len(candidates)),
        "{{REVIEW_COUNT}}": str(counts["review"]), "{{SELECTED_COUNT}}": str(counts["selected"]),
        "{{EXCLUDED_COUNT}}": str(counts["excluded"]), "{{CHECK_DATE}}": esc(date),
        "{{OVERVIEW}}": "\n".join(overview), "{{SECTIONS}}": "\n".join(sections),
    }
    page = (root / "templates/research.html.tpl").read_text(encoding="utf-8")
    for token, value in replacements.items():
        page = page.replace(token, value)
    target = output_dir / "research/index.html"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(page, encoding="utf-8")
    print(f"✓ {target.relative_to(root)} ({len(candidates)} research cards)")
