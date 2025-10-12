////////////////////////////////////////////////////////////////////////////////
// Micropipette Rack
// Original: PIPETTE RACK v1 (2014-02-24) by Tom Baden (Thingiverse ID: tbaden)
// Inspired by kwalus (http://www.thingiverse.com/thing:64977)
////////////////////////////////////////////////////////////////////////////////

// ==============================
// User-tunable parameters
// ==============================

/* [Parameters:] */

// One- or two-sided version
side_count = 2; // [1,2]

// Rack dimensions
rack_length = 130; // [50:300]
rack_height = 180; // [150:220]

// Foot dimensions
foot_width = 150; // [100:200]
foot_length = 15; // [10:30]

// Material thickness multiplier
stability = 2; // [1:4]

// Printer precision tolerance
tol = 0.4; // [0.1,0.2,0.3,0.4,0.5]

/* [Preview Controls:] */
show_partA = true; // [true,false]
show_partB = true; // [true,false]

// -----------------------------------------------------------------------------
// CUSTOMIZER CUTOFF: modify below at your own risk
// -----------------------------------------------------------------------------
module customizer_cutoff(){}; // legacy marker

// ==============================
// Global constants
// ==============================
$fn = $preview ? 32 : 128;
sep = 20;

X = rack_length;
Z = rack_height;
Y = 18;

wall_y = 2 * stability;
wall_z = 3 * stability;
wall_x = 4 * stability;

hanger_x = 11;
hanger_y = 35;

slot_depth = 20;
slot_width = 5;

radius_end = 10;
radius_inner = 6;
radius_inner_fit = radius_inner - tol;
connect_width = sqrt(radius_inner_fit * radius_inner_fit * 2);

triangle_top = 30;
slot_count = round(X / 50);
is_double = (side_count == 2);

// ==============================
// Part A – Top beam with hangers
// ==============================

module top_beam() {
  // main beam
  cube([X, wall_y, wall_z], center=true);

  // rounded ends
  translate([-X / 2 - radius_end / 2, 0, 0])
    cylinder(r=radius_end, h=wall_z, center=true);
  translate([X / 2 + radius_end / 2, 0, 0])
    cylinder(r=radius_end, h=wall_z, center=true);

  // hangers
  for (i = [1:slot_count]) {
    x_pos = -X / 2 + (i - 0.5) * X / slot_count;

    // front side hanger
    translate([x_pos, -hanger_y / 2 - wall_y / 2, 0])
      cube([hanger_x, hanger_y, wall_z], center=true);
    translate([x_pos, -hanger_y - wall_y / 2, wall_z / 2])
      rotate([45, 0, 0])
        cube([hanger_x, sqrt(2) * wall_z, sqrt(2) * wall_z], center=true);

    if (is_double) {
      // back side hanger
      translate([x_pos, hanger_y / 2 + wall_y / 2, 0])
        cube([hanger_x, hanger_y, wall_z], center=true);
      translate([x_pos, hanger_y + wall_y / 2, wall_z / 2])
        rotate([45, 0, 0])
          cube([hanger_x, sqrt(2) * wall_z, sqrt(2) * wall_z], center=true);
    }
  }
}

module top_beam_cutouts() {
  // end-holes (square)
  translate([-X / 2 - radius_end / 2, 0, 0])
    rotate([0, 0, 45])
      cylinder($fn=4, r=radius_inner, h=wall_z, center=true);
  translate([X / 2 + radius_end / 2, 0, 0])
    rotate([0, 0, 45])
      cylinder($fn=4, r=radius_inner, h=wall_z, center=true);

  // tip slots
  for (i = [1:slot_count]) {
    x_pos = -X / 2 + (i - 0.5) * X / slot_count;
    translate([x_pos, slot_depth / 2 - hanger_y - wall_y / 2, wall_z / 2])
      cube([slot_width, slot_depth, wall_z * 2], center=true);
    if (is_double)
      translate([x_pos, -slot_depth / 2 + hanger_y + wall_y / 2, wall_z / 2])
        cube([slot_width, slot_depth, wall_z * 2], center=true);
  }

  // side end cuts
  translate([0, -hanger_y - wall_y * 1.5, wall_z / 2])
    cube([X, wall_y * 2, wall_z * 2], center=true);
  translate([0, hanger_y + wall_y * 1.5, wall_z / 2])
    cube([X, wall_y * 2, wall_z * 2], center=true);

  // top surface cut
  translate([0, 0, wall_z * 1.5])
    cube([X, (hanger_y + wall_y) * 2, wall_z], center=true);
}

// Emit Part A
if (show_partA)
  difference() { top_beam(); top_beam_cutouts(); }

// ==============================
// Part B – Side support & foot
// ==============================
module side_support() {
  // vertical leg
  translate([-X / 2 - radius_end / 2 - connect_width / 2 + wall_x / 2, 0, -Z / 2 - wall_z / 2 - sep])
    cube([wall_x, Y, Z], center=true);

  // connection socket
  translate([-X / 2 - radius_end / 2, 0, -sep])
    rotate([0, 0, 45])
      cylinder($fn=4, r=radius_inner_fit, h=wall_z, center=true);

  // foot pad
  translate([-X / 2 - radius_end / 2 - connect_width / 2 + foot_length / 2, 0, -Z - sep])
    cube([foot_length, foot_width, wall_z], center=true);
}

if (show_partB)
  side_support();

// ==============================
// End of file
// ==============================
