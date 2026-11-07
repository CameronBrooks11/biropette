// Stop collars clamped on the plunger rod. The collar travels between the
// sleeve's lower face (upper stop) and the first-stop washer.
//
// [primary] Ruland set-screw collar catalogue page
// (https://www.isccompanies.com/wp-content/uploads/2020/12/Set-Screw-Collar.pdf).
// A set screw bites a stainless rod; it will not bite a hardened pin, which
// is one reason the collar sits on the rod and not on the piston pin.

function _collar(name, bore, od, width, screw) = [
  ["name", name],
  ["maker", "Ruland"],
  ["bore", bore],
  ["od", od],
  ["width", width],
  ["screw", screw],
  ["material", "stainless"],
];

collars = [_collar("ruland_msc_4_ss", 4, 8, 5, "M2.5x3")];
