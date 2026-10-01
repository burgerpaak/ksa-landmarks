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

## Research 코멘트 저장

Firebase 프로젝트 `ksa-landmarks-comments-8dec4`의 Spark 요금제와 서울
(`asia-northeast3`) Firestore 기본 데이터베이스를 사용합니다.
방문자에게 가입 화면을 표시하지 않고, 등록할 때 Firebase 익명 인증을 사용합니다.
표시 이름은 같은 브라우저의 localStorage에 기억합니다. 이름은 본인 확인 정보가 아닙니다.

- `data/firebase.json`: 공개 웹 앱 구성. 서비스 계정 키를 넣지 않습니다.
- `assets/research-comment-store.js`: 저장·조회 모듈. 빌드 시 `docs/assets/`에 복사합니다.
- `firebase/firestore.rules`: 배포할 보안 규칙 원본. 파일 수정만으로 서버 규칙이 바뀌지는 않습니다.
- 코멘트 경로: `landmarkComments/{카드 ID}/comments/{코멘트 ID}`.
  작성자·본문·익명 작성자 ID·서버 등록 시각을 저장하며, 수정 시 서버 수정 시각을 추가합니다.
- 등록 제한 기록: `commentWriters/{익명 작성자 ID}`. 동일 ID는 10초 간격으로 등록합니다.
  다른 방문자의 등록 제한 기록은 읽을 수 없습니다.

본인 코멘트에는 `⋯` 메뉴로 본문 수정·삭제를 제공합니다. 권한은 표시 이름이 아니라
Firebase 익명 작성자 ID로 제한하며, 작성자 이름·ID·등록 시각은 수정할 수 없습니다.
작성한 브라우저의 익명 인증 정보가 없어지면 본인 권한을 복구할 수 없습니다.
코멘트가 있는 카드에는 썸네일 우측 하단에 말풍선과 건수를 표시합니다.

수정·삭제는 웹 코드와 Firebase 규칙을 함께 배포해야 활성화됩니다.
2026-10-01 작성자 수정·삭제 규칙을 Firebase 콘솔에 게시하고 게시된 버전을 확인했습니다.

화면에 가까운 카드의 최근 두 개와 건수를 조회하고, 전체 보기에서는 20개씩 불러옵니다.
실시간 구독은 사용하지 않으므로 다른 사람이 새로 남긴 코멘트는 새로고침 후 확인합니다.
통신 실패 시 본문을 유지하며, 같은 등록 ID로 재시도해 중복 저장을 방지합니다.
코멘트에 만료 시간은 설정하지 않았습니다. 브라우저 데이터를 지워도 서버 코멘트는 유지됩니다.

[Firebase 콘솔](https://console.firebase.google.com/project/ksa-landmarks-comments-8dec4/firestore)
에서 데이터·규칙·사용량을 관리합니다. 코멘트는 공개 조회용입니다.
익명 ID에 대한 입력 제한은 완전한 스팸 방어가 아니며, 표시 이름의 진위는 검증하지 않습니다.
무료 한도는 [Firestore 할당량](https://firebase.google.com/docs/firestore/quotas)을 따릅니다.
유료 Blaze 요금제와 예약 백업은 사용 설정하지 않았습니다.

2026-10-01 연결 검증: 실제 저장·공개 재조회·건수 조회,
인증 없는 쓰기·작성자 ID 위조·추가 필드·빈 입력·길이 초과·잘못된 경로·연속 등록·수정 차단을 확인했습니다.
브라우저에서 등록·새로고침 유지·별도 origin 조회·취소·작성자 이름 기억·전체 보기와 안전한 텍스트 출력을 확인했습니다.
연결 검증 데이터는 `N99`에서 검사했으며, 배포 전 프리뷰의 예시 코멘트와 서버의 테스트 코멘트를 제거했습니다.
웹사이트 배포는 사용자 승인 후 진행합니다.

수정·삭제 검증: `node --experimental-vm-modules --test tests/comment-store.test.mjs`로
클라이언트 저장 모듈을 검증합니다. 로컬 Firestore 에뮬레이터에 이 프로젝트의 규칙을 적용한 뒤
`FIRESTORE_EMULATOR_HOST=127.0.0.1:8087 node --test tests/firestore-rules.test.mjs`로
작성자 권한·불변 필드·입력 제한·서버 시각·기존 등록 제한을 검증합니다.
규칙 테스트는 `demo-ksa-comments` 프로젝트의 로컬 예시 데이터만 사용합니다.
