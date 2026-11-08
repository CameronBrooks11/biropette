# Licensing

This document states which licence covers which parts of this repository.
[What applies where](#what-applies-where) is the operative section. The full
licence texts in [`LICENSES/`](LICENSES/) are the binding terms.

The repository holds two bodies of work under different terms:

- **v0**, the original Biropette by BadenLab, which this repository adapts
  under its original licence, Creative Commons Attribution-ShareAlike 4.0
  (`CC-BY-SA-4.0`).
- **v1**, the redesign, which is new work. Its software is under the GNU
  General Public License v3.0 or later (`GPL-3.0-or-later`,
  [`LICENSES/GPL-3.0-or-later.txt`](LICENSES/GPL-3.0-or-later.txt)). Its
  hardware is under the CERN Open Hardware Licence Version 2, Strongly
  Reciprocal (`CERN-OHL-S-2.0`,
  [`LICENSES/CERN-OHL-S-2.0.txt`](LICENSES/CERN-OHL-S-2.0.txt)).

The root [`LICENSE`](LICENSE) is a copy of the GPL text. GitHub reports only
one licence per repository and reads that file, so this document is where the
full picture lives.

## What applies where

| Path | Licence |
| --- | --- |
| `cad/v0/`, `docs/v0/`, `assets/images/` | `CC-BY-SA-4.0` (see [v0](#v0-the-original-biropette)) |
| `cad/` (other than `cad/v0/`): parametric CAD source and its data | `GPL-3.0-or-later` **and** `CERN-OHL-S-2.0` |
| `cad/` (other than `cad/v0/`): geometry (STL, STEP, 3MF), drawings and bills of materials generated from that source | `CERN-OHL-S-2.0` |
| `scripts/`, `justfile` and other build tooling | `GPL-3.0-or-later` |
| `docs/` (other than `docs/v0/`), `README.md`, `AGENTS.md` | `GPL-3.0-or-later` and `CERN-OHL-S-2.0`, at your option |

Parametric CAD source is granted under both licences. A licensee who makes a
product from the geometry can then satisfy CERN-OHL-S-2.0 §4, which requires
the Complete Source: the design in its preferred form for modification,
meaning the source rather than the mesh.

## v0: the original Biropette

The files under `cad/v0/`, `docs/v0/` and `assets/images/` are adapted from:

- "Biropette: customisable, high precision pipette." by BadenLab (Tom Baden),
  <https://www.thingiverse.com/thing:255519>.
- "Rack for Biropettes, Customizable" by BadenLab (Tom Baden),
  <https://www.thingiverse.com/thing:257254>.

Both are licensed under CC BY-SA 4.0,
<https://creativecommons.org/licenses/by-sa/4.0/>.

**Changes, 2025:**

- The OpenSCAD source was reformatted, restructured and renamed.
- The rack was revised.
- The assembly guide was transcribed to Markdown from the v15 PDF.
- The models were exported to STL and 3MF.

These adaptations are licensed under CC BY-SA 4.0. The v1 redesign does not
reuse v0 geometry, code or text; it credits the Biropette as its origin.

## Third-party components

Anything vendored or included keeps its own licence, unaffected by this
document.

| Component | Licence |
| --- | --- |
| Biropette and Biropette rack (BadenLab), adapted in `cad/v0/`, `docs/v0/`, `assets/images/` | `CC-BY-SA-4.0` |

## Contributions

"Contribution" means any work of authorship intentionally submitted for
inclusion in this project, such as a pull request, patch, commit, issue or
other communication, excluding anything conspicuously marked "Not a
Contribution".

Unless you state otherwise, contributions you submit are licensed under
whichever of the licences above covers the files they touch, with no
additional terms. By submitting a contribution you represent that you have
the right to license it on those terms.

## Patents

Both GPL-3.0 (section 11) and CERN-OHL-S-2.0 (section 7) contain express
patent provisions. Review them before using, modifying or distributing this
project.

## Disclaimer of warranty and liability

This summarises terms in the licences themselves: GPL-3.0 sections 15–17,
CERN-OHL-S-2.0 section 6 and CC BY-SA 4.0 section 5.

THIS PROJECT, INCLUDING ALL SOFTWARE AND HARDWARE DESIGNS, IS PROVIDED "AS IS"
WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
NON-INFRINGEMENT.

TO THE EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL THE AUTHORS,
CONTRIBUTORS, OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THIS PROJECT.

### Additional disclaimer

This is not a summary of any of the licences. It is an additional disclaimer
of the kind GPL-3.0 section 7(a) permits, offered alongside them:

HARDWARE DESIGNS HERE HAVE NOT BEEN INDEPENDENTLY VERIFIED OR CERTIFIED FOR
SAFETY OR REGULATORY COMPLIANCE. ANY PHYSICAL PRODUCT MANUFACTURED FROM THEM IS
PRODUCED ENTIRELY AT YOUR OWN RISK. TO THE EXTENT PERMITTED BY APPLICABLE LAW,
THE AUTHORS AND CONTRIBUTORS ARE NOT RESPONSIBLE FOR ANY PERSONAL INJURY,
PROPERTY DAMAGE, OR OTHER HARM RESULTING FROM THE USE OR MANUFACTURE OF
PRODUCTS BASED ON THEM.

## Trademarks

None of the licences grants trademark rights. This project does not grant
permission to use the names, trademarks or logos of the FAST research group,
of BadenLab or of the project's contributors, except as needed to describe the
project's origin.

## Precedence

Where the commentary in this document and the full licence texts conflict,
the full texts prevail. The table under "What applies where" is not
commentary: it is the statement of which files are made available under which
terms.
