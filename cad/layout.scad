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
include <data/ergonomics.scad>
include <purchased/pistons.scad>
include <purchased/orings.scad>
include <purchased/sleeves.scad>
include <purchased/collars.scad>
include <purchased/springs.scad>
include <purchased/tips.scad>
include <purchased/fasteners.scad>

// [reasoned] constants, one line of reason each.
fill_target = 0.75; // gland fill to design to: under oring_fill_max with room for tolerance
guide_ratio = 1.5; // guided length / pin diameter: below about 1.5 a sliding pin tends to cock and jam
hold_ratio = 1.5; // length / diameter of pin held in the rod coupling: a press fit needs engagement
spring_bore_clearance = 0.5; // mm on diameter between a spring and the bore that guides it

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

// The shortest stock length at or above need; undef when none is.
function stock_at_least(lengths, need) =
  let(ok = [for (l = lengths) if (l >= need) l]) len(ok) == 0 ? undef : min(ok);

// A spring fitted so that it pushes f0 at its first position and is then
// compressed by travel: [fitted length, end length, end force].
function spring_fit(s, f0, travel) =
  let(l0 = get(s, "L0") - f0 / get(s, "R"))
  [l0, l0 - travel, f0 + get(s, "R") * travel];

function layout(size_name, piston = "auto", oring = "auto", sleeve = "m10x1_lamp",
                tip_brand = "generic", measuring = "auto", blowout = "auto") =
  let(
    size = by_name(sizes, size_name),
    v = get(size, "range_ul"),
    inc = get(size, "increment_ul"),
    p = piston == "auto" ? piston_for(size) : by_name(pistons, piston),
    d = get(p, "d"),
    a = area(d),
    stroke = v[1] / a,
    stroke_min = v[0] / a,
    blow = get(size, "blowout_fraction") * stroke,
    iso = iso8655_limits(v[1]),

    // The pin's m6 band is a gain error: V scales with d^2. Building the
    // scale on the band's middle leaves +/- half of it.
    dev = get(p, "deviation"),
    d_scale = d + (dev[0] + dev[1]) / 2,
    gain_halfspread = (dev[1] - dev[0]) / d_scale,
    gain_if_nominal = pow(d_scale / d, 2) - 1,

    o = oring == "auto" ? oring_for(d) : by_name(orings, oring),
    o_ok = !is_undef(o),
    cs = o_ok ? get(o, "cs") : undef,
    squeeze = planning_squeeze,
    gland_depth = o_ok ? cs * (1 - squeeze) : undef,
    gland_w = o_ok ? area(cs) / (gland_depth * fill_target) : undef,
    friction = seal_friction(d, squeeze),

    pin_min = o_ok ? stroke + blow + gland_w + (guide_ratio + hold_ratio) * d : undef,
    pin_stock = (o_ok && known(p, "lengths")) ? stock_at_least(get(p, "lengths"), pin_min) : undef,

    sl = by_name(sleeves, sleeve),
    pitch = get(sl, "pitch"),
    ul_per_turn = a * pitch,
    travel = stroke - stroke_min,
    turns = travel / pitch,
    knob_d = get(size, "knob_d"),
    grad_spacing = PI * knob_d * inc / ul_per_turn,
    sleeve_min = travel + sleeve_engagement + sleeve_knob_grip,

    collar_fits = [for (c = collars) if (get(c, "bore") == rod_d) c],
    collar = len(collar_fits) > 0 ? collar_fits[0] : undef,

    ms = by_name(springs, measuring == "auto" ? get(size, "measuring_spring") : measuring),
    bs = by_name(springs, blowout == "auto" ? get(size, "blowout_spring") : blowout),
    m_rest = get(size, "measuring_rest_N"),
    b_pre = get(size, "blowout_preload_N"),
    mfit = spring_fit(ms, m_rest, stroke),
    bfit = spring_fit(bs, b_pre, blow),
    thumb_first = mfit[2] + friction,
    thumb_blow_entry = b_pre + friction,
    thumb_blow_end = bfit[2] + friction,

    tip = tip_for(tip_brand, v[1]),
    tip_missing = unknown_keys(tip, tip_dims),

    departures = [
      if (stroke < stroke_band[0]) "stroke_below_band",
      if (stroke > stroke_band[1]) "stroke_above_band",
      if (!o_ok) "no_registered_oring_fits",
      if (o_ok && (_stretch(o, d) < oring_stretch_band[0] || _stretch(o, d) > oring_stretch_band[1]))
        "oring_stretch_outside_band",
      if (squeeze < oring_squeeze_band[0]) "seal_squeeze_below_parker_dynamic_band",
      if (grad_spacing < scale_spacing_min) "graduations_too_close",
      if (gain_halfspread * v[1] > iso[0] / 2) "pin_tolerance_uses_over_half_of_systematic_limit",
      if (o_ok && known(p, "lengths") && is_undef(pin_stock)) "no_stock_pin_long_enough",
      if (m_rest < return_margin * friction) "measuring_spring_too_weak_to_return_against_friction",
      if (thumb_first > get(size, "first_stop_max_N")) "first_stop_force_above_commercial",
      if (b_pre - mfit[2] < blowout_step_min) "blowout_step_too_small",
      if (thumb_blow_end > get(size, "blowout_max_N")) "blowout_force_above_20pct_rule",
    ],
    cannot_evaluate = [
      if (len(tip_missing) > 0) "tip_cone (tip not measured)",
      "dead_air_volume (needs the body geometry)",
      "seal_friction (planning estimate from Parker; measure on the seal rig)",
      if (!known(sl, "length")) "sleeve_stock_length (no fully threaded lengths registered)",
      if (!known(p, "lengths")) "pin_stock_length (no supplier lengths registered)",
    ]
  )
  assert(stroke > 0 && stroke_min > 0, "volume range must be positive")
  assert(v[0] < v[1], str(size_name, ": minimum volume must be below maximum"))
  assert(!o_ok || _stretch(o, d) > -0.5,
         str(o_ok ? get(o, "name") : "", " is far larger than the ", d, " mm pin: it cannot seal"))
  assert(rod_d < get(sl, "id"), str("the ", rod_d, " mm rod does not pass the ", get(sl, "id"), " mm sleeve bore"))
  assert(!is_undef(collar), str("no registered collar fits the ", rod_d, " mm rod"))
  assert(get(ms, "Dd") >= rod_d, str(get(ms, "name"), " does not fit over the ", rod_d, " mm rod"))
  assert(get(bs, "Dd") >= rod_d, str(get(bs, "name"), " does not fit over the ", rod_d, " mm rod"))
  assert(mfit[0] <= get(ms, "L0") && mfit[1] >= get(ms, "Ln"),
         str(get(ms, "name"), " would close to ", mfit[1], " mm, below its ", get(ms, "Ln"), " mm minimum"))
  assert(bfit[0] <= get(bs, "L0") && bfit[1] >= get(bs, "Ln"),
         str(get(bs, "name"), " would close to ", bfit[1], " mm, below its ", get(bs, "Ln"), " mm minimum"))
  [
    ["name", size_name],
    ["range_ul", v],
    ["increment_ul", inc],
    ["piston", p],
    ["d", d],
    ["area", a],
    ["stroke", stroke],
    ["stroke_min", stroke_min],
    ["blowout", blow],
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
    ["friction", friction],
    ["pin_min_length", pin_min],
    ["pin_stock", pin_stock],
    ["sleeve", sl],
    ["ul_per_turn", ul_per_turn],
    ["turns", turns],
    ["knob_d", knob_d],
    ["grad_spacing", grad_spacing],
    ["sleeve_min_length", sleeve_min],
    ["rod_d", rod_d],
    ["collar", collar],
    ["measuring_spring", ms],
    ["measuring_fit", mfit],
    ["measuring_bore", get(ms, "De") + spring_bore_clearance],
    ["blowout_spring", bs],
    ["blowout_fit", bfit],
    ["blowout_bore", get(bs, "De") + spring_bore_clearance],
    ["thumb_first", thumb_first],
    ["thumb_blow_entry", thumb_blow_entry],
    ["thumb_blow_end", thumb_blow_end],
    ["tip", tip],
    ["tip_missing", tip_missing],
    ["departures", departures],
    ["cannot_evaluate", cannot_evaluate],
  ];

// ---------------------------------------------------------------------------
// Seal rig: a block holding one size's piston pin and seal, to measure the
// seal's running and break-out friction (stand it on a scale, press the
// pin) and its leak (plug the port, displace the pin, watch the force
// decay). Procedure: docs/seal-rig.md.
//
// variant "radial": the pocket diameter sets the squeeze; the cap bottoms
//   on the body. The pocket is printed undersize and drilled to size.
// variant "axial": the O-ring sits free in the pocket and the cap's spigot
//   compresses it; the gap left under the cap reads the compression.

// [reasoned] rig constants, one line of reason each.
rig_travel = 10; // mm of pin travel tested: friction does not depend on it, and it keeps stock pins long enough
rig_floor_gap = 2; // mm between the pin at its lowest and the chamber floor
rig_protrude = 8; // mm of pin above the cap at its lowest, to press on
rig_wall = 3; // mm of printed wall around any bore or pocket
rig_cap_t = 4; // mm cap flange
rig_screw_engage = 6; // mm a screw self-taps into PLA: two diameters of M3
rig_axial_max = 0.30; // axial compression of the cross-section the axial cap can reach
rig_drill_allow = 0.2; // mm a printed hole is left undersize, to be drilled to size
rig_leak_kpa = 5; // kPa leak-test pressure: about 12x the 0.4 kPa a pipette sees, for a readable force
guide_clearance = 0.1; // mm on diameter the guide bore is drilled over the pin: a sliding fit for an m6 pin

function seal_rig(L, variant) =
  let(
    d = get(L, "d"),
    o = known(L, "oring") ? get(L, "oring") : undef,
    pin = known(L, "pin_stock") ? get(L, "pin_stock") : undef
  )
  assert(variant == "radial" || variant == "axial", str("unknown rig variant '", variant, "'"))
  assert(!is_undef(o), "the seal rig needs a registered O-ring that fits the pin")
  assert(!is_undef(pin), "the seal rig needs a stock pin length")
  let(
    cs = get(o, "cs"),
    ood = get(o, "id") + 2 * cs,
    m3 = by_name(fasteners, "M3"),
    m4 = by_name(fasteners, "M4"),
    plug_o = by_name(orings, "metric_4x1.5"),

    radial = variant == "radial",
    pocket_d = radial ? get(L, "gland_groove_d") : ood + 0.2,
    pocket_h = radial ? get(L, "gland_w") : cs,
    spigot_h = radial ? 0 : rig_axial_max * cs,
    spigot_d = pocket_d - 0.3,
    cap_gap = spigot_h, // under the cap with the ring uncompressed

    guide_d = d + guide_clearance,
    guide_len = guide_ratio * d,
    chamber_d = d + 1,
    chamber_h = rig_travel + rig_floor_gap,

    // Plug: an M4 screw from below, sealed by a 4 x 1.5 O-ring in a seat
    // compressed 25 % (static, [primary] Parker static band 22-32 %).
    seat_d = get(plug_o, "id") + 2 * get(plug_o, "cs") + 0.3,
    seat_h = 0.75 * get(plug_o, "cs"),
    recess_d = get(m4, "dk") + 2,
    recess_h = get(m4, "k") + 1,
    floor_t = 4,
    plug_len_need = seat_h + floor_t,
    plug_len = stock_at_least(get(m4, "lengths"), plug_len_need),

    bolt_r = pocket_d / 2 + rig_wall + get(m3, "clearance") / 2,
    body_d = 2 * (bolt_r + get(m3, "dk") / 2 + 1.5),
    body_h = recess_h + floor_t + chamber_h + guide_len + pocket_h,
    screw_need = rig_cap_t + cap_gap + rig_screw_engage,
    screw_len = stock_at_least(get(m3, "lengths"), screw_need),

    pin_need = rig_travel + guide_len + pocket_h + cap_gap + rig_cap_t + rig_protrude,

    // Leak test: chamber air at the pin's highest position.
    v_air = area(chamber_d) * chamber_h - area(d) * rig_floor_gap + (area(guide_d) - area(d)) * guide_len,
    leak_dx = rig_leak_kpa / 101.325 * v_air / area(d),
    leak_force = rig_leak_kpa * 1e3 * area(d) * 1e-6
  )
  assert(pin >= pin_need, str("the ", pin, " mm pin is shorter than the ", pin_need, " mm the rig needs"))
  assert(!is_undef(plug_len) && !is_undef(screw_len), "no stock screw length fits the rig")
  assert(leak_dx < rig_travel, str("the leak test needs ", leak_dx, " mm of travel; the rig has ", rig_travel))
  [
    ["name", str(get(L, "name"), " seal rig, ", variant)],
    ["variant", variant],
    ["d", d],
    ["oring", o],
    ["pin", pin],
    ["pin_need", pin_need],
    ["guide_d", guide_d],
    ["guide_len", guide_len],
    ["chamber_d", chamber_d],
    ["chamber_h", chamber_h],
    ["pocket_d", pocket_d],
    ["pocket_h", pocket_h],
    ["spigot_d", spigot_d],
    ["spigot_h", spigot_h],
    ["cap_gap", cap_gap],
    ["cap_t", rig_cap_t],
    ["cap_hole_d", d + 0.6],
    ["floor_t", floor_t],
    ["seat_d", seat_d],
    ["seat_h", seat_h],
    ["recess_d", recess_d],
    ["recess_h", recess_h],
    ["port_pilot", get(m4, "pilot")],
    ["plug_len", plug_len],
    ["bolt_r", bolt_r],
    ["screw_pilot", get(m3, "pilot")],
    ["screw_clearance", get(m3, "clearance")],
    ["screw_len", screw_len],
    ["body_d", body_d],
    ["body_h", body_h],
    ["drill_allow", rig_drill_allow],
    ["v_air", v_air],
    ["leak_kpa", rig_leak_kpa],
    ["leak_dx", leak_dx],
    ["leak_force", leak_force],
  ];
