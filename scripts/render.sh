#!/usr/bin/env bash
# Render OpenSCAD entry files and fail on anything OpenSCAD only warns about.
#
# usage: scripts/render.sh <csg|stl> <outdir> <file.scad>...
#
# OpenSCAD exits 0 on a missing include, an unknown module, an undefined
# variable and a failed assert, so the exit status is not trusted: stderr is
# searched for WARNING/ERROR, the output must be non-empty, and an STL export
# must report a manifold ("Simple: yes") result.
set -euo pipefail

fmt=${1:?usage: render.sh <csg|stl> <outdir> <file.scad>...}
out=${2:?usage: render.sh <csg|stl> <outdir> <file.scad>...}
shift 2
[ "$#" -gt 0 ] || { echo "render.sh: no files given" >&2; exit 64; }
case "$fmt" in csg | stl) ;; *) echo "render.sh: format must be csg or stl" >&2; exit 64 ;; esac

mkdir -p "$out"
# 2021.01 cannot open a relative -o path for an input in a subdirectory.
out=$(cd "$out" && pwd)
fail=0
for f in "$@"; do
    name=$(basename "$f" .scad)
    target="$out/$name.$fmt"
    log="$out/$name.$fmt.log"
    status=0
    openscad --hardwarnings -o "$target" "$f" >"$log" 2>&1 || status=$?
    problem=""
    if [ "$status" -ne 0 ]; then
        problem="exit $status"
    elif grep -qE 'WARNING|ERROR' "$log"; then
        problem="warnings"
    elif [ ! -s "$target" ]; then
        problem="empty output"
    elif [ "$fmt" = csg ] && ! grep -qE '\b(cube|cylinder|sphere|polyhedron|square|circle|polygon|text|import|surface)\(' "$target"; then
        # an entry that draws nothing still writes a one-byte CSG
        problem="no geometry"
    elif [ "$fmt" = stl ] && ! grep -q 'Simple: *yes' "$log"; then
        problem="not manifold"
    fi
    if [ -n "$problem" ]; then
        echo "FAIL $f ($problem)"
        grep -E 'WARNING|ERROR' "$log" || true
        fail=1
    else
        echo "ok   $f"
    fi
done
exit "$fail"
