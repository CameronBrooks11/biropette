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

size_p200 = [
  ["name", "P200"],
  ["range_ul", [20, 200]],
  ["increment_ul", 0.2],
  ["stroke_target", 16],
  ["blowout_fraction", 0.3],
];

size_p1000 = [
  ["name", "P1000"],
  ["range_ul", [100, 1000]],
  ["increment_ul", 2],
  ["stroke_target", 18],
  ["blowout_fraction", 0.3],
];

sizes = [size_p200, size_p1000];

// [reasoned] guidance bands; leaving one is reported, not refused.
stroke_band = [12, 20]; // mm: see docs/design.md section 5
scale_spacing_min = 1.0; // mm between adjacent graduations, to be readable
