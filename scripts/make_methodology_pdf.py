#!/usr/bin/env python3
"""KSA Landmarks 자료 수집 방법론 PDF 생성 (한국어, reportlab CID 폰트)."""
import json
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT, TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak,
    HRFlowable,
)

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "자료수집_방법론.pdf"

# ── 한국어 폰트 임베드 (시스템 AppleGothic TTF) ──
_KFONT = "/System/Library/Fonts/Supplemental/AppleGothic.ttf"
pdfmetrics.registerFont(TTFont("KR", _KFONT))
pdfmetrics.registerFontFamily("KR", normal="KR", bold="KR", italic="KR", boldItalic="KR")
KR = "KR"
KRB = "KR"  # 단일 웨이트 — 위계는 크기·색상으로 구분

# ── 색 ──
ACCENT = colors.HexColor("#2c5588")
TEAL = colors.HexColor("#3a8a78")
SLATE = colors.HexColor("#8696a8")
INK = colors.HexColor("#0e131b")
MUTE = colors.HexColor("#5a6573")
LINE = colors.HexColor("#d8dee6")
SOFT = colors.HexColor("#eef1f5")
VERIFIED = colors.HexColor("#2c5588")
PARTIAL = colors.HexColor("#b07b2e")
LOW = colors.HexColor("#8a6878")

# ── 스타일 ──
styles = getSampleStyleSheet()
def S(name, **kw):
    return ParagraphStyle(name, **kw)

title_st = S("t", fontName=KRB, fontSize=24, textColor=INK, leading=30, spaceAfter=6)
subtitle_st = S("st", fontName=KR, fontSize=11, textColor=MUTE, leading=16)
eyebrow_st = S("eb", fontName=KRB, fontSize=9, textColor=ACCENT, leading=12, spaceAfter=3)
h1_st = S("h1", fontName=KRB, fontSize=15, textColor=INK, leading=20, spaceBefore=16, spaceAfter=6)
h2_st = S("h2", fontName=KRB, fontSize=11.5, textColor=ACCENT, leading=16, spaceBefore=10, spaceAfter=3)
body_st = S("b", fontName=KR, fontSize=9.7, textColor=INK, leading=15, spaceAfter=4)
small_st = S("sm", fontName=KR, fontSize=8.3, textColor=MUTE, leading=12)
cell_st = S("c", fontName=KR, fontSize=7.6, textColor=INK, leading=10)
cellc_st = S("cc", fontName=KR, fontSize=7.6, textColor=INK, leading=10, alignment=TA_CENTER)
cellh_st = S("ch", fontName=KRB, fontSize=7.8, textColor=colors.white, leading=10, alignment=TA_CENTER)
bullet_st = S("bl", fontName=KR, fontSize=9.5, textColor=INK, leading=14, leftIndent=10, spaceAfter=2)


def bullet(text):
    return Paragraph(f"•&nbsp;&nbsp;{text}", bullet_st)


def hr():
    return HRFlowable(width="100%", thickness=0.6, color=LINE, spaceBefore=4, spaceAfter=8)


story = []

# ════════ 표지 ════════
story.append(Spacer(1, 30))
story.append(Paragraph("DATA COLLECTION METHODOLOGY", eyebrow_st))
story.append(Paragraph("KSA Landmarks 자료 수집 방법론", title_st))
story.append(Spacer(1, 4))
story.append(Paragraph(
    "사우디아라비아 랜드마크 40곳의 3D 모델링 레퍼런스를 구축하기 위해<br/>"
    "각 항목의 자료를 어떤 기준으로, 어떤 출처에서, 어떻게 수집·검증했는지 정리한 문서입니다.",
    subtitle_st))
story.append(Spacer(1, 10))
story.append(hr())
# 요약 박스
summary = [
    [Paragraph("대상", cellh_st), Paragraph("40개 랜드마크 · 6개 도시 (Riyadh·Jeddah·Al Khobar·Dammam·Makkah·AlUla)", cell_st)],
    [Paragraph("분류", cellh_st), Paragraph("Tier 1(핵심) 10 · Tier 2(주요) 25 · Tier 3(추가) 5", cell_st)],
    [Paragraph("신뢰도", cellh_st), Paragraph("Verified 8 · Partial 9 · Low 23 (3단계 분류)", cell_st)],
    [Paragraph("핵심 원칙", cellh_st), Paragraph("권위 출처 우선 · 미검증 항목은 추정으로 표시 · 자료 부족분 투명 공개(DATA LOW)", cell_st)],
]
t = Table(summary, colWidths=[60, 420])
t.setStyle(TableStyle([
    ("BACKGROUND", (0, 0), (0, -1), ACCENT),
    ("BACKGROUND", (1, 0), (1, -1), SOFT),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 8),
    ("RIGHTPADDING", (0, 0), (-1, -1), 8),
    ("TOPPADDING", (0, 0), (-1, -1), 6),
    ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
    ("LINEBELOW", (0, 0), (-1, -2), 0.5, colors.white),
    ("GRID", (0, 0), (-1, -1), 0, colors.white),
]))
story.append(t)
story.append(Spacer(1, 14))

# ════════ 1. 자료 출처 위계 ════════
story.append(Paragraph("1.  자료 출처 위계 (Source Hierarchy)", h1_st))
story.append(Paragraph(
    "자료는 신뢰도가 높은 출처를 우선했습니다. 위쪽일수록 권위가 높고, 상충 시 상위 출처를 따랐습니다.",
    body_st))
src_rows = [
    [Paragraph("등급", cellh_st), Paragraph("출처", cellh_st), Paragraph("용도", cellh_st)],
    [Paragraph("① 학술·기록", cell_st), Paragraph("CTBUH / Skyscraper Center, UNESCO, 학술 인용(Geoffrey King 등)", cell_st), Paragraph("타워 높이·층수, 헤리티지 건물 치수", cell_st)],
    [Paragraph("② 공식", cell_st), Paragraph("Saudipedia, 정부·기관 공식 사이트, 설계사 페이지(Populous·ZHA·Gerber·Benoy 등)", cell_st), Paragraph("설계자·연도·면적·디자인 의도", cell_st)],
    [Paragraph("③ 백과·전문", cell_st), Paragraph("Wikipedia(인용 포함), StadiumDB, ArchDaily, Archello", cell_str := cell_st), Paragraph("일반 정보·경기장 스펙·외관", cell_st)],
    [Paragraph("④ 보도", cell_st), Paragraph("Arab News 등 검증된 언론", cell_st), Paragraph("개관 사실·이벤트(준공 등)", cell_st)],
    [Paragraph("⑤ 위치·측정", cell_st), Paragraph("Google Maps 핀(클라이언트 xlsx), OpenStreetMap, Google Earth", cell_st), Paragraph("좌표·footprint·실측 추정", cell_st)],
]
t = Table(src_rows, colWidths=[60, 250, 170])
t.setStyle(TableStyle([
    ("BACKGROUND", (0, 0), (-1, 0), ACCENT),
    ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, SOFT]),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 6), ("RIGHTPADDING", (0, 0), (-1, -1), 6),
    ("TOPPADDING", (0, 0), (-1, -1), 5), ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
    ("LINEBELOW", (0, 0), (-1, -1), 0.4, LINE),
]))
story.append(t)

# ════════ 2. 신뢰도 분류 기준 ════════
story.append(Paragraph("2.  신뢰도 3단계 분류 기준", h1_st))
story.append(Paragraph(
    "각 랜드마크를 자료 신뢰도에 따라 3등급으로 분류하고, 사이트에 표시했습니다. "
    "이는 모델링 정확도의 위험을 투명하게 드러내기 위한 것입니다.", body_st))
conf_rows = [
    [Paragraph("등급", cellh_st), Paragraph("기준", cellh_st), Paragraph("화면 표시", cellh_st), Paragraph("수", cellh_st)],
    [Paragraph("Verified", S("v", fontName=KRB, fontSize=7.8, textColor=VERIFIED, alignment=TA_CENTER, leading=10)),
     Paragraph("설계자·연도·면적·치수 등 핵심 사실을 권위 출처(CTBUH·Wikipedia·Saudipedia 등)로 교차 검증", cell_st),
     Paragraph("없음", cellc_st), Paragraph("8", cellc_st)],
    [Paragraph("Partial", S("p", fontName=KRB, fontSize=7.8, textColor=PARTIAL, alignment=TA_CENTER, leading=10)),
     Paragraph("건물 식별·일반 정보는 확인되나, 정확한 구조 치수(높이·외경 등)는 비공개 → 추정", cell_st),
     Paragraph("없음", cellc_st), Paragraph("9", cellc_st)],
    [Paragraph("Low", S("l", fontName=KRB, fontSize=7.8, textColor=LOW, alignment=TA_CENTER, leading=10)),
     Paragraph("공식 자료가 매우 부족. 위성·클라이언트 제공 자료 없이는 정확 모델링 어려움", cell_st),
     Paragraph("DATA LOW 뱃지", cellc_st), Paragraph("23", cellc_st)],
]
t = Table(conf_rows, colWidths=[60, 290, 90, 40])
t.setStyle(TableStyle([
    ("BACKGROUND", (0, 0), (-1, 0), ACCENT),
    ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, SOFT]),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 6), ("RIGHTPADDING", (0, 0), (-1, -1), 6),
    ("TOPPADDING", (0, 0), (-1, -1), 5), ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
    ("LINEBELOW", (0, 0), (-1, -1), 0.4, LINE),
]))
story.append(t)
story.append(Spacer(1, 6))
story.append(Paragraph(
    "<b>DATA LOW의 대표 유형:</b> ① 상업시설(몰)·지역 모스크 — 공식 치수 미공개 / "
    "② 건설 중(Aramco Stadium·Six Flags Qiddiya) — 도면 비공개 / "
    "③ 단지·캠퍼스·자연(공항·대학·골프장) — 개별 건물 특정 불가 / ④ 식별 모호(Savola Tower 등).",
    small_st))

# ════════ 3. 데이터 유형별 수집 방법 ════════
story.append(Paragraph("3.  데이터 유형별 수집 방법", h1_st))

story.append(Paragraph("3-1. 기본 정보 (이름·도시·유형·시대·설계자)", h2_st))
story.append(bullet("클라이언트 제공 원본 목록(xlsx)을 기준으로 이름·도시·Tier 확정"))
story.append(bullet("영문 표기는 공식 영문명으로 교차 확인 (예: King Fahad National Library의 'Fahad'는 기관 공식 표기, Nassif House로 철자 통일)"))
story.append(bullet("설계자·완공 연도는 Verified 등급에 한해 권위 출처로 명시, 그 외는 생략 또는 추정 표시"))

story.append(Paragraph("3-2. 좌표 (WGS84 / EPSG:4326)", h2_st))
story.append(bullet("클라이언트 xlsx에 포함된 Google Maps 단축 링크(maps.app.goo.gl)를 따라가 <b>실제 핀 좌표</b> 추출"))
story.append(bullet("링크 리다이렉트의 정밀 핀 파라미터(!3d!4d)를 우선 사용 — 지도 뷰 중심(@)보다 정확"))
story.append(bullet("40개 전부 사우디 영역 내 좌표로 검증, 소수점 7~8자리 보존 (사양서 '8자리 이상' 요건)"))

story.append(Paragraph("3-3. 치수·부분별 높이 (Part Heights)", h2_st))
story.append(bullet("권위 출처에 명시된 값만 채택 — 추정/창작 금지"))
story.append(bullet("타워급은 CTBUH·Skyscraper Center, 경기장은 StadiumDB, 토목(교량·분수)은 Wikipedia·Guinness 인용"))
story.append(bullet("부분 높이가 확보된 5개 항목만 'Part Heights' 노출 (예: Makkah Clock Royal Tower 601m·시계 43×43m 등)"))
story.append(bullet("자료 없는 항목은 빈칸 유지 — 임의 수치를 넣지 않음"))

story.append(Paragraph("3-4. 규모 분류·폴리곤 예산", h2_st))
story.append(bullet("실측 최장변 기준으로 소형(&lt;10m)·중형(10–50m)·대형(50–200m)·초대형(&gt;200m) 분류"))
story.append(bullet("사양서 한도표(3k/10k/20k/50k tris)를 분류에 매핑 — 단, 한도는 유동적이라 참고용으로만 표시(취소선)"))

story.append(Paragraph("3-5. 시공 상태·검증 보강", h2_st))
story.append(bullet("완공/건설 중 구분 — 건설 중 항목은 공식 렌더링·설계사 자료로 보강"))
story.append(bullet("Tier 1(핵심) 10개는 항목별 웹 리서치로 집중 검증, 발견된 오류 정정 (예: Kingdom Arena를 '원형 경기장'에서 '실내 아레나'로 수정)"))

# ════════ 4. 랜드마크별 출처·신뢰도 표 ════════
story.append(PageBreak())
story.append(Paragraph("4.  랜드마크별 자료 출처·신뢰도", h1_st))
story.append(Paragraph("40개 전 항목의 신뢰도 등급과 사용한 주요 출처. 좌표는 클라이언트 핀에서 추출.", small_st))
story.append(Spacer(1, 4))

data = json.loads((ROOT / "data" / "landmarks.json").read_text(encoding="utf-8"))
conf_color = {"verified": VERIFIED, "partial": PARTIAL, "low": LOW}
conf_label = {"verified": "검증", "partial": "부분", "low": "부족"}

rows = [[Paragraph("№", cellh_st), Paragraph("랜드마크", cellh_st),
         Paragraph("신뢰도", cellh_st), Paragraph("주요 출처", cellh_st)]]
for lm in sorted(data, key=lambda x: x["idx"]):
    m = lm.get("modeling", {})
    conf = m.get("data_confidence", "low")
    srcs = [e["label"] for e in lm["links"].get("extras", []) if e["label"] != "Google 이미지"]
    src_txt = ", ".join(dict.fromkeys(srcs)) if srcs else "—"
    cstyle = S(f"cf{lm['idx']}", fontName=KRB, fontSize=7.4, textColor=conf_color[conf], alignment=TA_CENTER, leading=10)
    rows.append([
        Paragraph(f"{lm['idx']:02d}", cellc_st),
        Paragraph(lm["name"], cell_st),
        Paragraph(conf_label[conf], cstyle),
        Paragraph(src_txt, cell_st),
    ])

t = Table(rows, colWidths=[26, 175, 42, 235], repeatRows=1)
t.setStyle(TableStyle([
    ("BACKGROUND", (0, 0), (-1, 0), ACCENT),
    ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, SOFT]),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 5), ("RIGHTPADDING", (0, 0), (-1, -1), 5),
    ("TOPPADDING", (0, 0), (-1, -1), 4), ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ("LINEBELOW", (0, 0), (-1, -1), 0.4, LINE),
]))
story.append(t)

# ════════ 5. 한계 및 후속 ════════
story.append(Paragraph("5.  한계 및 검증 필요 사항", h1_st))
story.append(bullet("<b>DATA LOW 23개</b>: 공개 자료로는 정확한 footprint·치수 확보 불가 → <b>클라이언트 제공 자료가 정확도의 핵심</b>"))
story.append(bullet("<b>Footprint(EPSG:3857)</b>: 위탁자 제공 예정 — 수령 후 모든 모델의 위치·스케일 정밀 보정"))
story.append(bullet("<b>건설 중 항목</b>: 위성 이미지와 최종 도면이 다를 수 있음 (Aramco Stadium 등)"))
story.append(bullet("<b>폴리곤 한도</b>: 현 모델은 형태 위주(텍스처 미포함)라 tris가 큼 — 최적화 단계 별도 필요"))
story.append(Spacer(1, 8))
story.append(hr())
story.append(Paragraph(
    "본 방법론의 핵심은 <b>'확인된 것과 추정한 것을 명확히 구분'</b>하는 데 있습니다. "
    "권위 출처로 검증한 항목만 사실로 제시하고, 부족한 항목은 DATA LOW로 투명하게 표시하여 "
    "클라이언트 자료 수령 시 어디를 보강해야 하는지 즉시 파악할 수 있도록 설계했습니다.",
    body_st))


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont(KR, 7.5)
    canvas.setFillColor(MUTE)
    canvas.drawString(20 * mm, 12 * mm, "KSA Landmarks · 자료 수집 방법론")
    canvas.drawRightString(190 * mm, 12 * mm, f"{doc.page}")
    canvas.setStrokeColor(LINE)
    canvas.line(20 * mm, 15 * mm, 190 * mm, 15 * mm)
    canvas.restoreState()


doc = SimpleDocTemplate(
    str(OUT), pagesize=A4,
    leftMargin=20 * mm, rightMargin=20 * mm, topMargin=18 * mm, bottomMargin=20 * mm,
    title="KSA Landmarks 자료 수집 방법론",
)
doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(f"✓ {OUT}  ({OUT.stat().st_size/1024:.0f} KB)")
