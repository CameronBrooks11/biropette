// O-rings for the piston seal: a static gland in the body, the piston
// slides through the O-ring (a rod seal).
//
// AS568 rows: [primary] SAE AS568 standard sizes, nominal inch dimensions
//   converted to mm (ID -007 = 0.145 in, -008 = 0.176 in, -011 = 0.301 in,
//   -012 = 0.364 in; cross-section 0.070 in).
// metric rows: [secondary] common commodity sizes sold as "ID x CS NBR 70";
//   confirm against the supplier listing before ordering.
// Material NBR 70 Shore A is the commodity default [reasoned].

function _oring(name, standard, id, cs) = [
  ["name", name],
  ["standard", standard],
  ["id", id],
  ["cs", cs],
  ["material", "NBR 70"],
];

orings = [
  _oring("as568_007", "AS568-007", 0.145 * 25.4, 0.070 * 25.4),
  _oring("as568_008", "AS568-008", 0.176 * 25.4, 0.070 * 25.4),
  _oring("as568_011", "AS568-011", 0.301 * 25.4, 0.070 * 25.4),
  _oring("as568_012", "AS568-012", 0.364 * 25.4, 0.070 * 25.4),
  _oring("metric_4x1.5", "4 x 1.5 mm", 4, 1.5),
  _oring("metric_8x1.5", "8 x 1.5 mm", 8, 1.5),
];

// Rod-seal guidance [primary, Parker O-ring handbook, dynamic sealing]:
// squeeze of a reciprocating seal 15-25 % (0.070 in cross-section row).
// stretch = (rod - id) / id. [reasoned] band: a rod seal should not be
// slack on the rod (buckling, leak) nor stretched far (thinning, lower
// squeeze); 0-5 % pending a cited figure.
oring_squeeze_band = [0.15, 0.25];
oring_stretch_band = [0.0, 0.05];
oring_fill_max = 0.85; // [reasoned] gland fill below this leaves room to swell
