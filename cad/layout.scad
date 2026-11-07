// layout(): every derived dimension and figure, computed once.
//
// Requirements come in as records and names; out comes one record. Asserts
// stop only what cannot be built. Departures from guidance are returned as
// names in "departures" and printed by the report.
//
// Include this file (not use): the registries it reads are variables.

include <lib/struct.scad>
include <data/sizes.scad>
include <data/iso8655.scad>
include <purchased/pistons.scad>
include <purchased/orings.scad>
include <purchased/threads.scad>
include <purchased/tips.scad>

// [reasoned] constants, one line of reason each.
fill_target = 0.75; // gland fill to design to: under oring_fill_max with room for tolerance
guide_ratio = 1.5; // guided length / pin diameter: below about 1.5 a sliding pin tends to cock and jam
hold_ratio = 1.5; // length / diameter of pin held in the plunger: a press fit needs engagement

function area(d) = PI * d * d / 4;

function _stroke(size, p) = get(size, "range_ul")[1] / area(get(p, "d"));

// The pin whose full stroke lands nearest the size's stroke target.
function piston_for(size) =
  let(
    t = get(size, "stroke_target"),
    err = [for (p = pistons) abs(_stroke(size, p) - t)],
    best = [for (i = [0:1:len(pistons) - 1]) if (err[i] == min(err)) i][0]
  ) pistons[best];

function _stretch(o, rod) = (rod - get(o, "id")) / get(o, "id");

// The registered O-ring with the least stretch on the pin inside the band;
// undef when none is inside it.
function oring_for(rod) =
  let(
    ok = [for (o = orings) let(s = _stretch(o, rod))
      if (s >= oring_stretch_band[0] && s <= oring_stretch_band[1]) [s, o]],
    best = len(ok) == 0 ? undef : [for (c = ok) if (c[0] == min([for (k = ok) k[0]])) c[1]][0]
  ) best;

// The smallest tip of the brand that holds the full volume.
function tip_for(brand, v_max) =
  let(
    fits = [for (t = tips) if (get(t, "brand") == brand && get(t, "capacity_ul") >= v_max) t],
    caps = [for (t = fits) get(t, "capacity_ul")]
  )
  assert(len(fits) > 0, str("no registered ", brand, " tip holds ", v_max, " uL"))
  [for (t = fits) if (get(t, "capacity_ul") == min(caps)) t][0];

function layout(size_name, piston = "auto", oring = "auto", spindle = "M4",
                tip_brand = "generic", knob_d = 16) =
  let(
    size = by_name(sizes, size_name),
    v = get(size, "range_ul"),
    inc = get(size, "increment_ul"),
    p = piston == "auto" ? piston_for(size) : by_name(pistons, piston),
    d = get(p, "d"),
    a = area(d),
    stroke = v[1] / a,
    stroke_min = v[0] / a,
    blowout = get(size, "blowout_fraction") * stroke,
    iso = iso8655_limits(v[1]),

    // The pin's m6 band is a gain error: V scales with d^2. Building the
    // scale on the band's middle leaves +/- half of it.
    dev = get(p, "deviation"),
    d_scale = d + (dev[0] + dev[1]) / 2,
    gain_halfspread = 2 * (dev[1] - dev[0]) / 2 / d_scale,
    gain_if_nominal = pow((d + (dev[0] + dev[1]) / 2) / d, 2) - 1,

    o = oring == "auto" ? oring_for(d) : by_name(orings, oring),
    o_ok = !is_undef(o),
    cs = o_ok ? get(o, "cs") : undef,
    squeeze = (oring_squeeze_band[0] + oring_squeeze_band[1]) / 2,
    gland_depth = o_ok ? cs * (1 - squeeze) : undef,
    gland_w = o_ok ? area(cs) / (gland_depth * fill_target) : undef,

    th = by_name(threads, spindle),
    pitch = get(th, "pitch"),
    ul_per_turn = a * pitch,
    turns = (stroke - stroke_min) / pitch,
    grad_spacing = PI * knob_d * inc / ul_per_turn,

    pin_min = o_ok ? stroke + blowout + gland_w + (guide_ratio + hold_ratio) * d : undef,

    tip = tip_for(tip_brand, v[1]),
    tip_missing = unknown_keys(tip, tip_dims),

    departures = [
      if (stroke < stroke_band[0]) "stroke_below_band",
      if (stroke > stroke_band[1]) "stroke_above_band",
      if (!o_ok) "no_registered_oring_fits",
      if (o_ok && (_stretch(o, d) < oring_stretch_band[0] || _stretch(o, d) > oring_stretch_band[1]))
        "oring_stretch_outside_band",
      if (grad_spacing < scale_spacing_min) "graduations_too_close",
      if (gain_halfspread * v[1] > iso[0] / 2) "pin_tolerance_uses_over_half_of_systematic_limit",
    ],
    cannot_evaluate = [
      if (len(tip_missing) > 0) "tip_cone (tip not measured)",
      "dead_air_volume (needs the body geometry)",
      "springs (need the plunger force target)",
      if (!known(p, "length")) "pin_stock_length (no supplier lengths registered)",
    ]
  )
  assert(stroke > 0 && stroke_min > 0, "volume range must be positive")
  assert(v[0] < v[1], str(size_name, ": minimum volume must be below maximum"))
  assert(!o_ok || _stretch(o, d) > -0.5,
         str(o_ok ? get(o, "name") : "", " is far larger than the ", d, " mm pin: it cannot seal"))
  [
    ["name", size_name],
    ["range_ul", v],
    ["increment_ul", inc],
    ["piston", p],
    ["d", d],
    ["area", a],
    ["stroke", stroke],
    ["stroke_min", stroke_min],
    ["blowout", blowout],
    ["iso", iso],
    ["stroke_sd_limit", iso[1] / a],
    ["d_scale", d_scale],
    ["gain_halfspread", gain_halfspread],
    ["gain_if_nominal", gain_if_nominal],
    ["oring", o],
    ["oring_stretch", o_ok ? _stretch(o, d) : undef],
    ["squeeze", squeeze],
    ["gland_depth", gland_depth],
    ["gland_groove_d", o_ok ? d + 2 * gland_depth : undef],
    ["gland_w", gland_w],
    ["spindle", th],
    ["ul_per_turn", ul_per_turn],
    ["turns", turns],
    ["knob_d", knob_d],
    ["grad_spacing", grad_spacing],
    ["pin_min_length", pin_min],
    ["tip", tip],
    ["tip_missing", tip_missing],
    ["departures", departures],
    ["cannot_evaluate", cannot_evaluate],
  ];
