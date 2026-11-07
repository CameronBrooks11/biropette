// Hollow threaded sleeves for the volume setting, with their nuts. The
// plunger rod passes through the bore; the sleeve's lower face is the upper
// stop (docs/design.md section 4.1).
//
// m10x1_lamp: hollow M10 x 1 brass lamp tube. ID 7 mm per a Lampspares
//   listing (https://www.lampspares.co.uk/brass-m10-x-15mm-pottery-nipple/)
//   [secondary]; IDs vary 6.5-9 mm between sellers, so measure the part
//   bought. Fully threaded stock lengths not yet found: length undef.
// ips_1_8_thinwall: 1/8-27 IPS fully threaded thin-wall lamp nipple. OD
//   0.405 in is NPS 1/8 [primary]; ID about 0.30 in per Grand Brass
//   (https://grandbrass.com/nipples/fully-threaded-pipe/18ips-fully-threaded-nipples/18ips-fully-threaded-thin-wall-nipples/)
//   [secondary]. Lengths not yet found: length undef.
// No bought sleeve was found with a bore that clears an 8 mm pin, which is
// why the plunger rod and the piston are separate parts.

function _sleeve(name, thread, pitch, od, id, material) = [
  ["name", name],
  ["thread", thread],
  ["pitch", pitch],
  ["od", od],
  ["id", id],
  ["material", material],
  ["length", undef],
];

sleeves = [
  _sleeve("m10x1_lamp", "M10x1", 1.0, 10, 7.0, "brass"),
  _sleeve("ips_1_8_thinwall", "1/8-27 IPS", 25.4 / 27, 0.405 * 25.4, 0.30 * 25.4, "brass"),
];
