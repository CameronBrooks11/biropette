// Key-value records: [["name", "..."], ["key", value], ...].
//
// get() stops the build on a missing key or an undef value, so a number no
// source states cannot reach the geometry. known() lets the report say
// "cannot evaluate yet" instead of stopping.

function _idx(s, k) = [for (i = [0:1:len(s) - 1]) if (s[i][0] == k) i];

function _name(s) = let(i = _idx(s, "name")) len(i) == 1 ? s[i[0]][1] : "?";

function has(s, k) = len(_idx(s, k)) == 1;

function known(s, k) = has(s, k) && !is_undef(s[_idx(s, k)[0]][1]);

function get(s, k) =
  let(i = _idx(s, k))
  assert(len(i) == 1, str("record '", _name(s), "' has no key '", k, "'"))
  assert(!is_undef(s[i[0]][1]),
         str("'", k, "' of '", _name(s), "' is not known yet: measure it or cite a source"))
  s[i[0]][1];

// The keys of a record that are still undef.
function unknown_keys(s, keys) = [for (k = keys) if (!known(s, k)) k];

function by_name(rows, name) =
  let(m = [for (r = rows) if (get(r, "name") == name) r])
  assert(len(m) == 1,
         str(len(m) == 0 ? "no record named '" : "more than one record named '", name, "'"))
  m[0];
