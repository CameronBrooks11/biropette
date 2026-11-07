// Pistons: ground, hardened dowel pins.
//
// [primary] DIN 6325 / ISO 8734 dowel pins are ground to tolerance m6 and
// hardened; the diameters below are standard sizes in that series. The m6
// limits are ISO 286-2 (transcribed; the 6 mm row matches the Ganter
// DIN 6325 datasheet, +0.004/+0.012 mm [secondary]).
// length: undef until stock lengths are checked against a supplier; the
// report gives the minimum length a build needs.
// Hardened alloy steel corrodes; a stainless pin (ISO 8734 grade C1) is the
// alternative to register once a supplier listing is in hand.

// m6 deviations in mm, by nominal diameter band (ISO 286-2).
function m6_limits(d) =
  d <= 3 ? [0.002, 0.008]
  : d <= 6 ? [0.004, 0.012]
  : d <= 10 ? [0.006, 0.015]
  : d <= 18 ? [0.007, 0.018]
  : undef;

function _dowel(d) = [
  ["name", str("dowel_", d)],
  ["standard", "DIN 6325 / ISO 8734"],
  ["d", d],
  ["tolerance", "m6"],
  ["deviation", m6_limits(d)],
  ["material", "hardened steel"],
  ["length", undef],
];

pistons = [_dowel(3), _dowel(4), _dowel(5), _dowel(6), _dowel(8), _dowel(10)];
