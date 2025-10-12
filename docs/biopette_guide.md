# Biopette: 3D Printed, Customizable High Precision Pipette

**Version:** pipette v15  
**Date:** February 23, 2014  
**Author:** Tom Baden  
**Institution:** Centre for Integrative Neuroscience (CIN), University of Tübingen, Germany

**Contact:** thomas.baden@uni-tuebing​en.de  
**Thingiverse ID:** tbaden  
**Website:** http://tombaden.wordpress.com/

---

## Overview

[IMAGE_1: Overview of three different pipette versions]

Biopette is an open-source design for a 3D-printable, high-precision pipette that can be customized for your specific laboratory needs. The pipette features:

- **Vanilla version** ("expunger = 0"): Basic configuration
- **Full version**: Complete pipette with membrane displacement mechanism
- **Cross-section version** ("cross-section = 1"): For detailed inspection

All versions can be printed on a standard 3D printer (Felix printer shown, ~3 hours at normal quality without supports).

---

## Background

This design was inspired by the "Straw pipette" by Konrad Walus (University of British Columbia, Vancouver, CA) available on Thingiverse (http://www.thingiverse.com/thing:64977). Biopette extends this concept with enhanced precision and customization options.

This project is part of **Science in Africa NGO** and **TRenD in Africa gUG** initiatives to help design cheap, accessible laboratory equipment for resource-limited settings.

- **TRenD in Africa:** http://trendinafrica.org/
- **Open-source projects:** http://trendinafrica.org/activities/open-source/open-source-main/

---

## Part List

[IMAGE_2: Detailed part list showing components A through G]

### Required Components:

| Part         | Description                  | Notes                                                                                        |
| ------------ | ---------------------------- | -------------------------------------------------------------------------------------------- |
| A            | Main body (blue)             | Requires careful printing for air-tightness                                                  |
| B            | Body connector               | Must be properly air-tight                                                                   |
| C            | Membrane pin (head)          | Determines volume range; key component for displacement                                      |
| D            | Main plunger rod             | Part of the expulsion mechanism                                                              |
| E            | Plunger collar/ring          | Surrounds D; slide-fits over plunger                                                         |
| F            | Plunger connector            | Interfaces between plunger and top assembly                                                  |
| G            | Top corner piece             | Assists with assembly alignment                                                              |
| Screw        | M5 flat-head screw           | Adjust "screw radius" variable to match your thread                                          |
| Spring       | Standard biro spring         | 1 spring for "vanilla" version; 2 springs for "full version"                                 |
| Tubing       | Custom inner diameter tubing | Metal or plastic (e.g., PVC); measure diameter and enter as "shaft radius" customizer option |
| Membrane     | Strong, flexible material    | Lab glove, balloon, condom, or similar                                                       |
| Tape         | Descent tape or Parafilm     | For sealing                                                                                  |
| Instant glue | Or similar adhesive          | Optional "runny" type for getting into cracks                                                |
| Grease       | Optional                     | Only needed if components don't slide properly                                               |

---

## Volume and Calibration Calculations

[IMAGE_3: Calculation diagrams and formulas]

### Determining Volume Range

The volume range is primarily determined by the membrane pin (part C), which sits on the bottom of the main axis and displaces the membrane.

**Key Formula:**

$$V_T = Z \times \pi \times r^2$$

Where:

- **V_T** = Total volume
- **Z** = Button range (in mm)
- **r** = Radius of part C (in mm)

**Volume per step (V_s):**

$$V_s = \frac{Z \times \pi \times r^2}{S}$$

Where:

- **S** = Number of steps (default = 5)

### Default Settings Example:

- r = 3 mm = 3 × 10⁻³ m
- Z = 10 mm = 10² × 10⁻³ m
- S = 10 steps

$$V_T = 10^{-2} \text{ m} \times 3.141 \times 9 \times 10^{-6} \text{ m}^2$$
$$= 2.83 \times 10^{-4} \text{ m}^3$$
$$= 283 \text{ μL}$$

$$V_s = \frac{283 \text{ μL}}{10} = 28.3 \text{ μL}$$

**Actual working volume ≈ 200 μL** (accounting for the semi-sphere of part C and practical factors)

### Quick Calculation Tip:

Simply type the formula into Google:  
`"10mm * pi * (3mm)^2"`

Google will conveniently return the answer in milliliters, eliminating log unit errors.

### Calibration:

For accurate calibration, use high-precision scales with distilled water (1 mg ≈ 1 μL). If high-precision scales aren't available, dispense 10-100 times into a container and rescale accordingly. Note that the step progression is quite linear, so you don't need to calibrate every step individually; simply divide V_T by (nSteps-2).

---

## Assembly Instructions

### Assembly 1/5: Installing the Tip

[IMAGE_4: Step-by-step assembly of the pipette tip]

**Steps:**

1. Measure your tubing inner diameter and cut to appropriate length
2. Ensure the tubing fits snugly into part B
3. Position tubing so there are a few millimeters of space between part G and the tip when mounted
4. Apply superglue to secure the tube in place (use copious amounts to seal any air escapes)

**Key Point:** Part B must be completely air-tight, as this is the most critical component. If your pipette is leaky, part B is almost certainly the culprit.

**Printing Note:** Oozy Wellemann K8200 prints work better than precise Felix prints for part B; the additional material fills small cracks naturally.

---

### Assembly 2/5: Installing the Spring and Plunger

[IMAGE_5: Assembly of spring and plunger mechanism]

**Steps:**

1. Prepare parts A, C, D, and E
2. Insert the spring onto the biro filling, ensuring it goes on the correct end
3. Add the screw (not tight) and insert into the biro filling base first
4. Slip part C onto the bottom; it should protrude slightly
5. If part C doesn't stick to the biro filling by itself, apply a small amount of glue

**Note 1:** Part C may need tab glue if it doesn't stick to the biro filling independently.

**Note 2:** If the spring mechanism is too weak, add a washer or other support under the spring. The spring range should be at least as great as your part E height (Range Z, default = 10 mm).

---

### Assembly 3/5: Installing the Plunger Assembly

[IMAGE_6: Assembly of parts D and E into the pipette body]

**Steps:**

1. Combine parts D and E as shown
2. Ensure the screw is straight and properly positioned
3. Superglue parts D and E together
4. Slide the assembled unit over the top of the pipette body

**Note:** Part D may need tab glue if it doesn't stick to the biro filling independently.

---

### Assembly 4/5: Installing the Membrane

[IMAGE_7: Installing and securing the flexible membrane]

**Steps:**

1. Prepare your flexible membrane material (lab glove, balloon, condom, etc.)
2. Stretch the membrane tautly over the top of the pipette body
3. Part C should bulge slightly through the membrane
4. Slide the membrane over the bottom part
5. Cut away excess membrane
6. Secure with tape (insulation tape, Parafilm, or similar)

**Key Point:** The membrane must be stretched taut over part C so it bulges slightly. If it doesn't bulge, slip a washer or similar object underneath to create the necessary protrusion.

---

### Assembly 5/5: Final Assembly

[IMAGE_8: Final assembly steps with parts F and G]

**Steps:**

1. Prepare parts F and G (these are the final connector pieces)
2. Load the biro filling mechanism as before (spring on wrong side, add washer if needed)
3. Slip part F over the plunger assembly (glue if necessary)
4. Add part G (glue if necessary)
5. Ensure everything slides smoothly

**Troubleshooting:**

If components don't slide properly:

- Ream with a Dremel
- Apply grease
- Try a lighter tolerance setting when printing

If the pipette is too wobbly or jiggly:

- Try printing with lower "tolerance" setting (customizer option)
- If nothing moves, increase tolerance

The pipette should feel stable but not stiff. All steps should move quite linearly.

---

## Different Versions and Prototypes

[IMAGE_9: Multiple printed versions showing variations]

### Production Versions (Felix and Wellemann K8200 printers):

- **Full version with yellow tip** (Felix printer): 10 mm Z, 3 mm r
- **Full version with yellow tip** (Wellemann K8200): 15 mm Z, 3 mm r, sealed with insulation tape
- **Vanilla version with blue tip** (mounted on PVC tube): 5 mm Z, 5 mm r, sealed with Parafilm

### Prototype Versions:

Various custom configurations showing the modularity and flexibility of the design. These demonstrate different tip materials, housing modifications, and membrane configurations.

---

## Calibration Data

[IMAGE_10: Graph showing calibration curves]

### Quick and Dirty Weight Calibration of Two Different Makes

Both pipettes tested approximate a P200 and show quite linear behavior across the operating range.

**Calibration Graph:**

The graph shows two calibration curves (marked with filled and open circles) testing different printer makes. Both exhibit linear relationships between pipette setting and dispensed volume, with slopes indicating they perform comparably to commercial P200 pipettes.

---

## Customization Options

The design includes several customizer variables that allow you to adapt the pipette to your needs:

- **Range Z** (default: 10 mm): Height of the displacement mechanism
- **Range Steps** (default: 10): Number of discrete steps for plunger movement
- **Shaft Radius**: Diameter of your tubing (measure and enter for accurate fit)
- **Screw Radius**: Adjust to match your M5 (or other) screw thread
- **Cross-section**: Set to 1 for cross-sectional view to inspect internal geometry

---

## Troubleshooting Guide

| Problem                         | Likely Cause                    | Solution                                              |
| ------------------------------- | ------------------------------- | ----------------------------------------------------- |
| Pipette is leaky                | Part B is not air-tight         | Reprint with higher infill; try "oozy" print settings |
| Components don't slide smoothly | Tight tolerances                | Ream with Dremel; apply grease                        |
| Pipette feels wobbly            | High tolerance setting          | Reprint with lower tolerance                          |
| Nothing moves                   | Too-tight tolerances            | Increase tolerance setting                            |
| Spring is too weak              | Insufficient spring compression | Add washer or shim under spring                       |
| Membrane doesn't bulge          | Part C doesn't protrude enough  | Add washer under part C                               |

---

## Resources and Further Information

**Project Links:**

- Science in Africa NGO: http://trendinafrica.org/
- Open-source equipment initiatives: http://trendinafrica.org/activities/open-source/open-source-main/
- Original inspiration - Straw Pipette: http://www.thingiverse.com/thing:64977

**Files Available:**

- All design files (SCAD and STL) available on Thingiverse
- Customizer variables allow for easy parameter adjustment
- Cross-section versions available for design inspection

---

## Citation

If you use or modify this design, please credit:

**Tom Baden**, Centre for Integrative Neuroscience (CIN), University of Tübingen, Germany

Design inspired by the "Straw Pipette" by Konrad Walus, University of British Columbia, Vancouver, CA.

---

## Acknowledgments

This project is part of the **TRenD in Africa** initiative to develop and distribute cheap, high-quality laboratory equipment for scientific research in resource-limited settings. We welcome contributions, modifications, and feedback from the scientific and maker communities.
