"""Sizing figures quoted in docs/design.md. Run: python3 scripts/sizing.py"""
from math import pi, sqrt

# ISO 8655-2 limits at nominal volume, single channel, absolute (uL):
# (systematic, random). Rows for 200 and 1000 uL as reproduced by Gilson.
ISO = {200: (1.6, 0.6), 1000: (8.0, 3.0)}

print("== piston diameter for a given nominal volume and stroke ==")
print(f"{'V_nom uL':>8} {'stroke mm':>9} {'d mm':>6} {'uL/mm':>7} "
      f"{'sd_stroke mm (random limit)':>28} {'mm per display step':>20}")
STEP = {200: 0.2, 1000: 1.0}  # commercial display increments, uL
for v in (200, 1000):
    for L in (12, 15, 20):
        a = v / L                      # mm^2 (1 uL = 1 mm^3)
        d = sqrt(4 * a / pi)
        sd = ISO[v][1] / a             # stroke sd that alone uses the whole random limit
        print(f"{v:>8} {L:>9} {d:>6.2f} {a:>7.2f} {sd:>28.3f} {STEP[v]/a:>20.4f}")

print("\n== volume per spindle turn (uL) for ISO coarse pitches ==")
for v, L in ((200, 15), (1000, 15)):
    a = v / L
    print(v, {p: round(a * p, 2) for p in (0.5, 0.7, 0.8)})

print("\n== captive-air bias: dV ~= V_D * rho*g*h / (p_a - rho*g*h) ==")
rho, g, pa = 998.2, 9.81, 101325.0
for h_mm in (20, 40):
    p = rho * g * h_mm / 1000
    for vd in (200, 500, 1500):
        dv = vd * p / (pa - p)
        print(f"h={h_mm} mm V_D={vd} uL -> bias {dv:.2f} uL  (rho g h / p_a = {100*p/pa:.3f} %)")
