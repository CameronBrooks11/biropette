# Seal rig: measuring piston-seal friction and leak

The plunger springs can only be chosen once the seal's friction is known
(`design.md` §4.2), and the friction depends on how hard the O-ring is
squeezed. The rig holds one size's piston pin and seal so that both can be
measured before the pipette body is designed around them.

It comes in two gland variants:

- **Axial.** The O-ring sits free in its pocket and the cap's spigot
  compresses it. Turning the cap screws tunes the squeeze on the bench, and
  the gap left under the cap (a feeler gauge) reads it.
- **Radial.** The pocket's printed diameter sets the squeeze, as a groove in
  the pipette body would. This shows what squeeze a printed gland actually
  achieves.

`just report <size>` prints, for each variant: what to print, drill and buy;
the cap gap; and the leak-test travel and the reading to expect.

## Make

1. Print `rig_body` and `rig_cap` for the size and variant (Customizer:
   `size`, `rig_variant`, `part`). Print the body base down and the cap
   flange down, as exported.
2. Drill the guide bore to the size the report gives (pin + 0.1 mm) from the
   top, by hand or at low speed. The pocket is not drilled.
3. **Radial only:** measure the pocket diameter (calipers, inside jaws, or
   pin gauges) and work out the squeeze with the report's formula.
4. Fit the plug O-ring in the seat under the base and screw the M4 plug in
   until it seats. Leave it out for the friction tests.
5. Wipe the pin. Fit the O-ring in the pocket, then the cap, then the pin
   down through the cap.
   - Lubricated or dry is a test variable: record it.
   - **Axial:** tighten the cap screws evenly until the gap equals the
     report's no-compression gap, then close it in steps (for example
     0.05 mm), testing at each.

## Measure

Stand the rig on a kitchen or jewellery scale (0.1 g or finer) and tare it.
Use the same pin speed for every reading, roughly one stroke per second; the
pipette's own pace is the relevant one.

- **Running friction:** press the pin down slowly through the 10 mm of
  travel with the port open, and note the steady reading. Reverse: pull it
  back with a thread tied round it, or by hand with the scale reading
  negative. Repeat 5 times.
- **Break-out friction:** leave the pin still for 10 minutes, then for an
  hour, and note the peak reading as it starts to move.
- **Leak:** fit the plug. Raise the pin to the top of its travel, then press
  it down by the leak-test travel the report gives. The scale should read
  the leak force above the running friction. Hold the pin still and note the
  reading every 10 s for 2 minutes; a falling reading is air leaking past
  the seal.

## Record

For every reading, record:

- the date, size, variant, O-ring source and batch;
- lubricant (none or the product);
- squeeze (radial: computed from the measured pocket; axial: from the gap);
- room temperature;
- the readings.

Put the results in the issue tracker against the seal-friction issue, or as
a CSV under `data/` once one exists. The friction figure replaces
`planning_squeeze` and the Parker estimate in `cad/data/ergonomics.scad`,
and the springs are chosen from it.

## What decides the gland

The squeeze to aim for is the smallest that still holds the leak test for
2 minutes without a falling reading. The pipette's own pressure difference
is about 0.4 kPa; the test uses 5 kPa for a readable force.

- If the radial pockets hold that squeeze as printed, the pipette body uses
  a radial gland.
- If they do not, the body uses the axial, tunable gland.
