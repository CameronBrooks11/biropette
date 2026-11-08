// ISO 8655-2 maximum permissible errors, single-channel piston pipettes, at
// nominal volume, in uL. The pipette and its tip are tested as one system.
//
// [primary] Gilson Pipetman P user's guide (2009), ISO column (2002 edition).
// [secondary] Eppendorf customer information on ISO 8655-2:2022: these rows
// are unchanged in the 2022 edition. At 50 % and 10 % settings the limits
// stay at these uL values [secondary]. Confirm both from the standard text.

iso8655_single = [
  // nominal, systematic (+/-), random
  [20, 0.20, 0.10],
  [100, 0.80, 0.30],
  [200, 1.6, 0.6],
  [1000, 8.0, 3.0],
];

function iso8655_limits(nominal) =
  let(m = [for (r = iso8655_single) if (r[0] == nominal) r])
  assert(len(m) == 1, str("no ISO 8655-2 row transcribed for ", nominal, " uL"))
  [m[0][1], m[0][2]];
