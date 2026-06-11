# Files 폴더 — 자동 감지

이 폴더에 파일을 넣으면 Files 페이지가 자동으로 랜드마크별로 그룹핑합니다.
(별도 JSON 편집 불필요 — 파일만 넣고 `python3 scripts/build.py` 실행)

## 파일명 규칙 (번호로 랜드마크 매칭)

- 3D 모델:   KSA-01.glb, KSA-13.glb  (또는 01.glb)
- 스크린샷:  01-1.png, 01-2.png, 13-1.png ...

번호는 랜드마크 idx (01~40). 앞 숫자만 맞으면 인식됨.
같은 번호 glb 여러 개 → Files 카드의 3D 뷰어에 탭으로 표시.

## 업데이트 (최신으로 덮어쓰기)

1. progress/ 에 새 파일 넣기 (같은 이름이면 덮어쓰기 = 최신본)
2. python3 scripts/build.py
3. git add -A && git commit -m "..." && git push

지원 확장자: .glb (모델) / .png .jpg .jpeg .webp (이미지)
