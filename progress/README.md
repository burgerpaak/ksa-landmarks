# 진행 보고 추가 방법

1. progress/ 폴더에 파일 넣기:
   - 스크린샷: 아무 이름.jpg (예: 02_blockout_01.jpg)
   - 3D 모델: 아무 이름.glb (예: 02_blockout.glb)

2. data/progress.json 의 entries 배열 맨 위에 추가:
   {
     "date": "2026-06-15",
     "landmark_id": "02",
     "title": "톱니 파라펫 완료",
     "notes": "설명...",
     "tri_count": 5200,
     "budget": 20000,
     "screenshots": ["02_blockout_01.jpg"],
     "model": "02_blockout.glb"
   }

3. python3 scripts/build.py && git add -A && git commit -m "..." && git push

- screenshots/model은 없으면 빈 배열 []/null 로 두면 됨 (텍스트만 표시)
- 파일이 progress/ 에 없으면 자동 무시 (깨진 링크 안 생김)
