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
// Hollow threaded sleeve that sets the volume
sleeve = "m10x1_lamp"; // [m10x1_lamp, ips_1_8_thinwall]
// Tip brand the cone is made for
tip_brand = "generic"; // [vwr, wards, generic]
// Measuring spring; auto uses the size's default pairing
measuring = "auto"; // [auto, VD-090G, VD-090Z, VD-121A, VD-117Q, VD-115G, VD-122A]
// Blow-out spring; auto uses the size's default pairing
blowout = "auto"; // [auto, VD-124, VD-115K, VD-143E, VD-150C, VD-153, VD-145H-10]
// What to produce
part = "report"; // [report]

L = layout(size, piston, oring, sleeve, tip_brand, measuring, blowout);

if (part == "report") report(L);
else assert(false, str("unknown part '", part, "'"));
