set shell := ["bash", "-euo", "pipefail", "-c"]

# OpenSCAD 2021.01 is the oldest release the models must render on; on this
# workstation the `openscad` wrapper reads OPENSCAD_CHANNEL (stable = 2021.01).
export OPENSCAD_CHANNEL := env("OPENSCAD_CHANNEL", "stable")

# Every v0 file that draws. Files not listed here must not emit geometry.
entries := "cad/v0/pipette.scad cad/v0/pipette-rack.scad"

# The registered pipette sizes, each derived and reported by cad/main.scad.
sizes := "P200 P1000"

[private]
default:
    @just --list

[doc("Render every entry and derive every size, failing on any OpenSCAD warning (the CI gate)")]
check:
    scripts/render.sh csg build/check {{ entries }}
    for s in {{ sizes }}; do scripts/render.sh echo build/check -D "size=\"$s\"" cad/main.scad; done

[doc("Export every entry to STL and require a manifold mesh (about 1 min)")]
test:
    scripts/render.sh stl build/stl {{ entries }}

[doc("Print the derived figures, the parts to buy and the open items for one size")]
report size="P200":
    scripts/render.sh echo build/report -D 'size="{{ size }}"' cad/main.scad
    @sed 's/^ECHO: "//; s/"$//' build/report/main-size__{{ size }}_.echo

[doc("Print the OpenSCAD version this justfile will use")]
version:
    openscad --version
