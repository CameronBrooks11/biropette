# biropette

Open-source, parametric, 3D-printable micropipette derived from the OpenLabware Biropette for accurate, low-cost liquid handling.

## About

Originally by T Baden, inspired by the [Straw Pipette (K Walus)](https://www.thingiverse.com/thing:64977).

Optimised for fast printing without supports. The pipette works by creating an air-tight chamber below a membrane (e.g. a lab glove) pushed upon by a little piston at the end of a biro-filling (hence “Biro”pette). The accuracy of the system depends on printer precision, and in the best cases tested so far is in the order of ~5 microliters for a “P200”.

Note that key variables are flagged in the OpenSCAD files and linked into the Thingiverse customiser – like this different volume and precision builds can be easily implemented.

## Acknowledgement

Started from at v16 from:

- https://www.thingiverse.com/thing:255519
- https://open-labware.net/projects/biropettes/

and the rack from:

- https://www.thingiverse.com/thing:257254

## Printing

`just prints` renders the pipette's parts A to G and the rack's top beam and
side support into `prints/`, one STL each. The first set was printed on a
Prusa i3 MK3S in PrusaSlicer 2.9.1:

- pipette: 0.4 mm nozzle, profile 0.15mm QUALITY @MK3, Prusa PETG at
  240 °C, bed 90 °C; 0.15 mm layers, 2 perimeters, 5 bottom and 6 top solid
  layers, 15 % gyroid infill, no supports.
- rack: 0.8 mm nozzle, profile 0.40mm QUALITY @0.8 nozzle, Prusa PETG at
  250 °C, bed 90 °C; 0.4 mm layers, 3 perimeters, 3 bottom and 4 top solid
  layers, 25 % adaptive cubic infill, no supports.

## Licence

[CC BY-SA 4.0](LICENSE), the licence of the original it is adapted from:

- "Biropette: customisable, high precision pipette." by BadenLab (Tom Baden),
  <https://www.thingiverse.com/thing:255519>, CC BY-SA 4.0.
- "Rack for Biropettes, Customizable" by BadenLab (Tom Baden),
  <https://www.thingiverse.com/thing:257254>, CC BY-SA 4.0.

Changes, 2025: the OpenSCAD source was reformatted, restructured and renamed;
the rack was revised; the assembly guide was transcribed to Markdown from the
v15 PDF; the models were exported to STL and 3MF. These changes are also
licensed under CC BY-SA 4.0.
