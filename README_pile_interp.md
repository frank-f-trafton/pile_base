**Version:** 1.1.0

# PILE: interp


*interp* interpolates strings with position-independent arguments.


```lua
local interp = require("path.to.pile_interp")

print(interp("The $1 brown fox $3 over the lazy $2.", "quick", "dog", "jumps"))

-->The quick brown fox jumps over the lazy dog.
```


# interp API

## interp

Interpolates up to nine varargs in a string.

`local interpolated = interp(s, ...)`

* `s`: The string to inject values into. The insertion points for arguments are `$1` for the first, `$2` for the second, up to `$9`.

* `...`: Varargs list of values. All values are converted to strings.

**Returns:** The interpolated string.

**Notes:**

* `$` can be escaped in `s` by writing `$$`.

* If you need to interpolate more than `$1` - `$9`, you should consider either breaking the message into smaller strings, or using `string.gsub()` directly with a replacement table. `interp()` can be modified to accept additional character values such as `$:` (ASCII byte 058; argument #10), but it's an ugly hack.
