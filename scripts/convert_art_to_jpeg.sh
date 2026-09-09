#!/bin/bash
# One-off migration (already run, 2026-09-09): converted every opaque
# (non-alpha) PNG in assets/art/ to JPEG at quality 85, shrinking the
# directory from 145MB to 52MB (186 files converted). ChestClosed.png/
# ChestOpen.png were skipped and stay PNG — the only two files with an
# alpha channel, so a lossy JPEG would have dropped their transparency.
# `lib/theme/theme.dart` (_ArtLookup.assetName + 4 of 6 SingletonArt
# constants) was updated in the same commit to point at .jpg instead of
# .png for every migrated file.
#
# This script only CREATES .jpg files — it does not touch the original .png
# files. The now-redundant PNGs were deleted separately, after spot-checking
# converted images looked right, with:
#   cd assets/art && for f in *.png; do [ -f "${f%.png}.jpg" ] && rm "$f"; done
#
# Kept here as documentation of the migration and in case any future art
# drop needs the same non-alpha → JPEG treatment. Safe to re-run: skips any
# basename that already has a .jpg counterpart, and does no harm if run
# again with no matching .png files left.
set -euo pipefail
cd "$(dirname "$0")/../assets/art"

converted=0
skipped=0
failed=0

for png in *.png; do
  base="${png%.png}"
  jpg="${base}.jpg"

  if [[ "$base" == "ChestClosed" || "$base" == "ChestOpen" ]]; then
    skipped=$((skipped+1))
    continue
  fi

  if [[ -f "$jpg" ]]; then
    skipped=$((skipped+1))
    continue
  fi

  if sips -s format jpeg -s formatOptions 85 "$png" --out "$jpg" >/dev/null 2>&1 \
     && [[ -s "$jpg" ]]; then
    converted=$((converted+1))
  else
    echo "FAILED: $png" >&2
    failed=$((failed+1))
  fi
done

echo "Converted: $converted  Skipped: $skipped  Failed: $failed"
