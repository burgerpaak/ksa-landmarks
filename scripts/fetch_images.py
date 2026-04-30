#!/usr/bin/env python3
"""
Wikipedia API → Wikimedia Commons에서 랜드마크 이미지 자동 다운로드.

사용법:
    python scripts/fetch_images.py              # 누락된 이미지만 받기
    python scripts/fetch_images.py --force      # 전부 다시 받기
    python scripts/fetch_images.py --idx 5,12   # 특정 번호만
    python scripts/fetch_images.py --check      # 다운로드 없이 매칭 결과만 확인

작동 원리:
1. data/landmarks.json의 wiki_query로 위키피디아 검색
2. 매칭된 페이지의 pageimage(인포박스 메인 이미지) 800px 가져오기
3. images/{id}_{slug}.jpg로 저장
4. landmarks.json의 image.local_path 갱신

Wikipedia에 없는 항목은 fallback URL로 시도하고, 그래도 실패하면
누락 리스트로 출력해서 수동 보강 가능.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path
from urllib.parse import quote
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data" / "landmarks.json"
IMG_DIR = ROOT / "images"

WIKI_API = "https://en.wikipedia.org/w/api.php"
USER_AGENT = "KSA-Landmarks-Reference/1.0 (3D modeling reference tool; ref-tool@example.org)"


def slug(text: str) -> str:
    """파일명용 슬러그"""
    s = re.sub(r"[^\w\s-]", "", text.lower())
    s = re.sub(r"[-\s]+", "-", s).strip("-")
    return s[:50]


def http_get_json(url: str) -> dict:
    req = Request(url, headers={"User-Agent": USER_AGENT, "Accept": "application/json"})
    with urlopen(req, timeout=20) as r:
        return json.loads(r.read())


def http_get_bytes(url: str) -> bytes:
    req = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(req, timeout=30) as r:
        return r.read()


def search_wiki_image(query: str, thumb_size: int = 800) -> tuple[str | None, str | None]:
    """위키피디아에서 검색 후 메인 이미지 URL 반환. (image_url, page_title)"""
    if not query:
        return None, None

    # 1) 페이지 검색
    search_url = (
        f"{WIKI_API}?action=query&format=json&list=search"
        f"&srsearch={quote(query)}&srlimit=1"
    )
    try:
        data = http_get_json(search_url)
    except Exception as e:
        print(f"    [search err] {e}")
        return None, None

    results = data.get("query", {}).get("search", [])
    if not results:
        return None, None

    title = results[0]["title"]

    # 2) 페이지의 pageimage(infobox 메인 이미지) 가져오기
    img_url = (
        f"{WIKI_API}?action=query&format=json&titles={quote(title)}"
        f"&prop=pageimages&pithumbsize={thumb_size}"
    )
    try:
        data = http_get_json(img_url)
    except Exception as e:
        print(f"    [thumb err] {e}")
        return None, title

    pages = data.get("query", {}).get("pages", {})
    for _, page in pages.items():
        thumb = page.get("thumbnail", {}).get("source")
        if thumb:
            return thumb, title
    return None, title


def download_image(url: str, dest: Path) -> bool:
    try:
        data = http_get_bytes(url)
        dest.write_bytes(data)
        return True
    except Exception as e:
        print(f"    [download err] {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Wikipedia에서 랜드마크 이미지 다운로드")
    parser.add_argument("--force", action="store_true", help="이미 받은 것도 다시 받기")
    parser.add_argument("--idx", type=str, help="특정 번호만 (예: 1,5,12)")
    parser.add_argument("--check", action="store_true", help="다운로드 없이 매칭만 확인")
    parser.add_argument("--size", type=int, default=800, help="썸네일 크기 (기본 800px)")
    args = parser.parse_args()

    if not DATA.exists():
        sys.exit(f"❌ {DATA} 없음")

    landmarks = json.loads(DATA.read_text(encoding="utf-8"))
    IMG_DIR.mkdir(exist_ok=True)

    target_idx = None
    if args.idx:
        target_idx = {int(x) for x in args.idx.split(",")}

    stats = {"ok": 0, "skip": 0, "fail": 0, "no_match": []}

    for lm in landmarks:
        idx = lm["idx"]
        if target_idx and idx not in target_idx:
            continue

        name = lm["name"]
        query = lm["image"].get("wiki_query", "")
        local_path = lm["image"].get("local_path", "")
        existing = IMG_DIR / local_path if local_path else None

        # 이미 받았고 force가 아니면 스킵
        if not args.force and existing and existing.exists() and existing.stat().st_size > 1000:
            stats["skip"] += 1
            print(f"  [{idx:02d}] {name}  →  이미 있음 ({local_path})")
            continue

        print(f"  [{idx:02d}] {name}")
        print(f"       query: '{query}'")

        url, title = search_wiki_image(query, thumb_size=args.size)
        if not url:
            print(f"       ⚠ 매칭 실패 (검색: {title or '결과 없음'})")
            stats["fail"] += 1
            stats["no_match"].append({"idx": idx, "name": name, "query": query})
            time.sleep(0.3)
            continue

        if title and title.lower() != query.lower():
            print(f"       → matched: '{title}'")
        print(f"       → {url[:90]}...")

        if args.check:
            stats["ok"] += 1
            time.sleep(0.3)
            continue

        # 파일명 결정
        ext = url.rsplit(".", 1)[-1].split("?")[0].lower()
        if ext not in ("jpg", "jpeg", "png", "webp"):
            ext = "jpg"
        filename = f"{idx:02d}_{slug(name)}.{ext}"
        dest = IMG_DIR / filename

        if download_image(url, dest):
            size_kb = dest.stat().st_size / 1024
            print(f"       ✓ saved: images/{filename} ({size_kb:.0f}KB)")
            lm["image"]["local_path"] = filename
            lm["image"]["url"] = url  # 원본 URL 백업
            stats["ok"] += 1
        else:
            print(f"       ✗ 다운로드 실패")
            stats["fail"] += 1
            stats["no_match"].append({"idx": idx, "name": name, "query": query})

        time.sleep(0.4)  # rate limit 매너

    # 결과 저장
    if not args.check:
        DATA.write_text(
            json.dumps(landmarks, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

    # 요약
    print("\n" + "=" * 60)
    print(f"✓ 성공:  {stats['ok']}")
    print(f"⊘ 스킵:  {stats['skip']}")
    print(f"✗ 실패:  {stats['fail']}")
    if stats["no_match"]:
        print("\n매칭 실패 항목:")
        for item in stats["no_match"]:
            print(f"  - [{item['idx']:02d}] {item['name']}")
        print("\n→ data/landmarks.json에서 image.wiki_query를 수정한 뒤 다시 실행하거나,")
        print("   image.fallback 또는 image.local_path를 직접 채우세요.")


if __name__ == "__main__":
    main()
