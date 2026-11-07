# Design basis: adjustable single-channel pipette (v1)

Status: draft for review. No v1 geometry exists yet.

This document says what v1 has to achieve, how the mechanism achieves it, and
where each number comes from. Every figure carries one of these labels:

- **[primary]**: a standard, a manufacturer's manual or a peer-reviewed paper.
- **[secondary]**: a vendor blog, a retailer or a third-party summary.
- **[derived]**: calculated here from cited formulas, by `python3 scripts/sizing.py`.
- **[measured]**: measured on a part, with the date and the instrument.
- **[reasoned]**: a judgement, not cited, with the reason given.

## 1. Scope

- An adjustable, single-channel, air-displacement piston pipette.
- First sizes: **P200 (20–200 µL)** and **P1000 (100–1000 µL)**.
  - P20 follows once those pass testing.
  - P2 and P10 are out of scope for a printed body, because their pistons are
    under 1 mm in diameter (section 5).
- It takes standard disposable tips. The tips the partner labs use are VWR,
  Ward's Science and generic universal tips.
- Out of scope for v1: multichannel (that is v2), the pipette rack, and
  electronics.

## 2. Why the v0 mechanism is replaced

v0 (`cad/v0/`, `docs/v0/`) is the 2014 Biropette:

- A biro refill pushes a printed pin into a glove membrane.
- A printed 10-step collar sets the stroke.
- Glue, tape and Parafilm seal it.
- The tip sits on a length of tubing.

Its authors report "±2–10 µl depending on printer precision" [primary, Baden
et al. 2015] and list it for low-precision use. Several things cannot be tuned
out:

- The membrane's tension and the leaks at the taped joints.
- The volume settings are discrete steps.
- No surface is a defined seal.

v1 keeps the name and the attribution. It replaces the mechanism.

## 3. Accuracy targets

The target is ISO 8655-2 for single-channel piston pipettes, tested by the
gravimetric method of ISO 8655-6. The limits below apply to the pipette **with
its tip** as one system, so testing uses the tips we support.

| Size | Nominal | Max. systematic error | Max. random error | Source |
|---|---|---|---|---|
| P200 | 200 µL | ±1.6 µL (0.8 %) | 0.6 µL (0.3 %) | [primary, Gilson Pipetman P manual, ISO column] |
| P1000 | 1000 µL | ±8 µL (0.8 %) | 3 µL (0.3 %) | [primary, same] |

- Both rows are the same in the 2002 and 2022 editions [secondary, Eppendorf
  customer information on ISO 8655-2:2022].
- At settings below nominal (50 % and 10 % in ISO 8655-6), the limits are read
  in µL from the nominal row [secondary]. For example, a P1000 set to 100 µL
  is held to ±8 µL and 3 µL.
- **Open:** buy ISO 8655-2:2022 and 8655-6:2022 and confirm both points from
  the text.

## 4. Mechanism

The architecture is the one commercial pipettes use [primary: Gilson
Pipetman manuals; Eppendorf Research plus manual; BRAND technical note]. The
parts that set accuracy are bought, and printed parts only locate them.

```
  push button ─┐
               │  plunger rod
   ┌───────────┴───────────┐
   │ volume spindle (metal │ ── sets the UPPER stop; turning it sets the stroke
   │ thread) + detent      │
   │ counter / scale       │
   │ measuring spring      │ ── returns the piston to the upper stop
   │ ── first stop ──      │ ── fixed: the end of the measuring stroke
   │ blow-out spring       │ ── stiffer; travel beyond the first stop = blow-out
   │ ── second stop ──     │
   ├───────────────────────┤
   │ piston (ground pin)   │
   │ seal (O-ring or PTFE  │ ── a static seal in the body, the piston slides
   │ seal + O-ring)        │    through it
   │ cylinder / air path   │ ── short and narrow: little captive air
   ├───────────────────────┤
   │ tip cone + O-ring     │ ── the cone locates the tip, the O-ring seals it
   │ tip ejector           │
   └───────────────────────┘
```

- **Volume setting.** The measuring stroke runs from the upper stop to the
  first stop. A metal thread moves the upper stop, which is the micrometer
  arrangement [primary, Gilson]. When the volume is increased, the user
  overshoots and comes back to take up backlash [primary, Pipetman P manual].
- **Calibration offset.** A separate adjustment shifts the stop without
  changing the displayed volume [primary, Eppendorf].
- **Seal.** For a moving seal, the O-ring squeeze is lower than for a static
  one: typically 15–25 % rather than 22–32 %, for a 0.070 in cross-section
  [primary, Parker O-ring handbook]. Commercial pipettes pair a PE or PTFE
  seal with an elastomer O-ring [primary, Gilson].
- **Tip seal.** Published open designs found that printed surfaces do not seal
  [primary, Brennan et al. 2018], so an elastomer does the sealing.
- **Why printed faces must not set the stroke.** See section 5. The required
  stroke repeatability is a few hundredths of a millimetre, so both stops are
  metal: the thread, a pin or a hard shoulder.

## 5. Sizing

Swept volume is V = (π/4)·d²·L, where d is the piston diameter and L the
stroke (1 µL = 1 mm³). These figures are [derived] from `scripts/sizing.py`:

| Size | Stroke L | Piston d | µL per mm | Stroke s.d. that uses the whole random limit | Travel per display step (0.2 µL / 1 µL) |
|---|---|---|---|---|---|
| P200 | 12 mm | 4.61 mm | 16.7 | 0.036 mm | 0.012 mm |
| P200 | 15 mm | 4.12 mm | 13.3 | 0.045 mm | 0.015 mm |
| P200 | 20 mm | 3.57 mm | 10.0 | 0.060 mm | 0.020 mm |
| P1000 | 12 mm | 10.30 mm | 83.3 | 0.036 mm | 0.012 mm |
| P1000 | 15 mm | 9.21 mm | 66.7 | 0.045 mm | 0.015 mm |
| P1000 | 20 mm | 7.98 mm | 50.0 | 0.060 mm | 0.020 mm |

- **Same stroke, same tolerance.** The random limit is 0.3 % of nominal for
  both sizes. So at the same stroke both need the same stroke repeatability:
  0.3 % of L, before seal friction, backlash or user force take any of it.
- **Spindle pitch.** Volume per turn of the spindle at a 15 mm stroke is
  [derived]:

  | Size | M3 (0.5 mm) | M4 (0.7 mm) | M5 (0.8 mm) |
  |---|---|---|---|
  | P200 | 6.7 µL | 9.3 µL | 10.7 µL |
  | P1000 | 33 µL | 47 µL | 53 µL |

  The detent count per turn follows from the display increment we choose.
- **Captive air.** The air between the piston and the liquid is compressed by
  the liquid column lifted into the tip [primary, BRAND technical note]. The
  delivered volume falls short by about ΔV ≈ V_D·ρgh/(p_a − ρgh), where V_D is
  the captive air volume and h the liquid height:

  | Liquid height h | V_D = 200 µL | V_D = 500 µL | V_D = 1500 µL |
  |---|---|---|---|
  | 20 mm | 0.39 µL | 0.97 µL | 2.90 µL |
  | 40 mm | 0.78 µL | 1.94 µL | 5.82 µL |

  These are [derived]. The mean bias can be calibrated out. Its variation with
  liquid height, temperature and humidity cannot, and that variation grows
  with V_D. So V_D is kept small: no tubing, and a short, narrow air path.
  Brennan et al. measured −50.71 µL (−5.07 %) at 1000 µL with a 3 mL syringe
  and tubing, attributed it to air expansion under the lifted water, and
  corrected it by scaling the printed graduations by 1.027 (to +0.36 %)
  [primary, Brennan et al. 2018, Table 1].

## 6. Purchased parts

Each kind of bought part is a registry of records. A record states a real,
orderable part, and a comment above it says where its numbers came from. A
value no source states is left `undef`, and reading it stops the build.

| Kind | Fields (draft) | Candidates |
|---|---|---|
| Piston | diameter and tolerance class, length, material, surface | Ground dowel pin, DIN 6325 / ISO 8734 m6, e.g. 6 mm is +0.004/+0.012 mm [secondary, Ganter datasheet]; precision ground stainless shaft g6/h6. **Open:** the diameters on offer limit the stroke choice. |
| Seal | inner diameter, cross-section, material, hardness, squeeze band | Metric and AS568 O-rings; PTFE seal plus O-ring energiser |
| Spring | outer diameter, wire, free length, rate, solid length | Measuring spring and blow-out spring as a pair |
| Spindle thread | thread, pitch, length, material | M3 / M4 / M5 stainless, or a fine pitch |
| Tip | brand, size, collar outer diameter, inner diameter at the mouth and 4 / 8 mm in, length | VWR, Ward's Science, generic, at 200 and 1000 µL. **Every dimension [measured]; none recorded yet.** |
| Fasteners | standard and size | As needed |

Published universal-tip collar diameters (about 6.1 mm for 200 µL tips and
7.4 mm for 1000 µL tips) are [secondary] and only used as a sanity check.
No standard fixes tip-cone geometry [secondary, Rainin].

**Tip measurement method:** for each brand and size, measure three tips from
one bag with calipers or pin gauges. Record the collar outer diameter, the
inner diameter at the mouth, the inner diameter 4 mm and 8 mm in, and the
overall length, with the date and the instrument.

## 7. Verification

- **Model gates:** `just check` and `just test` (see `AGENTS.md`). Geometry
  contracts with partspec are kept local while the design settles.
- **Bench:** gravimetric testing to ISO 8655-6.
  - Volumes: nominal, 50 % and 10 %.
  - At least 10 replicates per volume, with a tip change.
  - Room at 20 ± 3 °C, varying by no more than 0.5 °C during the test.
  - Relative humidity 45–80 %.
  - Mass converted to volume with the Z factor: 1.0029 µL/mg at 20 °C and
    101.3 kPa.
  - Evaporation corrected.

  These conditions are [secondary] and are confirmed from the standard before
  testing.
- **Open:** the balance resolution the standard requires per volume, and
  which balance the partner labs have.
- **Several units.** Test more than one unit, and more than one printer if
  possible. The published open designs report a single unit.

## 8. Prior work

| Design | Mechanism | Reported performance |
|---|---|---|
| Biropette, Baden et al. 2015 (v0 here) | Membrane, biro refill, printed step collar | ±2–10 µL, depending on printer |
| Brennan, Bokhari & Eddington 2018 | Disposable syringe as the cylinder; M3 bolt as the set stop; barbed Luer and Tygon tube to the tip | −5.07 % at 1000 µL on the syringe graduations, +0.36 % on a rescaled printed scale (section 5) |
| Chinchane, Kadam, Mowade & Pearce 2022 | Four 1 mL syringes under one plunger, 18 mm channel spacing; M3 bolt stop; silicone tube to the tip | 10 replicates per channel at 200 and 100 µL, one unit; the authors list the tube's flexibility and the 10 µL syringe graduations as limits |

The 2022 design is the starting reference for v2 (multichannel).

## 9. Open questions

1. **Upstream licence.** The upstream licence of Thingiverse things 255519
   and 257254 is unconfirmed. It decides how the v0 lineage can be licensed.
2. **Stroke length**, which is limited by the piston diameters actually on
   offer (section 6).
3. **Seal choice**, an O-ring or a PTFE seal with an O-ring, and the
   friction-versus-leak trade.
4. **Counter.** A printed scale or a mechanical digit counter for v1.
5. **Tip ejector.** Whether v1 has one.
6. **Tip dimensions**, which wait on the tip measurements (section 6).
7. **Balance and test site** at the partner labs.

## References

- Baden T. et al. (2015) Open Labware: 3-D printing your own lab equipment.
  *PLOS Biology* 13(3): e1002086. doi:10.1371/journal.pbio.1002086
- Brennan M.D., Bokhari F.F., Eddington D.T. (2018) Open design 3D-printable
  adjustable micropipette that meets the ISO standard for accuracy.
  *Micromachines* 9(4): 191. doi:10.3390/mi9040191
- Chinchane S., Kadam H., Mowade K., Pearce J.M. (2022) Open source 3D printed
  ISO 8655 compliant multichannel pipette. *Journal of Open Hardware* 6(1): 1.
  doi:10.5334/joh.36
- ISO 8655-2:2022 Piston-operated volumetric apparatus, Part 2: Pipettes.
  ISO 8655-6:2022 Part 6: Gravimetric reference measurement procedure. (Not
  yet in hand.)
- Gilson, Pipetman P user's guide (2009); Pipetman user's manual (2003).
- Eppendorf, Research plus operating manual; customer information on
  ISO 8655-2:2022.
- BRAND, technical note on air-displacement pipettes (captive-air model).
- Parker Hannifin, O-ring handbook: dynamic sealing.
