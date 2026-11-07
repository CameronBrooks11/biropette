# biropette

Open-source, parametric, 3D-printable micropipette derived from the OpenLabware Biropette for accurate, low-cost liquid handling.

## About

Originally by T Baden, inspired by the [Straw Pipette (K Walus)](https://www.thingiverse.com/thing:64977).

Optimised for fast printing without supports. The pipette works by creating an air-tight chamber below a membrane (e.g. a lab glove) pushed upon by a little piston at the end of a biro-filling (hence “Biro”pette). The accuracy of the system depends on printer precision, and in the best cases tested so far is in the order of ~5 microliters for a “P200”.

Note that key variables are flagged in the OpenSCAD files and linked into the Thingiverse customiser – like this different volume and precision builds can be easily implemented.

## Status

v1 is being redesigned as an adjustable air-displacement pipette, with a
bought piston and seals, aimed at ISO 8655-2. Single-channel P200 and P1000
come first. The design basis is in [docs/design.md](docs/design.md). The
original design is kept unchanged in [cad/v0/](cad/v0/).

## Repository layout

- `cad/v0/`: the original Biropette and its print files (frozen)
- `docs/`: design basis and the original guide
- `scripts/`: render gate and sizing calculations

`just check` renders the models (OpenSCAD 2021.01 or newer) and `just test`
exports them to STL.

## Acknowledgement

Started from at v16 from:

- https://www.thingiverse.com/thing:255519
- https://open-labware.net/projects/biropettes/

and the rack from:

- https://www.thingiverse.com/thing:257254
