// Fasteners, identified by standard rather than SKU.
//
// ISO 4762 socket head cap screws [primary, ISO 4762]: head diameter dk and
// head height k (maximum), preferred lengths from the standard's series.
// clearance: ISO 273 medium series [primary]. pilot: the ISO 2306 tap drill
// [primary], used here as the hole a screw self-taps into a print
// ([reasoned]: the usual practice for printed parts; no insert needed in a
// test rig).

function _shcs(d, dk, k, clearance, pilot, lengths) = [
  ["name", str("M", d)],
  ["standard", "ISO 4762"],
  ["d", d],
  ["dk", dk],
  ["k", k],
  ["clearance", clearance],
  ["pilot", pilot],
  ["lengths", lengths],
  ["material", "stainless A2"],
];

fasteners = [
  _shcs(3, 5.5, 3, 3.4, 2.5, [6, 8, 10, 12, 16, 20, 25, 30]),
  _shcs(4, 7, 4, 4.5, 3.3, [6, 8, 10, 12, 16, 20, 25, 30]),
];
