// Volume-setting spindle threads. The thread sets the upper stop, so it is
// a bought metal part (docs/design.md section 4).
//
// [primary] ISO 261 / ISO 262 metric coarse pitches.
// material: [reasoned] stainless A2, because pipettes are wiped with
// ethanol and bleach.

function _thread(d, pitch) = [
  ["name", str("M", d)],
  ["standard", "ISO 261 coarse"],
  ["d", d],
  ["pitch", pitch],
  ["material", "stainless A2"],
];

threads = [_thread(3, 0.5), _thread(4, 0.7), _thread(5, 0.8), _thread(6, 1.0)];
