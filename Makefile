.PHONY: fetch build serve all clean watch help

PYTHON := python3
PORT := 8000

help:
	@echo "사용 가능한 커맨드:"
	@echo "  make fetch    - 위키피디아에서 이미지 자동 다운로드"
	@echo "  make build    - JSON + 템플릿 → HTML 빌드"
	@echo "  make serve    - 로컬 서버 실행 (포트 $(PORT))"
	@echo "  make watch    - 파일 변경 자동 감지 + 재빌드"
	@echo "  make all      - fetch + build"
	@echo "  make clean    - 빌드 결과물 삭제"

fetch:
	$(PYTHON) scripts/fetch_images.py

fetch-force:
	$(PYTHON) scripts/fetch_images.py --force

fetch-check:
	$(PYTHON) scripts/fetch_images.py --check

build:
	$(PYTHON) scripts/build.py

watch:
	$(PYTHON) scripts/build.py --watch

serve:
	@echo "→ http://localhost:$(PORT)/output/index.html"
	@$(PYTHON) -m http.server $(PORT)

all: fetch build

clean:
	rm -f output/index.html
	@echo "✓ output/index.html 삭제됨"

clean-images:
	rm -rf images/*.jpg images/*.png images/*.webp
	@echo "✓ images/ 비움"
