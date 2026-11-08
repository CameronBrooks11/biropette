// Seal rig parts. Each module reads only its spec from seal_rig() in
// layout.scad. Units mm; z = 0 is the body's base, the axis is z.

include <../lib/struct.scad>

_e = 0.01; // overshoot so that cutters clear the faces they open

// Body, printed base down as modelled.
module seal_rig_body(s) {
  z_floor = get(s, "recess_h");
  z_chamber = z_floor + get(s, "floor_t");
  z_guide = z_chamber + get(s, "chamber_h");
  z_pocket = z_guide + get(s, "guide_len");
  top = get(s, "body_h");
  drill = get(s, "drill_allow");

  difference() {
    cylinder(d = get(s, "body_d"), h = top);

    // recess for the plug screw head, then the plug O-ring seat and the port
    translate([0, 0, -_e]) cylinder(d = get(s, "recess_d"), h = z_floor + _e);
    translate([0, 0, z_floor - _e]) cylinder(d = get(s, "seat_d"), h = get(s, "seat_h") + _e);
    translate([0, 0, z_floor - _e]) cylinder(d = get(s, "port_pilot"), h = get(s, "floor_t") + 2 * _e);

    // air chamber, guide bore (printed undersize, drilled to size)
    translate([0, 0, z_chamber]) cylinder(d = get(s, "chamber_d"), h = get(s, "chamber_h") + _e);
    translate([0, 0, z_guide - _e]) cylinder(d = get(s, "guide_d") - drill, h = get(s, "guide_len") + 2 * _e);

    // seal pocket, printed at size: a twist drill's point would cut past
    // its floor into the guide. The radial pocket is measured instead and
    // the squeeze computed from it (docs/seal-rig.md).
    translate([0, 0, z_pocket]) cylinder(d = get(s, "pocket_d"), h = get(s, "pocket_h") + _e);

    // cap screw pilots
    for (x = [-1, 1])
      translate([x * get(s, "bolt_r"), 0, top - rig_screw_depth(s)])
        cylinder(d = get(s, "screw_pilot"), h = rig_screw_depth(s) + _e);
  }
}

function rig_screw_depth(s) = get(s, "screw_len") - get(s, "cap_t") - get(s, "cap_gap") + 1;

// Cap in its assembled orientation: flange from z = 0 up, spigot below.
module seal_rig_cap(s) {
  difference() {
    union() {
      cylinder(d = get(s, "body_d"), h = get(s, "cap_t"));
      if (get(s, "spigot_h") > 0)
        translate([0, 0, -get(s, "spigot_h")]) cylinder(d = get(s, "spigot_d"), h = get(s, "spigot_h") + _e);
    }
    translate([0, 0, -get(s, "spigot_h") - _e])
      cylinder(d = get(s, "cap_hole_d"), h = get(s, "cap_t") + get(s, "spigot_h") + 2 * _e);
    for (x = [-1, 1])
      translate([x * get(s, "bolt_r"), 0, -_e])
        cylinder(d = get(s, "screw_clearance"), h = get(s, "cap_t") + 2 * _e);
  }
}

// Cap as printed: flange on the bed, spigot up.
module seal_rig_cap_print(s) {
  translate([0, 0, get(s, "cap_t")]) rotate([180, 0, 0]) seal_rig_cap(s);
}

// Assembly for inspection: body, cap at its uncompressed gap, pin at its
// lowest position. Sectioned on y > 0 so that the bores show.
module seal_rig_assembly(s) {
  z_chamber = get(s, "recess_h") + get(s, "floor_t");
  difference() {
    union() {
      seal_rig_body(s);
      translate([0, 0, get(s, "body_h") + get(s, "cap_gap")]) seal_rig_cap(s);
      // the pin is shown, not exported: it is bought, and it fills the undrilled guide
      %translate([0, 0, z_chamber + rig_floor_gap]) cylinder(d = get(s, "d"), h = get(s, "pin"));
    }
    translate([-get(s, "body_d"), 0, -1]) cube([2 * get(s, "body_d"), get(s, "body_d"), get(s, "body_h") + get(s, "pin") + 10]);
  }
}
