// Pipette sizes: the requirements a build starts from.
//
// range_ul and increment_ul: [primary] Gilson Pipetman P and Eppendorf
//   Research plus manuals (P200: 20-200 uL in 0.2 uL steps; P1000: 100-1000
//   uL, Eppendorf 1 uL / Gilson 2 uL steps; the coarser one is taken).
// stroke_target: [reasoned] the stroke the piston choice aims for. A longer
//   stroke gives more travel per uL, so a given stroke error costs less
//   volume; it is bounded by thumb travel. A 20 uL patent example uses 16 mm
//   (US9221046B2). P1000 aims longer so that an 8 mm pin fits.
// blowout_fraction: [reasoned] blow-out travel as a share of the full
//   stroke; the same patent example uses 5 mm on 16 mm.
// knob_d: [reasoned] large enough that graduations are at least
//   scale_spacing_min apart with a 1 mm pitch sleeve.
// first_stop_max_N: [primary] the highest first-stop force measured on a
//   commercial pipette of the size (P200: Lichty 2011, 7.0 N; P1000:
//   Asundi 2005, 8.7 N). blowout_max_N: [primary, vendor] the 20 % rule,
//   15.7 N (data/ergonomics.scad).
// measuring_rest_N / blowout_preload_N: [reasoned] targets the springs are
//   fitted to; measuring_spring / blowout_spring are the default pairing
//   (purchased/springs.scad), picked to meet them.

size_p200 = [
  ["name", "P200"],
  ["range_ul", [20, 200]],
  ["increment_ul", 0.2],
  ["stroke_target", 16],
  ["blowout_fraction", 0.3],
  ["knob_d", 22],
  ["first_stop_max_N", 7.0],
  ["blowout_max_N", 15.7],
  ["measuring_rest_N", 3.0],
  ["blowout_preload_N", 9.0],
  ["measuring_spring", "VD-090G"],
  ["blowout_spring", "VD-124"],
];

size_p1000 = [
  ["name", "P1000"],
  ["range_ul", [100, 1000]],
  ["increment_ul", 2],
  ["stroke_target", 18],
  ["blowout_fraction", 0.3],
  ["knob_d", 22],
  ["first_stop_max_N", 8.7],
  ["blowout_max_N", 15.7],
  ["measuring_rest_N", 6.0],
  ["blowout_preload_N", 12.0],
  ["measuring_spring", "VD-115G"],
  ["blowout_spring", "VD-150C"],
];

sizes = [size_p200, size_p1000];

// The plunger rod passes through the sleeve and carries the collar and the
// piston pin. [reasoned] 4 mm stainless: clears a 7 mm sleeve bore, takes
// the 4 mm collar, and a set screw bites it.
rod_d = 4;

// [reasoned] guidance bands; leaving one is reported, not refused.
stroke_band = [12, 20]; // mm: see docs/design.md section 5
scale_spacing_min = 1.0; // mm between adjacent graduations, to be readable
sleeve_engagement = 10; // mm of thread in the nut: one diameter of M10
sleeve_knob_grip = 8; // mm of sleeve inside the knob clamp
