set shell := ["bash", "-euo", "pipefail", "-c"]

# OpenSCAD 2021.01 is the oldest release the models must render on; on this
# workstation the `openscad` wrapper reads OPENSCAD_CHANNEL (stable = 2021.01).
export OPENSCAD_CHANNEL := env("OPENSCAD_CHANNEL", "stable")

# Every file that draws. Files not listed here must not emit geometry.
entries := "cad/v0/pipette.scad cad/v0/pipette-rack.scad"

[private]
default:
    @just --list

[doc("Render every entry to CSG and fail on any OpenSCAD warning (the CI gate)")]
check:
    scripts/render.sh csg build/check {{ entries }}

[doc("Export every entry to STL and require a manifold mesh (about 1 min)")]
test:
    scripts/render.sh stl build/stl {{ entries }}

[doc("Print the OpenSCAD version this justfile will use")]
version:
    openscad --version
