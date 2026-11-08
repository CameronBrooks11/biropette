// Plunger forces and seal friction.
//
// Measured commercial pipettes [primary]:
// - Lichty, Janowitz & Rempel 2011, Work 39:177, Table 1: 200 uL pipettes
//   need 4.2-7.0 N to the first stop and 11.8-32.4 N at blow-out.
// - Asundi, Bach & Rempel 2005, Human Factors: a Gilson P-1000 needs 8.7 N
//   to the first stop, about 19 N to enter blow-out and 20-35 N in it.
//   Mean thumb maximum was 101.3 N.
// - Rainin/Erickson 2001 (vendor) applies a 20 % of maximum rule: 1.6 kg,
//   about 15.7 N, from women's pinch strength.
//
// Seal friction [primary, Parker O-ring handbook ORD 5700, section 5.11]:
// rod-seal running friction F = f_c x pi x d. f_c = 0.123 N/mm at 10 %
// squeeze, 70 Shore A (Parker's worked example); about 0.23 N/mm at 20 %
// (read by eye from Fig. 5-9, an estimate). Break-out after a long rest is
// up to 3x running. Basis: lubricated hydraulic service, so conservative
// for a 1.5 mm cross-section.

friction_fc = [[0.10, 0.123], [0.20, 0.23]]; // [squeeze, N per mm of circumference]
breakout_factor = 3;

// Planning squeeze for the dynamic seal. [reasoned] The pressure across it
// is about 0.4 kPa (40 mm of water), so friction, not leakage, is the
// limit; 10 % keeps friction near commercial forces. The real value is
// tuned on the seal rig and replaces this.
planning_squeeze = 0.10;

// [reasoned] the measuring spring must still beat running friction by this
// factor at the upper stop, or the piston stops short of it and the
// pipette aspirates less than set.
return_margin = 2;

// [reasoned] the step in thumb force from the first stop to blow-out must
// be felt; Asundi's P-1000 went from 8.7 N to about 19 N.
blowout_step_min = 3;

function _lerp_fc(s, t) =
  s <= t[0][0] ? t[0][1]
  : s >= t[len(t) - 1][0] ? t[len(t) - 1][1]
  : t[0][1] + (s - t[0][0]) * (t[1][1] - t[0][1]) / (t[1][0] - t[0][0]);

function seal_friction(d, squeeze) = _lerp_fc(squeeze, friction_fc) * PI * d;
