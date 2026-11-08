// Compression springs: the measuring spring and the blow-out spring.
//
// [primary] Gutekunst stock catalogue, stainless 1.4310, rows read
// 2026-11-07 from https://www.federnshop.com/en/products/compression_springs/<item>.html
// (lower-case item). d wire, De outer diameter, Dd largest pin the spring
// fits over, L0 free length, Ln minimum length in static use (Gutekunst's
// figure, above solid length), Fn force at Ln, R rate. All in mm and N.
// Candidates were filtered against the force targets in data/ergonomics.scad.

function _spring(item, d, De, Dd, L0, Ln, Fn, R) = [
  ["name", item],
  ["maker", "Gutekunst"],
  ["material", "1.4310 stainless"],
  ["d", d],
  ["De", De],
  ["Dd", Dd],
  ["L0", L0],
  ["Ln", Ln],
  ["Fn", Fn],
  ["R", R],
];

springs = [
  // measuring springs (light, long)
  _spring("VD-090G", 0.55, 9.0, 7.3, 61.6, 8.7, 7.39, 0.140),
  _spring("VD-090Z", 0.63, 10.5, 8.7, 72.4, 10.05, 9.41, 0.151),
  _spring("VD-121A", 0.8, 10.8, 8.7, 66.0, 21.35, 8.65, 0.194),
  _spring("VD-117Q", 0.8, 12.0, 9.8, 84.0, 16.66, 12.726, 0.189),
  _spring("VD-115G", 0.7, 12.0, 10.0, 84.6, 11.31, 11.232, 0.153),
  _spring("VD-122A", 0.8, 10.8, 8.7, 96.5, 25.62, 11.3, 0.159),
  // blow-out springs (stiff, short)
  _spring("VD-124", 0.8, 8.8, 6.7, 21.5, 7.1, 18.327, 1.273),
  _spring("VD-115K", 0.7, 7.5, 5.6, 21.8, 6.18, 19.0, 1.215),
  _spring("VD-143E", 0.9, 9.5, 7.2, 27.0, 10.15, 20.3, 1.203),
  _spring("VD-150C", 1.0, 12.5, 10.0, 32.0, 9.14, 23.912, 1.046),
  _spring("VD-153", 1.0, 11.0, 8.5, 39.0, 12.63, 27.151, 1.029),
  _spring("VD-145H-10", 1.0, 14.0, 11.3, 30.0, 6.74, 26.5, 1.138),
];
