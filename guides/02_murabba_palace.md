# [02] Murabba Palace — 모델링 가이드

> 첫 카드(파이프라인 테스트) · Cinema 4D R26 → FBX → Blender → glb

---

## 1. 카드 데이터 요약

| 항목 | 값 |
|---|---|
| Tier | 1 (핵심) |
| Type | Heritage |
| City | Riyadh |
| 사이즈 분류 | **중형 (10–50m)** |
| 폴리곤 예산 | **≤10,000 tris** |
| WGS84 좌표 | **24.64655, 46.70917** |
| 시공 상태 | 완공 |
| 시대 | 1936–1938 |
| 설계자 | Ibn Qabba (master builder) |
| 머티리얼 | **없음** (사양서: 텍스처 미제작 기본) |

**필수 모델링 요소 (4가지 — 빠지면 그 건물 X):**
1. 정사각형 어도비 흙벽 매스 (2층)
2. 4면 모서리 망루 (Barjeel)
3. 톱니형(삼각) 파라펫 장식 상단
4. 작고 깊은 사각 창 + 나무 격자

---

## 2. 참고 자료

**프로젝트 내 참조 이미지:**
- `docs/images/02_murabba-palace.jpg` (메인)
- `docs/images/02_murabba-palace_2.jpg`
- `docs/images/02_murabba-palace_3.jpg`

**외부 권위 자료:**
- Wikipedia: https://en.wikipedia.org/wiki/Murabba_Palace
- Google Maps: https://maps.app.goo.gl/ctYXJ3qtc2vHXC3b6
- 위성뷰: Google Maps 3D View로 평면·매스 비례 확인

**핵심 형태 인식:**
- 외형은 **단순한 입방체 박스 + 4모서리 망루**
- 정사각형 평면, 2층 본체, 모서리 망루는 1층 더 (총 3층 높이)
- 외벽 자체는 매우 단순 — 디테일은 상단 파라펫 + 창의 그림자 라인이 핵심

---

## 3. Cinema 4D 셋업

### Project Settings
```
Edit → Project Settings
  Project Scale: Meters (m)        ← 필수
  Use Real Animation FPS: 무관 (정적)
```

### Naming · Origin
- 파일명: `02_murabba_palace.c4d`
- **모델 중심을 (0, 0, 0) 근처에 두기** (±10m 이내)
- **C4D 축 규약 (Y-up — C4D 기본, glTF 표준과 일치):**
  - **+Y = 위 (높이/height)** ← Size.Y가 건물 높이
  - **+X = 동/오른쪽 (가로)** ← Size.X가 건물 가로
  - **−Z = 북향 정면 (깊이)** ← Size.Z가 건물 깊이, 방위각은 메타데이터에서 보정
- 외벽 부지(흙벽 ~400×400m)는 **모델링 대상 아님**. 건물 본체만.

### 단위 검증
- 작업 중 어떤 객체든 선택 → Coordinate Manager에서 m 단위 숫자 확인
- 건물이 ±50m 박스 안에 들어와야 정상

---

## 4. 모델링 단계

### Phase A — 블록아웃 (10분, 목표 ~200 tris)

**A1. 본체 매스** (Y-up 기준: Y가 높이)
- Cube 생성 → **Size.X=50m, Size.Y=10m, Size.Z=50m** (footprint 50×50m, 높이 10m, 2층 가정)
- 위치 **P.Y=5m** — 바닥이 Y=0(지면)에 닿게 (피봇이 중심이라 높이/2)
- P.X=0, P.Z=0
- Object Manager에서 이름 → `body` (또는 `본체`)

**A2. 4모서리 망루 (Barjeel)** (1층 더 높음)
- Cube → **Size.X=6m, Size.Y=14m, Size.Z=6m** (본체보다 ~4m 더 높음)
- 4모서리에 인스턴스 배치 — 가로(X)·깊이(Z) 양 끝, 높이(Y)는 절반 위치(7m):
  - (+22, 7, +22), (+22, 7, −22), (−22, 7, +22), (−22, 7, −22)
- **Instance 사용**: 1개 만든 뒤 Instance Object로 3개 복제 → 폴리곤·수정 효율
- "tower" (또는 "망루") 그룹으로 명명

**A3. 안마당 (선택)**
- 본체 중앙에 직사각형 컷아웃 — 외부에서는 안 보이는 안뜰
- 사양서: "비가시 면은 만들지 않는다"
- → **외부에서 안 보이면 안마당 자체를 모델링하지 말 것** (천장으로 막힌 박스로 처리). 항공뷰에서 보이면 ㄷ자 또는 ㅁ자 컷아웃.
- **결정**: 위성사진 보고 항공뷰에서 안마당이 노출되는지 확인 후 결정. 노출 안 되면 생략.

**체크포인트**: 이 시점에서 약 60–150 tris

---

### Phase B — 톱니 파라펫 (15분, +1,500 tris 예산)

**B1. 단일 톱니 만들기**
- Cube → **Size.X=0.8m, Size.Y=0.6m, Size.Z=0.4m** (가로·높이·두께)
- 또는 삼각 프리즘 (Prism Object → 3 segment)
- 본체 외벽 상단 **Y=10**(본체 윗면)에 배치, 톱니 바닥이 외벽 윗면에 닿도록 P.Y=10.3

**B2. Cloner / Array로 반복**
- C4D MoGraph Cloner Object (Linear 모드 × 4면, 또는 Spline 둘레 모드)
- 본체 외벽 4면 둘레 따라 일정 간격으로 배치 (높이 Y=10.3 고정)
  - X축 변: 외벽 길이 50m / 톱니 간격 1.2m ≈ 40개 × 2면 = 80개
  - Z축 변도 동일 40개 × 2면 = 80개
  - 총 4면 ≈ 160개 톱니
- 망루 상단(Y=14)에도 동일 패턴 적용 (소형 톱니, 면당 5–6개)

**Tri 추산:**
- 1톱니 = ~12 tris (사각 프리즘)
- 본체 톱니 160 × 12 = ~1,920 tris ⚠ 예산 압박
- **최적화**: 톱니를 더 단순화 (삼각 프리즘 6 tris) → 160 × 6 = 960 tris

**체크포인트**: 약 1,200–2,000 tris

---

### Phase C — 창 (15분, +1,500 tris 예산)

**C1. 단일 창 만들기**
- 외벽에 음각 홈 또는 깊은 사각 박스
- **Size.X=0.6m, Size.Y=1.2m, Size.Z=0.4m** (가로·세로·깊이)
- **모서리만 살짝 챔퍼 (Bevel)** — 그림자 라인 생성, 0.5–1 segment만

**C2. 창 배치**
- 사양서: "창문이 매우 작고 불규칙하게 배치됨"
- **정확한 격자 X — 약간의 불규칙성 부여**
- 본체 4면 외벽 × 면당 약 8–12개 = 총 ~40개
- 망루: 면당 1–2개 = 총 ~12개

**Cloner 사용 시**: 약간의 Random Effector 적용 (위치·회전 미세 변동)

**Tri 추산:**
- 음각 박스 1개 = ~20 tris (챔퍼 포함)
- 50개 × 20 = ~1,000 tris

**체크포인트**: 약 2,500–3,500 tris

---

### Phase D — 망루 디테일 (10분, +500 tris)

- 망루 상단 모서리에 추가 톱니 4–6개씩 (이미 B에 포함했으면 생략)
- 망루 정상에 작은 캐노피·차양 (있다면 — 사진 보고 확인)
- 망루 외벽에도 작은 환기·관측 창 1개씩

**체크포인트**: 약 3,000–4,000 tris

---

### Phase E — 검토 · 클린업 (10분)

**E1. 비가시 면 제거**
- 본체 바닥면 (Y=0 아래로 안 보이는 면) 삭제
- 망루와 본체가 접하는 면 — 본체 외벽의 가려진 부분 또는 망루 안쪽 면 삭제
- 외부에서 보이지 않는 안마당 내벽 (안마당을 모델링했다면)

**E2. Triangulate**
- Mesh → Commands → Untriangulate **금지** (이미 quad라면 두기)
- 익스포트 직전에 Triangulate (모든 면 삼각형) — 또는 Blender에서 처리

**E3. 중복 버텍스**
- C4D: Mesh → Commands → Optimize... → Tolerance 0.001m
- 또는 Blender에서 Merge by Distance 0.0001m

**E4. Tri 카운트 확인**
- C4D 우상단 정보 표시 또는 Polygon Selection > Info
- **목표: ≤10,000 tris (중형 한도)**
- 초과 시: 톱니 간격 늘리거나 창 단순화

**최종 예상**: 3,500–5,500 tris (예산의 35–55%, 여유 있음)

---

## 5. 익스포트

### C4D → FBX
```
File → Export → FBX (.fbx)
  Geometry: 모든 객체 포함
  Materials: 체크 해제 (머티리얼 없음)
  Animations: 체크 해제
  Cameras / Lights: 체크 해제
  Triangulate: 체크 (또는 Blender에서)
  Scale: 1.0 (단위 m 유지)
```

저장 위치: `models/02_murabba_palace/src.fbx`

### Blender → glTF/.glb
```
File → Import → FBX (.fbx)
File → Export → glTF 2.0 (.glb/.gltf)

Format: GLB
Include:
  Selected Objects: off (전체)
  Visible Objects: on
Transform:
  +Y Up: on
Geometry:
  Apply Modifiers: on
  Triangulate: on            ← 사양 요건
  UV: off (머티리얼 없음)
Material:
  No materials (off)
Animation: off
Lighting: off
Compression: Draco off       ← 호환성 우선
```

산출물: `02_murabba_palace.glb`

---

## 6. 자체 검수 (사양서 6항목)

납품 전 체크:
- [ ] **씬 단위 m** — C4D Project Settings + Blender Scene Unit 모두 확인
- [ ] **좌표 정합** — Footprint(EPSG:3857) 받기 전엔 위성사진과 평면 비례 비교
- [ ] **Tri 수** — `≤10,000` (Blender N-panel → Statistics)
- [ ] **비가시 면 제거** — 바닥·접합부·내부 면 미포함
- [ ] **산출물 세트** — `.gltf` + `.bin` + `.glb` (`.json` 메타데이터는 변환 툴 수령 후)
- [ ] **스케일 검증** — Blender 측정 도구로 본체 X·Z 변이 ~50m, Y(높이) ~10m인지

---

## 7. 메타데이터 임시 템플릿

변환 툴 받기 전까지 사용:
```json
{
  "landmark_id": "02",
  "landmark_name": "Murabba Palace",
  "model_file": "02_murabba_palace.glb",
  "origin_wgs84": {
    "lat": 24.64655000,
    "lon": 46.70917000,
    "ellipsoidal_height": null
  },
  "azimuth_deg": null,
  "_note_azimuth": "위성사진에서 모델 +Y가 정북에서 시계방향 몇 도인지 측정",
  "offset_m": { "x": 0, "y": 0, "z": 0 },
  "scale": 1.0,
  "_note_scale": "footprint 수령 후 실측 비교 보정"
}
```

저장: `models/02_murabba_palace/metadata.json`

---

## 8. 예상 시간 / 폴리곤 분배

| Phase | 시간 | Tri 누적 | 비고 |
|---|---:|---:|---|
| A. 블록아웃 | 10분 | ~150 | 매스만 |
| B. 톱니 파라펫 | 15분 | ~1,500 | Cloner 활용 |
| C. 창 | 15분 | ~2,500 | 음각 박스 |
| D. 망루 디테일 | 10분 | ~3,000 | 추가 톱니·창 |
| E. 검토·클린업 | 10분 | ~3,500 | 비가시 면 제거 |
| **합계** | **60분** | **≤10k** | 예산의 ~35% 사용 |

여유분 6,500 tris로 디테일 추가 여지 큼 — 단, **단순함이 Najdi 양식의 본질**이라 과한 디테일은 양식 훼손.

---

## 9. 첫 카드 완료 후 — 파이프라인 검증 항목

이 카드 끝나면 다음을 확인:
1. C4D → FBX → Blender → glb 전 과정 한 번 통과 ✓
2. tri 수 사양 한도 안에 들어가는지 ✓
3. glb 파일을 Three.js 뷰어 등으로 열어서 모델 정상 표시 ✓
4. 자체 검수 6항목 통과 ✓
5. 위탁자 1차 리뷰용 제출 → 피드백 받기

피드백 받으면 그걸 반영해 **모델링 가이드 패턴 보정** 후 다음 카드부터 적용.
