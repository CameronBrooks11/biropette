// report(L): print a layout() as plain lines. Draws nothing.

include <lib/struct.scad>

function _r(x, n = 3) = is_undef(x) ? "undef" : round(x * pow(10, n)) / pow(10, n);
function _pct(x) = str(_r(100 * x, 2), " %");

module report(L) {
  p = get(L, "piston");
  sl = get(L, "sleeve");
  t = get(L, "tip");
  o = known(L, "oring") ? get(L, "oring") : undef; // undef: none fits, reported below
  ms = get(L, "measuring_spring");
  bs = get(L, "blowout_spring");
  mf = get(L, "measuring_fit");
  bf = get(L, "blowout_fit");
  c = get(L, "collar");
  iso = get(L, "iso");
  v = get(L, "range_ul");

  echo(str("=== ", get(L, "name"), " ", v[0], "-", v[1], " uL, graduation ", get(L, "increment_ul"), " uL ==="));
  echo(str("ISO 8655-2 at nominal: systematic +/-", iso[0], " uL, random ", iso[1], " uL"));

  echo("-- piston and seal");
  echo(str("piston: ", get(p, "standard"), " d", get(L, "d"), " ", get(p, "tolerance"),
           " (", get(p, "deviation")[0], "/+", get(p, "deviation")[1], " mm), ", get(p, "material")));
  echo(str("stroke: ", _r(get(L, "stroke")), " mm at maximum, ", _r(get(L, "stroke_min")),
           " mm at minimum, blow-out ", _r(get(L, "blowout")), " mm"));
  echo(str("stroke s.d. that alone uses the random limit: ", _r(get(L, "stroke_sd_limit")), " mm"));
  echo(str("scale diameter (m6 band middle): ", _r(get(L, "d_scale"), 4), " mm; gain left by the band: +/-",
           _pct(get(L, "gain_halfspread")), " = +/-", _r(get(L, "gain_halfspread") * v[1]),
           " uL at nominal; a scale built on nominal d would deliver ", _pct(get(L, "gain_if_nominal")),
           " more than set"));
  if (is_undef(o))
    echo("seal: no registered O-ring fits");
  else
    echo(str("seal: ", get(o, "standard"), " ", get(o, "material"), ", stretch ", _pct(get(L, "oring_stretch")),
             "; radial gland d", _r(get(L, "gland_groove_d")), " x ", _r(get(L, "gland_w")),
             " wide at planning squeeze ", _pct(get(L, "squeeze"))));
  echo(str("seal friction (planning estimate): ", _r(get(L, "friction"), 2), " N running, up to ",
           _r(get(L, "friction") * breakout_factor, 2), " N break-out after a long rest"));

  echo("-- volume setting");
  echo(str("sleeve: ", get(sl, "thread"), " ", get(sl, "material"), ", bore ", get(sl, "id"), " mm; ",
           _r(get(L, "ul_per_turn")), " uL per turn, ", _r(get(L, "turns"), 1), " turns over the range"));
  echo(str("scale: graduations ", _r(get(L, "grad_spacing")), " mm apart on a d", get(L, "knob_d"), " knob"));
  echo(str("plunger rod d", get(L, "rod_d"), " stainless through the sleeve; stop collar ", get(c, "name"),
           " (OD ", get(c, "od"), ", ", get(c, "width"), " wide)"));

  echo("-- springs and thumb force");
  echo(str("measuring spring ", get(ms, "name"), ": fitted ", _r(mf[0], 1), " -> ", _r(mf[1], 1),
           " mm, ", _r(get(L, "measuring_fit")[2] - get(ms, "R") * get(L, "stroke"), 2), " -> ", _r(mf[2], 2),
           " N; bore >= ", _r(get(L, "measuring_bore"), 1), " mm"));
  echo(str("blow-out spring ", get(bs, "name"), ": fitted ", _r(bf[0], 1), " -> ", _r(bf[1], 1),
           " mm, preload ", _r(bf[2] - get(bs, "R") * get(L, "blowout"), 2), " -> ", _r(bf[2], 2),
           " N; bore >= ", _r(get(L, "blowout_bore"), 1), " mm"));
  echo(str("thumb: ", _r(get(L, "thumb_first"), 1), " N at the first stop, ", _r(get(L, "thumb_blow_entry"), 1),
           " N to enter blow-out, ", _r(get(L, "thumb_blow_end"), 1), " N at the end"));

  echo("-- tip");
  echo(str("tip: ", get(t, "name"), len(get(L, "tip_missing")) > 0
           ? str(" - not measured: ", get(L, "tip_missing")) : ""));

  echo("-- buy");
  echo(str("BUY: dowel pin d", get(L, "d"), " ", get(p, "tolerance"), ", length ",
           !known(L, "pin_min_length") ? "not known until a seal is chosen"
           : known(L, "pin_stock") ? str(get(L, "pin_stock"), " mm (needs >= ", _r(get(L, "pin_min_length"), 1), ")")
           : str(">= ", _r(get(L, "pin_min_length"), 1), " mm (no registered stock length)")));
  if (!is_undef(o))
    echo(str("BUY: O-ring ", get(o, "standard"), " ", get(o, "material")));
  echo(str("BUY: sleeve ", get(sl, "name"), ", length >= ", _r(get(L, "sleeve_min_length"), 1),
           " mm, and a ", get(sl, "thread"), " nut"));
  echo(str("BUY: collar ", get(c, "name"), "; rod d", get(L, "rod_d"), " stainless"));
  echo(str("BUY: springs ", get(ms, "maker"), " ", get(ms, "name"), " and ", get(bs, "name")));

  for (x = get(L, "departures")) echo(str("DEPARTURE: ", x));
  for (x = get(L, "cannot_evaluate")) echo(str("CANNOT EVALUATE: ", x));
}
