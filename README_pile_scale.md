VERSION: 2.023

# PILE Scale

*pScale* scales numbers.


```lua
local pScale = require("pile_scale")

local n = pScale.number(2.0, 30) --> n == 60

local t = {x=2, y=3, w=32, h=16}
pScale.fieldInteger(2.0, t, "x") --> t.x == 4
pScale.fieldInteger(2.0, t, "y") --> t.y == 6
pScale.fieldInteger(2.0, t, "w") --> t.w == 64
pScale.fieldInteger(2.0, t, "h") --> t.h == 32
```


# Dependencies

* `pile_assert.lua`

* `pile_name.lua`


# API: PILE Scale

## pScale.number

Scales a number.

`local n = pScale.number(scale, v, [min], [max])`

* `scale`: The scale to use.

* `v`: The number to scale.

* `[min]`: An optional minimum limit on the return value.

* `[max]`: An optional maximum limit on the return value.

**Returns:** The scaled number.


## pScale.integer

Scales and floors a number.

`local n = pScale.integer(scale, v, [min], [max])`

* `scale`: The scale to use.

* `v`: The number to scale.

* `[min]`: An optional minimum limit on the return value.

* `[max]`: An optional maximum limit on the return value.

**Returns:** The scaled and floored number.


## pScale.fieldNumber

Scales a number in a table.

`pScale.fieldNumber(scale, t, k, [min], [max])`

* `scale`: The scale to use.

* `t`: The table.

* `k`: The key, such that indexing `t[k]` provides a number.

* `[min]`: An optional minimum limit on the scaled number.

* `[max]`: An optional maximum limit on the scaled number.


## pScale.fieldInteger

Scales and floors a number in a table.

`pScale.fieldInteger(scale, t, k, [min], [max])`

* `scale`: The scale to use.

* `t`: The table.

* `k`: The key, such that indexing `t[k]` provides a number.

* `[min]`: An optional minimum limit on the scaled number.

* `[max]`: An optional maximum limit on the scaled number.


# Notes

* All functions reject NaN for the scale, value, minimum, and maximum.

* In the 'integer' functions:

  * The input number does not have to be an integer.

  * Flooring is applied after clamping.
