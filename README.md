# KSA Landmarks · 3D Modeling Reference

사우디아라비아 41개 랜드마크에 대한 3D 모델링 참고 자료와 작업물 공유 사이트. 정적 HTML 페이지 생성기.

UI 문구를 작성하거나 수정할 때는 [UI 용어와 문구 작성 기준](UI_COPY.md)을 참고합니다.
레이아웃 변경 시에는 [UI 레이아웃 유지 기준](UI_LAYOUT.md)에 따라 주변 간격과 반응형 화면을 함께 확인합니다.

## 폴더 구조

```
ksa-landmarks/
├── data/
│   ├── landmarks.json    ← 랜드마크 41개 데이터 (편집 가능)
│   └── glossary.json     ← 건축 용어 사전 (편집 가능)
├── images/               ← 다운로드된 랜드마크 이미지
├── progress/             ← 팀 제작 모델·스크린샷 원본
├── balady_plus/          ← Balady+ 참조 모델 원본
├── scripts/
│   ├── fetch_images.py   ← Wikipedia에서 이미지 자동 다운로드
│   └── build.py          ← JSON + 템플릿 → HTML 빌드
├── templates/
│   ├── index.html.tpl    ← Reference 템플릿 (CSS/JS 포함)
│   └── progress.html.tpl ← Files·참조 모델 템플릿
├── docs/                 ← GitHub Pages 배포 결과물
│   ├── index.html        ← Reference
│   └── progress/         ← Files·Balady+·Archive 페이지와 에셋
└── Makefile
```

## 빠른 시작

```bash
# 1) 이미지 자동 다운로드 (위키피디아 → images/ 폴더)
make fetch
# 또는: python3 scripts/fetch_images.py

# 2) HTML 빌드
make build
# 또는: python3 scripts/build.py

# 3) 로컬 서버로 띄우기 (이미지 정상 로드 확인)
make serve
# 그 후 http://localhost:8000/docs/index.html 접속
```

## 이미지 다운로드 옵션

```bash
# 누락된 것만 받기 (기본)
python3 scripts/fetch_images.py

# 전부 다시 받기
python3 scripts/fetch_images.py --force

# 특정 번호만 받기 (예: 5번, 12번)
python3 scripts/fetch_images.py --idx 5,12

# 다운로드 없이 매칭 결과만 미리 확인
python3 scripts/fetch_images.py --check

# 더 큰 썸네일 받기 (기본 800px)
python3 scripts/fetch_images.py --size 1200
```

## 데이터 수정

### 랜드마크 정보 수정
`data/landmarks.json`을 직접 편집하면 됨. 각 항목 구조:

```json
{
  "id": "01",
  "idx": 1,
  "name": "National Museum of Saudi Arabia",
  "name_lines": ["National Museum", "of Saudi Arabia"],
  "tier": 1,
  "city": "Riyadh",
  "type": "museum",
  "badge": "MUSEUM",
  "image": {
    "url": "...",              ← Wikipedia에서 자동으로 채워짐
    "wiki_query": "...",       ← Wikipedia 검색 쿼리 (수정 가능)
    "fallback": "...",         ← 기존 이미지 (있으면)
    "local_path": "01_xxx.jpg" ← 로컬 이미지 파일명
  },
  "key_points": ["...", "..."],
  "structure": [
    {"label": "형태", "value": "..."}
  ],
  "tags": ["저층", "곡선파사드"],
  "remarks": [],
  "links": {
    "google_maps_query": "...",
    "extras": [
      {"label": "Archello", "url": "https://..."}
    ]
  }
}
```

### 매칭이 안 되는 랜드마크는?
1. `data/landmarks.json`에서 `image.wiki_query`를 더 정확한 검색어로 수정
2. 또는 직접 이미지를 `images/` 폴더에 저장하고 `image.local_path`에 파일명 지정
3. `python3 scripts/fetch_images.py --idx <번호>`로 다시 시도

## 새 랜드마크 추가
`data/landmarks.json`에 새 객체 추가 → `make fetch` → `make build`. 끝.

## 파일 변경 자동 감지 (개발 모드)
```bash
python3 scripts/build.py --watch
```
data/ 또는 templates/ 변경 시 자동 재빌드.

## 의존성
사이트 빌드는 표준 라이브러리만 사용 (Python 3.9+). 추가 설치 불필요.
방법론 PDF 재생성(`scripts/make_methodology_pdf.py`)은 별도로 ReportLab과 AppleGothic 폰트가 필요합니다.

`Archive_901/`은 Git에서 제외된 로컬 원본입니다. 이 폴더가 없는 환경에서는
`docs/progress/assets/archive/`의 배포용 모델로 아카이브 페이지를 재생성합니다.
