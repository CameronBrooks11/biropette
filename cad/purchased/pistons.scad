// Pistons: ground, hardened dowel pins.
//
// [primary] DIN 6325 / ISO 8734 dowel pins are ground to tolerance m6 and
// hardened; the diameters below are standard sizes in that series. The m6
// limits are ISO 286-2 (transcribed; the 6 mm row matches the Ganter
// DIN 6325 datasheet, +0.004/+0.012 mm [secondary]).
// lengths: stock lengths seen in supplier listings [secondary], read
// 2026-11-07. d4: 4x36 Fusion Fixings, 4x40 eHorst 1055751 / Kent / Ameco;
// Ganter's range for d4 ends at 40. d8: 8x50 Kent, 8x60 Olander, 8x70
// Ameco, 8x80 eHorst 1055776. undef where no listing has been checked.
// Hardened alloy steel corrodes; a stainless pin (ISO 8734 grade C1) is the
// alternative to register once a supplier listing is in hand.

// m6 deviations in mm, by nominal diameter band (ISO 286-2).
function m6_limits(d) =
  d <= 3 ? [0.002, 0.008]
  : d <= 6 ? [0.004, 0.012]
  : d <= 10 ? [0.006, 0.015]
  : d <= 18 ? [0.007, 0.018]
  : undef;

function _dowel(d, lengths = undef) = [
  ["name", str("dowel_", d)],
  ["standard", "DIN 6325 / ISO 8734"],
  ["d", d],
  ["tolerance", "m6"],
  ["deviation", m6_limits(d)],
  ["material", "hardened steel"],
  ["lengths", lengths],
];

pistons = [
  _dowel(3),
  _dowel(4, [36, 40]),
  _dowel(5),
  _dowel(6),
  _dowel(8, [50, 60, 70, 80]),
  _dowel(10),
];
