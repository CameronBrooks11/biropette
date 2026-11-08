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

## Parts

These are for the full set of four rigs: P200 and P1000, each in both
variants. Each row states the requirement and then one candidate that meets
it; any part meeting the requirement will do. The candidates and prices are
McMaster-Carr listings, read 2026-11-08 [secondary].

| Requirement | Used in | Candidate | Pack | Price |
|---|---|---|---|---|
| Dowel pin Ø4 m6 × 36, hardened (DIN 6325 / ISO 8734) | P200 piston | McMaster 91595A184 | 25 | $9.40 |
| Dowel pin Ø8 m6 × 60, hardened (DIN 6325 / ISO 8734) | P1000 piston | McMaster 91595A585 | 10 | $17.14 |
| O-ring 4 × 1.5 mm NBR 70A | P200 seal, every port plug | McMaster 9262K422 | 100 | $6.42 |
| O-ring 8 × 1.5 mm NBR 70A | P1000 seal | McMaster 9262K445 | 100 | $7.17 |
| Socket head screw M3 × 10, ISO 4762, stainless | radial caps | McMaster 91292A113 | 100 | $7.11 |
| Socket head screw M3 × 12, ISO 4762, stainless | axial caps | McMaster 91292A114 | 100 | $7.11 |
| Socket head screw M4 × 6, ISO 4762, stainless | port plugs | McMaster 91292A107 | 100 | $9.09 |
| Drill 4.1 mm, jobber, HSS | P200 guide bore | McMaster 2958A73 | 1 | $3.57 |
| Drill 8.1 mm, jobber, HSS | P1000 guide bore | McMaster 2958A128 | 1 | $10.70 |

**Optional: stainless pins.** A pipette is wiped with ethanol and bleach, so
the pin material is a test variable too. Both are 18-8 stainless, ISO 2338
m6:

- Ø4 × 36: McMaster 91585A487, 10 for $11.23.
- Ø8 × 60: McMaster 91585A867, 5 for $20.29.

**Tools assumed on hand:**

- calipers;
- a metric feeler gauge set (axial variant);
- a scale reading 0.1 g or finer;
- silicone grease, if lubricated runs are tested.

## Make

1. Print `rig_body` and `rig_cap` for the size and variant. `just print`
   exports all eight to `build/print/`; the Customizer (`size`,
   `rig_variant`, `part`) gives one at a time. Print the body base down and
   the cap flange down, as exported.
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
