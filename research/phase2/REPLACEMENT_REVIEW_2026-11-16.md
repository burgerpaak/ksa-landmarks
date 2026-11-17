# Phase 2 후보 교체 — 2026-11-16

사용자 결정: 우선순위 1번 N83 Dammam Public Library는 유지하고, 2·3·5번을 대체 후보로 교체한다. 4번 J65 teamLab Borderless Jeddah도 유지한다.

| 기존 카드 | 교체 카드 | 도시 |
| --- | --- | --- |
| N82 Yousef Al Dossary Grand Mosque | N91 Prince Saud Monument | Dammam 유지 |
| J72 Tariq Abdulhakim Museum | J76 Darat Safeya Binzagr | Jeddah 유지 |
| J69 Bayt Zenel / Bayt Xenel | N92 Anan Alsama | Jeddah → Al Khobar |

총 42개 유지. 도시별 Jeddah 20 → 19, Dammam 11 유지, Al Khobar 11 → 12. 기존의 다른 39개 후보와 N83·J65의 데이터·이미지는 변경하지 않았다. 이전 N82·J72·J69의 조사·지도 기록과 이미지 메타데이터는 `removed-from-web.json`에 보존한다. 기존 이미지 파일도 유지하며, 새 카드에는 별도 ID를 부여해 이전 카드의 코멘트 경로를 재사용하지 않는다. 서버의 기존 코멘트는 삭제하거나 이전하지 않았다.

## 조사 근거와 남은 확인

- **N91 Prince Saud Monument:** [개발사](https://dammamdev.com.sa/project/prince-saud-monument/)가 담맘 King Fahd Street 소재 기념물로 소개하며 게재 외관 사진을 사용한다. 정확한 고유 위치·현재 존치·후면·상부·제작 범위는 미확인. 개발사의 연도 표기를 별도 교차 검증하지 않아 완공 연도를 확정 사실로 채택하지 않았다.
- **J76 Darat Safeya Binzagr:** [운영기관](https://daratsb.com/), [방문 안내](https://daratsb.com/visit/), [설계사](https://mokarchitects.com/projects/darat-safeya-binzagr/)를 대조했다. 설계사는 미구현 원안과 실제 구현된 지상 두 층을 구분한다. 방문 안내 King Abdullah Road와 설계사 기록 Wali Alahed Street 간 대응·고유 위치·후면·지붕은 추가 확인한다. 원안의 면적·층수를 실제 건물의 확정 치수로 사용하지 않는다.
- **N92 Anan Alsama:** [주최 측](https://mwaward.com/projects/anan-alsama/)의 작품명·두 조형물 구성과 [지역 아카이브](https://maalemsa.com/en/landmarks/anan-alsama/)의 사진·항공사진·코바르 주소를 대조했다. 주최 측의 Riyadh 도시 표기와 연결 지도 좌표의 코바르 권역이 상충한다. 지역 아카이브에 기재된 Al Khobar를 후보 도시로 사용하되 상충·정밀 위치 미확인을 표시한다. 야간 조명색을 외장색으로 사용하지 않는다.

세 후보 모두 평면·배치도 검색을 실시했으나 공개 도면은 확보하지 못했다. Anan Alsama는 항공사진이 있으나 설계 배치도나 측량 자료가 아니다. 사진에 보이지 않는 형상과 높이·두께는 확정하지 않으며, 모델링 시 추정 부분을 별도 안내·기록해야 한다. 지도는 세 후보 모두 검증 전 검색 링크로 제공한다.

Reference·Balady+·Archive·Phase 1·Phase 2 및 타업체 324개 목록의 명칭·별칭 대조에서 동일 대상 미발견. 전체 GLB 형상 대조는 미수행. 이번 교체는 조사 후보 구성 변경이며 신뢰도 검증 완료·모델링 최종 출력 승인·공개 배포 승인이 아니다.

## 추가 교체 — Beit Baeshen → Corniche Mosque

2026-11-16 사용자 요청으로 **J70 Beit Baeshen → J77 Corniche Mosque**를 반영했다. Jeddah 유지, 전체 42개와 도시별 Jeddah 19·Dammam 11·Al Khobar 12 유지. 다른 41개 후보·이미지·렌더링된 카드는 변경하지 않았다. 이전 카드와 이미지 메타데이터는 `removed-from-web.json`에 추가 보존하고 기존 이미지 파일은 유지했다. 새 ID로 기존 Beit Baeshen의 코멘트 경로와 구분하며 서버 코멘트는 수정·삭제하지 않았다.

- **수상·건물 식별:** [AKDN 공식 수상 기록](https://the.akdn/en/how-we-work/our-agencies/aga-khan-trust-culture/akaa/corniche-mosque)과 [Archnet 건물 기록](https://www.archnet.org/sites/429)을 대조해 1989년 아가칸 건축상 수상작임을 확인했다. Corniche Mosque는 Island·Al-Ruwais·Sulaiman Mosque와 다른 건물이다. 완공 연도는 AKDN 1986년·Archnet 1988년으로 상충해 확정 연도를 채택하지 않았다.
- **사진:** AKDN 공식 외관 전경과 지붕 확대 사진을 각각 `research-j77-01.webp`, `research-j77-02.webp`로 연결했다. 내부 사진은 외관 사진으로 사용하지 않았다. 전경의 하부 울타리 가림과 확대 사진 원본의 상·하부 잘림을 설명에 남겼다. 사진의 AKTC 표기는 확인했지만 촬영일·촬영자·재사용 허가는 미확인이다. 로컬 검토용 이미지다.
- **평면·배치도 검색:** [설계자 제출 도면 소장 기록](https://www.archnet.org/publications/712)과 [현장 심사 보고서](https://www.archnet.org/publications/715)를 확인했다. [AKDN 단면도 원본](https://static.the.akdn/53832/1644226990-10116_4.jpg)을 내려받아 시각 검토했다. 해당 도판은 단면도이며 평면도가 아니다. 평면도 원본·배치도·축척·구조 치수는 미확보 또는 미검증이다. 도판만으로 높이·부분 높이·footprint를 생성하지 않았다.
- **지도:** Archnet Directions 링크의 `21.633895,39.102592`를 원문 자릿수로 보존하고 `지도 (좌표)`로 연결했다. 사우디 영역 내 위치를 확인했으나 Google 장소 핀·현재 존치·납품 정밀 좌표 검증은 별도다.
- **검증 범위:** 현재 목록과 타업체 324개 목록의 명칭·별칭 대조에서 동일 대상 미발견. 전체 GLB 형상 대조는 미수행. 현재 외관과 기록 사진의 일치·정밀 위치·제작 범위·도면 축척·치수는 미확인 사항으로 유지한다. 이번 변경은 후보 교체이며 모델링 착수·최종 출력·공개 배포는 포함하지 않는다.
