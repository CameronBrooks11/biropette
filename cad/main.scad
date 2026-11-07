// biropette v1: adjustable single-channel air-displacement pipette.
//
// The only file that draws. Requirements are chosen here by name; every
// dimension comes from layout() in layout.scad. Design basis:
// docs/design.md.

include <layout.scad>
include <report.scad>

/* [Build] */
// Pipette size
size = "P200"; // [P200, P1000]
// Piston pin; auto picks the one nearest the size's stroke target
piston = "auto"; // [auto, dowel_3, dowel_4, dowel_5, dowel_6, dowel_8, dowel_10]
// Piston O-ring; auto picks a registered one that fits the pin
oring = "auto"; // [auto, as568_007, as568_008, as568_011, as568_012, metric_4x1.5, metric_8x1.5]
// Volume-setting spindle thread
spindle = "M4"; // [M3, M4, M5, M6]
// Tip brand the cone is made for
tip_brand = "generic"; // [vwr, wards, generic]
// Volume knob diameter (mm) carrying the graduations
knob_d = 16;
// What to produce
part = "report"; // [report]

L = layout(size, piston, oring, spindle, tip_brand, knob_d);

if (part == "report") report(L);
else assert(false, str("unknown part '", part, "'"));
