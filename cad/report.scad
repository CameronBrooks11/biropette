// report(L): print a layout() as plain lines. Draws nothing.

include <lib/struct.scad>

function _r(x, n = 3) = is_undef(x) ? "undef" : round(x * pow(10, n)) / pow(10, n);
function _pct(x) = str(_r(100 * x, 2), " %");

module report(L) {
  p = get(L, "piston");
  th = get(L, "spindle");
  t = get(L, "tip");
  o = known(L, "oring") ? get(L, "oring") : undef; // undef: none fits, reported below
  iso = get(L, "iso");
  echo(str("=== ", get(L, "name"), " ", get(L, "range_ul")[0], "-", get(L, "range_ul")[1],
           " uL, graduation ", get(L, "increment_ul"), " uL ==="));
  echo(str("ISO 8655-2 at nominal: systematic +/-", iso[0], " uL, random ", iso[1], " uL"));
  echo(str("piston: ", get(p, "standard"), " d", get(L, "d"), " ", get(p, "tolerance"),
           " (", get(p, "deviation")[0], "/+", get(p, "deviation")[1], " mm), ", get(p, "material")));
  echo(str("stroke: ", _r(get(L, "stroke")), " mm at maximum, ", _r(get(L, "stroke_min")),
           " mm at minimum, blow-out ", _r(get(L, "blowout")), " mm"));
  echo(str("stroke s.d. that alone uses the random limit: ", _r(get(L, "stroke_sd_limit")), " mm"));
  echo(str("scale diameter (m6 band middle): ", _r(get(L, "d_scale"), 4), " mm; gain left by the band: +/-",
           _pct(get(L, "gain_halfspread")), " = +/-",
           _r(get(L, "gain_halfspread") * get(L, "range_ul")[1]), " uL at nominal; a scale built on nominal d would deliver ",
           _pct(get(L, "gain_if_nominal")), " more than set"));
  if (is_undef(o))
    echo("piston seal: no registered O-ring fits");
  else
    echo(str("piston seal: ", get(o, "standard"), " ", get(o, "material"), ", stretch ",
             _pct(get(L, "oring_stretch")), "; gland groove d", _r(get(L, "gland_groove_d")),
             " x ", _r(get(L, "gland_w")), " wide (squeeze ", _pct(get(L, "squeeze")), ")"));
  echo(str("spindle: ", get(th, "name"), "x", get(th, "pitch"), " ", get(th, "material"), ", ",
           _r(get(L, "ul_per_turn")), " uL per turn, ", _r(get(L, "turns"), 1),
           " turns over the range, graduations ", _r(get(L, "grad_spacing")), " mm apart on a d",
           get(L, "knob_d"), " knob"));
  echo(str("tip: ", get(t, "name"), len(get(L, "tip_missing")) > 0
           ? str(" - not measured: ", get(L, "tip_missing")) : ""));
  echo(str("BUY: dowel pin d", get(L, "d"), " ", get(p, "tolerance"), ", length ",
           known(L, "pin_min_length")
             ? str(">= ", _r(get(L, "pin_min_length"), 1), " mm (next stock length up)")
             : "not known until a seal is chosen"));
  if (!is_undef(o))
    echo(str("BUY: O-ring ", get(o, "standard"), " ", get(o, "material")));
  echo(str("BUY: ", get(th, "name"), " ", get(th, "material"), " spindle (form decided with the geometry)"));
  for (x = get(L, "departures")) echo(str("DEPARTURE: ", x));
  for (x = get(L, "cannot_evaluate")) echo(str("CANNOT EVALUATE: ", x));
}
