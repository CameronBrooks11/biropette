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
   │ hollow threaded sleeve│ ── sets the UPPER stop; turning it sets the stroke
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

### 4.1 The stop chain

The volume is set with a **hollow threaded sleeve**, in the manner of a
commercial micrometer pipette. The parts that set the stroke form a closed
chain of metal parts:

```
            knob (printed, clamped to the sleeve; carries the scale)
   ┌──────────────┐
   │ hollow sleeve│  turns in the nut; its lower face is the UPPER STOP
   │   ┌──────┐   │
   │   │ nut  │   │  fixed in the body
   │   └──┬───┘   │
   │   spacer     │  metal: carries the first-stop seat
   │      │       │
   │   collar ↕   │  clamped on the plunger rod; travels between the stops
   │   ───────    │  ← first-stop washer, held up against the seat by
   │   blow-out   │    the preloaded blow-out spring
   │   spring     │
   └──────────────┘
```

- **The chain.** The stroke is the gap between the sleeve's lower face and
  the first-stop washer, less the collar's thickness. Every part in that loop
  is metal: sleeve, nut, spacer, washer and collar. The blow-out spring's
  preload holds the chain closed against the nut, so the printed body only
  has to keep the nut from coming out. The body is outside the loop.
- **Why printed parts are kept out of it.** A printed part in the loop adds
  its thermal expansion and creep to the stroke. PLA expands about
  68 × 10⁻⁶ /K [secondary, typical datasheet value]. Over a 30 mm span that
  is about 2 µm/K [derived], against a stroke budget of about 45 µm (§5).
  Creep under the spring preload has no budget at all.
- **Preload.** The blow-out spring's preload must exceed the measuring
  spring's force at full stroke plus the thumb force a user applies at the
  first stop. Otherwise the washer leaves its seat and the first stop moves.
- **Calibration offset.** The knob is clamped to the sleeve. Loosening it and
  turning it re-zeroes the scale without moving the stop, as Gilson's
  recalibration does [primary, Pipetman P manual]. The gain is set by the
  scale (§5).
- **Plunger rod and piston.** These are separate parts, because stock decides
  it:
  - The largest bought hollow sleeve found has about a 7 mm bore (an M10×1
    lamp tube [secondary]), and no bought sleeve clears an 8 mm pin.
  - DIN 6325 Ø4 pins stop at 40 mm long [secondary, supplier listings].

  So a Ø4 stainless rod passes through the sleeve and carries the collar
  and, below, the piston pin. The pin has its own guide and seal, so the
  joint between rod and pin can float. The collar is clamped where assembly
  puts it: its position sets nothing.

### 4.2 Forces and seal friction

What a user's thumb feels is set by the springs and the seal friction:

| Quantity | P200 | P1000 | Source |
|---|---|---|---|
| Commercial force to the first stop | 4.2–7.0 N | 8.7 N | [primary] Lichty et al. 2011 (200 µL); Asundi et al. 2005 (Gilson P-1000) |
| Commercial blow-out force | 11.8–32.4 N | 20–35 N | same |
| Recommended ceiling | 15.7 N | 15.7 N | [primary, vendor] Rainin: 20 % of women's pinch strength |
| Seal running friction (planning estimate) | 1.55 N | 3.09 N | [derived] Parker f_c at 10 % squeeze × π·d |

The springs have to satisfy four conditions at once:

1. **Return.** The measuring spring at the upper stop must beat seal friction
   by a margin. Otherwise the piston stops short and the pipette draws less
   than it is set to.
2. **First stop.** The spring force at the first stop plus friction must stay
   near commercial forces.
3. **Blow-out step.** The blow-out preload must exceed the measuring force by
   a step the thumb feels.
4. **Blow-out end.** The force at the end of blow-out must stay under the
   ceiling.

The window between them is set by friction. With the Gutekunst springs
registered, `just report` shows:

- **P200** is just inside the window: 6.8 N at the first stop. The return
  margin and the blow-out ceiling are each missed by a few tenths of a
  newton.
- **P1000** does not close at the estimated friction: 12.1 N at the first
  stop, against a commercial 8.7 N.

The friction figure comes from Parker's coefficients for lubricated
hydraulic service, so it is a planning estimate. **Measuring the real
friction of the seal is therefore the next experiment.** The springs are
chosen after it.

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
- **Sleeve pitch.** Volume per turn is piston area × pitch [derived,
  `just report`]:

  | Size | Volume per turn (M10×1 sleeve) | Turns over the range |
  |---|---|---|
  | P200 (Ø4) | 12.6 µL | 14.3 |
  | P1000 (Ø8) | 50.3 µL | 17.9 |

  With these figures, a 22 mm knob puts the graduations 1.1 mm apart
  (P200, 0.2 µL) and 2.75 mm apart (P1000, 2 µL).
- **Volume is not a whole number of turns.** Piston area involves π, so no
  standard pitch gives a whole number of microlitres per turn. The scale is
  therefore drawn from the computed volume per turn, as a helix read
  against a fixed index. It is not a fixed count of marks per turn.
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

- **Pin tolerance is a gain error.** Volume scales with d², so the pin's
  m6 band scales every reading. A calibration offset cannot remove it. The
  numbers are [derived] by `just report`:
  - A scale built on the nominal diameter would deliver 0.40 % more than set
    on a 4 mm pin, which is 0.8 µL of the P200's ±1.6 µL. On an 8 mm pin it
    is 0.26 %, or 2.6 µL of the P1000's ±8 µL.
  - Built on the middle of the band, the scale leaves ±0.2 % (±0.4 µL) on the
    P200 and ±0.11 % (±1.1 µL) on the P1000.
  - So the scale uses the band's middle diameter, and the calibration
    procedure needs a gain check at two volumes, not only an offset.

## 6. Purchased parts

Each kind of bought part is a registry of records. A record states a real,
orderable part, and a comment above it says where its numbers came from. A
value no source states is left `undef`, and reading it stops the build.

| Kind | Fields (draft) | Candidates |
|---|---|---|
| Piston | diameter and tolerance class, length, material, surface | Ground dowel pin, DIN 6325 / ISO 8734 m6, e.g. 6 mm is +0.004/+0.012 mm [secondary, Ganter datasheet]; precision ground stainless shaft g6/h6. **Open:** the diameters on offer limit the stroke choice. |
| Seal | inner diameter, cross-section, material, hardness, squeeze band | Metric and AS568 O-rings; PTFE seal plus O-ring energiser |
| Spring | wire, outer diameter, largest pin it fits over, free length, minimum length, force there, rate | Gutekunst stainless stock springs: six measuring and six blow-out candidates (`cad/purchased/springs.scad`) |
| Sleeve | thread, pitch, outer and inner diameter, material, length | M10×1 hollow lamp tube (bore about 7 mm; measure it), 1/8-27 IPS thin-wall nipple. Fully threaded stock lengths are still open. |
| Collar | bore, outer diameter, width, screw | Ruland MSC-4-SS (Ø4 bore, OD 8, 5 wide) |
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

1. ~~Upstream licence~~: settled. Both Thingiverse things are CC BY-SA 4.0,
   so v0 keeps that licence and v1 follows the lab policy (`LICENSING.md`).
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
