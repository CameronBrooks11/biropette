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

// rig_report(s): print a seal_rig() spec: what to print, drill and buy, and
// the numbers the test procedure needs.
module rig_report(s) {
  o = get(s, "oring");
  radial = get(s, "variant") == "radial";
  echo(str("=== ", get(s, "name"), " ==="));
  echo(str("body d", _r(get(s, "body_d"), 1), " x ", _r(get(s, "body_h"), 1), " mm; cap ", get(s, "cap_t"), " mm",
           radial ? "" : str(" with a ", _r(get(s, "spigot_h"), 2), " mm spigot")));
  echo(str("DRILL: guide bore to ", _r(get(s, "guide_d"), 2), " mm"));
  if (radial)
    echo(str("MEASURE: seal pocket, printed at ", _r(get(s, "pocket_d"), 2), " mm; squeeze = 1 - (pocket - ",
             get(s, "d"), ") / ", 2 * get(o, "cs"), " (", _pct(planning_squeeze), " at nominal)"));
  if (!radial)
    echo(str("SET: cap gap ", _r(get(s, "cap_gap"), 2), " mm = no compression; closing it by x mm compresses the ",
             get(o, "cs"), " mm ring by x (", _r(100 / get(o, "cs"), 1), " % per mm)"));
  echo(str("pin: ", get(s, "pin"), " mm stock (rig needs ", _r(get(s, "pin_need"), 1), ")"));
  echo(str("leak test: plug the port, press the pin ", _r(get(s, "leak_dx"), 2), " mm from its highest position for ",
           get(s, "leak_kpa"), " kPa; the scale should then read ", _r(get(s, "leak_force") * 1000 / 9.807, 1),
           " g above the friction reading (", _r(get(s, "v_air"), 0), " uL of air)"));
  echo(str("BUY: O-ring ", get(o, "standard"), "; O-ring 4 x 1.5 mm (port plug); 2 x ISO 4762 M3x",
           get(s, "screw_len"), "; 1 x ISO 4762 M4x", get(s, "plug_len")));
}
