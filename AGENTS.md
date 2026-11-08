# AGENTS.md

## Project

biropette: an open-source, 3D-printable adjustable air-displacement pipette.
v1 is single-channel (P200 and P1000 first) and is being redesigned from the
2014 Biropette. v2 will be multichannel. The design basis, with the sources
for every number, is `docs/design.md`. Read it before changing the model.

## Stack

- OpenSCAD. Models must render on **2021.01**, the oldest supported release.
  The justfile sets `OPENSCAD_CHANNEL=stable`; set `OPENSCAD_CHANNEL=nightly`
  to try a newer build.
- No external SCAD libraries. Adding one needs a reason and a licence check:
  a GPL library makes the whole model GPL-only.
- Python 3, standard library only, for calculation scripts.

## Layout

- `cad/v0/` holds the original Biropette and its exports. It is frozen and
  kept for comparison and attribution. Do not edit it.
- `cad/` holds the v1 model:
  - `cad/main.scad` is the only file that draws. It holds the Customizer and
    a `part` selector: `report` and the seal-rig parts.
  - `cad/layout.scad` has `layout()`, which derives everything once.
    `cad/report.scad` prints a layout.
  - `cad/purchased/<kind>s.scad` holds bought-part records (pistons,
    O-rings, sleeves, collars, springs, tips), data only.
  - `cad/data/` holds requirements and reference data (sizes, ISO 8655
    limits, thumb forces and seal friction).
  - `cad/lib/struct.scad` has the record accessors `get` / `known` /
    `by_name`.
  - `cad/parts/` holds the printed parts, one module per part, each drawing
    from its spec. Today that is the seal rig (`seal_rig.scad`, spec
    `seal_rig()` in `layout.scad`, procedure `docs/seal-rig.md`).
- `docs/design.md` is the design basis. `docs/v0/` holds the original guide.
- `scripts/render.sh` is the render gate. `scripts/sizing.py` produces the
  figures quoted in the design basis.

## Commands

- `just check`: render every v0 entry and every printed part to CSG, and
  derive every registered size through `cad/main.scad`. It fails on any
  OpenSCAD warning or error, or on output with no geometry. This is the CI
  gate.
- `just report <size>`: print the derived figures, the parts to buy, the
  departures and what cannot be evaluated yet.
- `just test`: export every v0 entry and every printed part to STL and
  require a manifold mesh (about 1 min).
- `just print`: export every printed part to
  `build/print/<size>-<part>-<variant>.stl`, checked like `just test`.
- `python3 scripts/sizing.py`: sizing figures.

Run `just check && just test` before every commit.

## Conventions

These follow the public uwo-fast designs syringe-actuator and
open-source-bioreactor (`docs/design-conventions.md`).

- **Data apart from geometry.** Bought parts are records in
  `cad/purchased/`.
  - One record per real, orderable part. Candidates and alternates are
    further records, each with the reason it exists.
  - Records are key-value lists read through an accessor that **asserts** on
    a missing key or an `undef` value. A value no source states stays
    `undef`; never write a plausible guess.
  - A comment above each record says where its numbers came from: measured
    (date, instrument), datasheet (URL), or reasoned (why).
- **One derivation.** A single `layout()` turns requirements (volume range,
  tip, chosen parts) into one spec per printed part. Part modules read only
  their spec; nothing outside `main.scad` reads a global.
- **Asserts and echoes.** Assert only what cannot be built, with numbers in
  the message. Report departures from guidance as named items in the report
  output, not as asserts.
- **Customizer carries names.** It passes part names and numeric targets,
  never records.
- **No imports that draw.** Files other than entries emit no geometry and no
  echo on import.
- **Evidence labels.** Every figure in the docs carries one of
  [primary] / [secondary] / [derived] / [measured] / [reasoned].

## Constraints

- The parts that set accuracy are bought: the piston, the seals, the stops
  and the sleeve thread. Printed faces locate them and never set the stroke
  (`docs/design.md` §4–5).
- OpenSCAD 2021.01 exits 0 on undefined variables, unknown modules and failed
  asserts. Never trust its exit status; use `just check`.
- OpenSCAD 2021.01 cannot open a relative `-o` path for an input in a
  subdirectory. `scripts/render.sh` passes absolute paths.
- `use <file>` does not bring variables into scope; only functions and
  modules come across.
- Do not name private repositories in this public repo.
