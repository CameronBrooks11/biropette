default:
    @just --list

# Render the pipette's parts A to G and the rack's two pieces into prints/
prints:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p prints
    for p in A B C D E F G; do
        defs=()
        for q in A B C D E F G; do [ "$q" = "$p" ] && v=true || v=false; defs+=(-D "show_part$q=$v"); done
        openscad --export-format binstl "${defs[@]}" -o "prints/part${p}_v0.stl" pipette.scad
    done
    openscad --export-format binstl -D show_top_beam=true -D show_side_support=false -o prints/pipette-rack-top-beam.stl pipette-rack.scad
    openscad --export-format binstl -D show_top_beam=false -D show_side_support=true -o prints/pipette-rack-side-support.stl pipette-rack.scad
