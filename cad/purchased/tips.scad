// Disposable tips used by the partner labs.
//
// No standard fixes tip geometry, so every dimension is [measured] and
// stays undef until it has been (method: docs/design.md section 6). A
// record gains numbers only with the date and the instrument in the
// comment above it.
//
// Fields, in mm: collar_od, id_mouth, id_4 and id_8 (inner diameter 4 and
// 8 mm into the mouth), length. capacity_ul is the size the box is sold as.

tip_dims = ["collar_od", "id_mouth", "id_4", "id_8", "length"];

function _tip(brand, capacity) = [
  ["name", str(brand, "_", capacity)],
  ["brand", brand],
  ["capacity_ul", capacity],
  ["part_number", undef],
  ["collar_od", undef],
  ["id_mouth", undef],
  ["id_4", undef],
  ["id_8", undef],
  ["length", undef],
];

tips = [
  _tip("vwr", 200),
  _tip("vwr", 1000),
  _tip("wards", 200),
  _tip("wards", 1000),
  _tip("generic", 200),
  _tip("generic", 1000),
];
