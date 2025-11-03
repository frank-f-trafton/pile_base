**Version:** 1.315

# PILE Interp

*interp* interpolates strings with position-independent arguments.


```lua
local interp = require("path.to.pile_interp")

print(interp("The $1 brown fox $3 over the lazy $2.", "quick", "dog", "jumps"))

-->The quick brown fox jumps over the lazy dog.
```


## Dependencies

None.


# Interp API

## interp

Interpolates up to nine varargs in a string.

`local interpolated = interp(s, ...)`

* `s`: The string to inject values into. The insertion points for arguments are `$1` for the first, `$2` for the second, up to `$9`.

* `...`: Varargs list of values. All values are converted to strings.

**Returns:** The interpolated string.

**Notes:**

* `$` can be escaped in `s` by writing `$$`.

* If you need to interpolate more than `$1` - `$9`, consider breaking the message into smaller strings, or use `string.gsub()` directly with a replacement table.
