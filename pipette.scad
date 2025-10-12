////////////////////////////////////////////////////////////////////////////////
// Micropipette a.k.a. Biropette
// Original: PIPETTE v16 (2014-02-22) by Tom Baden (Thingiverse ID: tbaden)
// Inspired by kwalus (http://www.thingiverse.com/thing:64977)
////////////////////////////////////////////////////////////////////////////////

// ==============================
// User-tunable (Customizer) vars
// ==============================

/* [Parameters:] */

// Cross-section visualizer
show_cross_section = 0; // [0,1]

// Include expunger subsystem
use_expunger = 1; // [0,1]

// Printer tolerance
tol = 0.35; // [0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5]

// Regulator (staircase) parameters

// height
range_z = 10; // [3:15] 

// step count
range_steps = 10; // [1:20]

// Membrane pin radius
range_membrane_pin = 4; // [2.5, 3, 3.5, 4, 4.5]

// Tip shaft radius (OD of tube that holds disposable tip)
shaft_radius = 2.5;

// Biro/pen plunger radii
biro_radius = 1.8;
biro_radius_tip = 1.7;

// Thread radius
screw_radius = 2.5;

/* [Preview Controls:] */

show_partA = true; // [true,false]
show_partB = true; // [true,false]
show_partC = true; // [true,false]
show_partD = true; // [true,false]
show_partE = true; // [true,false]
show_partF = true; // [true,false]
show_partG = true; // [true,false]

// -----------------------------------------------------------------------------
// CUSTOMIZER CUTOFF: modify below at your own risk
// -----------------------------------------------------------------------------
module customizer_cutoff(){}; // legacy marker

// ==============================
// Global constants and aliases
// ==============================

$fn = $preview ? 32 : 128;
z_fight = $preview ? 0.05 : 0;

// Utility dims
slide = tol;
sep = 20;
wall = 3;
connect_Z = 5;
connect_R = 7;
connect_X = 2;
cross_section = show_cross_section * 100;

// ==============================
// Part A: Top body
// ==============================
A_Z = 58;
A_Z_top = 16;
A_Y = 18;
A_X = 25;

A_topwall = 5;
A_hole_R = A_Y / 2 + 2;
A_hole_Z = 33;

P1_R = biro_radius + slide; // plunger stalk radius
P2_R = range_membrane_pin + 1; // screw/plunger head radius
P2_R_minus = range_membrane_pin; // reduced head radius
P2_ZA = (P2_R_minus * 2) - 1; // screw head height in A
P2_ZB = 15; // screw head depth in B

P3_R = 1.5; // thread hole in B
P4_ZB = 15; // shaft depth in B

PD_R = 6; // top plunger cap radius

screw_Z = 7;
screw_Xoff = 10.5;

A_Z2 = 5;
A_X2 = 12;
A_X3 = 8;

module A_main() {
  translate([0, 0, A_Z / 2 + A_Z_top / 2])
    cube([A_X, A_Y, A_Z_top], center=true);
  // top main

  translate([0, 0, connect_Z / 2])
    cube([A_X, A_Y, A_Z - connect_Z], center=true);
  // bottom main

  // connect bridge
  translate([0, 0, -A_Z / 2 + connect_Z / 2])
    cube([connect_X * 2, (connect_R - slide / 2) * 2, connect_Z], center=true);

  translate([connect_X, 0, -A_Z / 2 + connect_Z / 2])
    cylinder(r=connect_R - slide / 4, h=connect_Z, center=true);

  translate([-connect_X, 0, -A_Z / 2 + connect_Z / 2])
    cylinder(r=connect_R - slide / 4, h=connect_Z, center=true);
}

module A_main_intersection() {
  cylinder(r=A_X / 2, h=A_Z * 5, center=true); // smoothing shell
}

module A_main_smooth() {
  intersection() { A_main(); A_main_intersection(); }
}

module A_extension() {
  translate([A_X2, 0, connect_Z / 2 + A_Z / 2 - A_Z2 + A_Z_top])
    cube([A_X, A_Y, A_Z2], center=true);
  // top extension

  rotate([0, -20, 0])
    translate([A_X2 + 10, 0, connect_Z / 2 + A_Z / 2 - A_Z2 + A_Z_top - 10])
      cube([A_X, A_Y, A_Z2], center=true);
  // slanted top
}

module A_extension_intersec() {
  translate([A_X2, 0, connect_Z / 2 + A_Z / 2 - A_Z2 + A_Z_top])
    cylinder(r=A_X / 2, h=A_Z2 * 3, center=true);
}

module A_extension_smooth() {
  intersection() { A_extension(); A_extension_intersec(); }
}

module A_expunger() {
  translate([-A_X3, 0, connect_Z / 2])
    cube([A_X, A_Y, 30 * use_expunger], center=true);

  rotate([0, 45, 0])
    translate([-22, 0, -10])
      cube([27 * use_expunger, A_Y, A_Z + 15], center=true);

  rotate([0, -45, 0])
    translate([-22, 0, 34])
      cube([27 * use_expunger, A_Y, A_Z + 15], center=true);
}

module A_expunger_intersec() {
  translate([-A_X3, 0, 0])
    cylinder(r=A_X / 2, h=A_Z * 3, center=true);
}

module A_expunger_smooth() {
  intersection() { A_expunger(); A_expunger_intersec(); }
}

module A_total() {
  union() { A_main_smooth(); A_extension_smooth(); A_expunger_smooth(); }
}

module A_main_hole() {
  // top bore
  translate([0, 0, A_Z / 2 + A_Z_top / 2 - A_topwall / 2 + PD_R / 2])
    cylinder(r=PD_R + slide, h=A_Z_top - A_topwall, center=true);

  translate([0, 0, A_Z / 2 + 1])
    cylinder(r2=PD_R + slide, r1=P1_R, h=PD_R - 1.5, center=true);

  // side/bottom bore
  translate([0, 0, (A_Z - A_hole_Z) / 2 - A_topwall])
    cylinder(r=A_hole_R, h=A_hole_Z, center=true);

  translate([0, 0, (A_Z - A_hole_Z) / 2 - A_topwall - A_hole_Z / 2 - A_hole_R / 2])
    cylinder(r2=A_hole_R, r1=P1_R, h=A_hole_R, center=true);

  // cap seat
  translate([0, 0, A_Z / 2 + A_Z_top - A_topwall / 2])
    cylinder(r=PD_R + slide, h=A_topwall + z_fight, center=true);

  // main through hole
  cylinder(r=P1_R, h=A_Z, center=true);

  // screw head pocket
  translate([0, 0, -A_Z / 2 + P2_ZA / 2])
    cylinder(r=P2_R, h=P2_ZA + z_fight, center=true);

  // optional cross-section
  translate([0, 30, 0]) cube([60, 60, cross_section], center=true);

  // side screw
  translate([screw_Xoff, 0, A_Z / 2 + A_Z_top - screw_Z / 2])
    cylinder(r=screw_radius, h=screw_Z + z_fight, center=true);

  // expunger pass-throughs
  translate([-A_X / 2 - 2, 0, 0])
    cylinder(r=P1_R, h=A_Z * use_expunger, center=true);

  translate([-A_X / 2 - 2, 0, 52])
    cylinder(r=4, h=A_Z * 2 * use_expunger, center=true);
}

// Emit Part A
if (show_partA) {
  difference() { A_total(); A_main_hole(); }
}
// ==============================
// Part B: Bottom body
// ==============================
B_Z = 40;
B_exp_Z = 30;
B_exp_Z_hole = 20;

module B_main() {
  translate([0, 0, -(A_Z + B_Z) / 2 - sep])
    cube([A_X, A_Y, B_Z], center=true);
}

module B_main_intersection() {
  translate([0, 0, -(A_Z + B_Z) / 2 - sep])
    cylinder(r2=A_X / 2, r1=A_X / 4, h=B_Z, center=true);
}

module B_expunger() {
  translate([-A_X3, 0, -(A_Z + B_Z) / 2 - sep - (B_Z - B_exp_Z) / 2])
    cube([A_X, A_Y, B_exp_Z * use_expunger], center=true);
}

module B_expunger_intersec() {
  translate([-A_X3, 0, -sep])
    cylinder(r=A_X / 2, h=A_Z * 3 * use_expunger, center=true);
}

module B_expunger_smooth() { intersection() { B_expunger(); B_expunger_intersec(); } }
module B_main_smooth() { intersection() { B_main(); B_main_intersection(); } }
module B_total() { union() { B_main_smooth(); B_expunger_smooth(); } }

module B_main_hole() {
  // connector
  translate([0, 0, -(A_Z + B_Z) / 2 - sep + B_Z / 2 - connect_Z / 2])
    cube([connect_X * 2, (connect_R) * 2, connect_Z + z_fight], center=true);

  translate([connect_X, 0, -(A_Z + B_Z) / 2 - sep + B_Z / 2 - connect_Z / 2])
    cylinder(r=connect_R, h=connect_Z + z_fight, center=true);

  translate([-connect_X, 0, -(A_Z + B_Z) / 2 - sep + B_Z / 2 - connect_Z / 2])
    cylinder(r=connect_R, h=connect_Z + z_fight, center=true);

  // through hole
  translate([0, 0, -(A_Z + B_Z) / 2 - sep])
    cylinder(r=P3_R, h=B_Z, center=true);

  // screw head pocket
  translate([0, 0, -(A_Z + B_Z) / 2 - sep + B_Z / 2 - connect_Z - P2_ZB / 2])
    cylinder(r=P2_R, h=P2_ZB, center=true);

  // bottom shaft seat
  translate([0, 0, -(A_Z + B_Z) / 2 - sep - B_Z / 2 + P4_ZB / 2])
    cylinder(r=shaft_radius + slide, h=P4_ZB + z_fight, center=true);

  // expunger pass-throughs
  translate([-A_X / 2 - 2, 0, -(A_Z + B_Z) / 2 - sep - (B_Z - B_exp_Z) / 2])
    cylinder(r=P1_R, h=B_exp_Z + z_fight, center=true);

  translate([-A_X / 2 - 2, 0, -(A_Z + B_Z) / 2 - sep - (B_Z - B_exp_Z) / 2 - (B_exp_Z - B_exp_Z_hole) / 2])
    cylinder(r=4, h=B_exp_Z_hole, center=true);

  // slant cut
  rotate([0, 45, 0])
    translate([49, 0, -9 - (A_Z + B_Z) / 2 - sep])
      cube([20, A_Y + z_fight, 20], center=true);

  // optional cross-section
  translate([0, 30, -(A_Z + B_Z) / 2 - sep])
    cube([60, 60, cross_section], center=true);
}

// Emit Part B
if (show_partB) {
  difference() { B_total(); B_main_hole(); }
}

// ==============================
// Part C: Bottom plunger
// ==============================
module C_main() {
  translate([0, 0, -2 * sep]) sphere(r=P2_R_minus);
  translate([0, 0, -2 * sep + (P2_R_minus) / 2])
    cylinder(r=P2_R_minus, h=P2_R_minus, center=true);
}

module C_hole() {
  translate([0, 0, -2 * sep + 1])
    cylinder(r=biro_radius + slide / 3, h=(P2_R_minus - 0.5) * 2, center=true);

  translate([0, 30, -2 * sep])
    cube([60, 60, cross_section], center=true);
}

// Emit Part C
if (show_partC) {
  difference() { C_main(); C_hole(); }
}
// ==============================
// Part D: Top plunger
// ==============================
P0_R = 2.1;
P_Zextra = 30;

module D_main() {
  translate([0, 0, 4 * sep + 7 / 2]) sphere(r=PD_R);
  translate([0, 0, 4 * sep - P_Zextra / 2])
    cylinder(r=PD_R, h=PD_R + P_Zextra, center=true);
}

module D_hole() {
  translate([0, 0, 4 * sep + PD_R / 2 - 1])
    cylinder(r=biro_radius_tip + slide / 3, h=PD_R * 2, center=true);

  translate([0, 0, 4 * sep + PD_R / 2 - 1 - 3])
    cylinder(r1=P0_R + 2, r2=P0_R, h=PD_R, center=true);

  translate([0, 0, 4 * sep - P_Zextra / 2 - PD_R / 2 - 1])
    cylinder(r=P0_R + 2, h=P_Zextra, center=true);

  translate([0, 30, 4 * sep - P_Zextra / 2 - PD_R / 2])
    cube([60, 60, cross_section], center=true);
}

// Emit Part D
if (show_partD) {
  difference() { D_main(); D_hole(); }
}
// ==============================
// Part E: Regulator plunger
// ==============================
offset_reg = PD_R + 2;
E_R = PD_R + 3;
E_Z = range_z;
E_steps = range_steps;
E_hole_R = 2 + slide / 3; // retained though replaced by center cut

module E_main() {
  translate([0, 0, 5 * sep])
    cylinder(r=E_R, h=E_Z, center=true);
}

module E_hole() {
  // center big cut
  translate([0, 0, 5 * sep])
    cylinder(r=PD_R, h=E_Z + z_fight, center=true);

  // staircase ring holes
  for (i = [0:E_steps - 1]) {
    angle = i * 360 / E_steps;
    translate([cos(angle) * offset_reg, sin(angle) * offset_reg, 5 * sep + (E_Z / E_steps) * (i + 1)])
      rotate([0, 0, angle - 180 / (E_steps - 1)])
        cylinder(r=4, h=E_Z + z_fight, center=true);
  }
}

// Emit Part E
if (show_partE) {
  difference() { E_main(); E_hole(); }
}

// ==============================
// Part F: use_expunger plunger (top link)
// ==============================
F_Z = 30 * use_expunger;

module Expunger_plunger() {
  translate([-A_X / 2 - 2, 0, 57 + sep])
    cylinder(r=3.7, h=F_Z, center=true);

  translate([-A_X / 2 - 2, 0, 57 + sep + 15])
    sphere(r=3.7 * use_expunger);
}

module Expunger_plunger_hole() {
  translate([-A_X / 2 - 2, 0, 4 * sep + PD_R / 2 - 1])
    cylinder(r=biro_radius_tip + slide / 3, h=PD_R * 2 + z_fight, center=true);

  translate([-A_X / 2 - 2, 0, 4 * sep + PD_R / 2 - 1 - 3])
    cylinder(r1=P0_R + 0.5, r2=P0_R, h=PD_R, center=true);

  translate([-A_X / 2 - 2, 0, 4 * sep - P_Zextra / 2 - PD_R / 2 - 1])
    cylinder(r=P0_R + 0.5, h=P_Zextra, center=true);

  translate([0, 30, 100]) cube([60, 60, cross_section], center=true);
}

// Emit Part F
if (show_partF) {
  difference() { Expunger_plunger(); Expunger_plunger_hole(); }
}
// ==============================
// Part G: use_expunger plunger bottom
// ==============================
G_Z = 6 * use_expunger;

module G_main() {
  translate([-5, 0, -(A_Z + B_Z) / 2 - B_Z - sep])
    cube([10, A_X / 2, G_Z], center=true);
  // connect

  translate([0, 0, -(A_Z + B_Z) / 2 - B_Z - sep])
    cylinder(r=A_X / 4, h=G_Z, center=true);
  // main circle

  translate([-A_X / 2 - 2, 0, -(A_Z + B_Z) / 2 - B_Z - sep + G_Z * 2.2])
    cylinder(r=3.7, h=G_Z * 2.5, center=true);
  // stick up

  rotate([0, 45, 0])
    translate([57, 0, -9 - (A_Z + B_Z) / 2 - sep - 6])
      cube([31, A_Y, G_Z], center=true);
  // slant
}

module G_main_intersection() {
  // main circle
  translate([0, 0, -(A_Z + B_Z) / 2 - B_Z - sep])
    cylinder(r=A_X / 4, h=G_Z, center=true);

  // side circle
  translate([-A_X3 - 4, 0, -(A_Z + B_Z) / 2 - B_Z - sep + 10])
    cylinder(r=A_X / 4, h=G_Z + 20, center=true);

  // connect
  translate([-6, 0, -(A_Z + B_Z) / 2 - B_Z - sep])
    cube([11, A_X / 2, G_Z], center=true);
}

module G_total() {
  intersection() {
    G_main();
    G_main_intersection();
  }
}

module G_main_hole() {
  // mainhole
  translate([0, 0, -(A_Z + B_Z) / 2 - B_Z - sep])
    cylinder(r=shaft_radius + slide + 0.5, h=G_Z + z_fight, center=true);

  // sidehole
  translate([-A_X / 2 - 2, 0, -(A_Z + B_Z) / 2 - B_Z - sep + 2 + G_Z * 2])
    cylinder(r=biro_radius + slide / 3, h=G_Z * 3, center=true);

  translate([0, 30, -(A_Z + B_Z) / 2 - B_Z - sep])
    cube([60, 60, cross_section * use_expunger], center=true);
}

// Emit Part G
if (show_partG) {
  difference() { G_total(); G_main_hole(); }
}

// ==============================
// End of file
// ==============================
