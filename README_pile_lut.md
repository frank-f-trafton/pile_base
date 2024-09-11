**Version:** 1.0.0

# PILE: lut


*lut* makes hash lookup tables from arrays.


```lua
local lut = require("path.to.pile_lut")

local lut_foo = lut.make({"foo", "bar", "baz"})

--> {foo=true, bar=true, baz=true}
```


# lut API

## lut.make

Makes a hash lookup table from an array. The hash table's keys are values from the array, and its values are all `true`.

`local lookup = lut.make(t)`

* `t`: The array to convert.

**Returns:** A converted hash table.


## lut.invert

Makes a inverted copy (keys and values swapped) of a hash table. The table is expected to have unique values for all keys.

`local inverted = lut.invert(t)`

* `t`: The hash table to invert.

**Returns:** The inverted hash table.

**Notes:**

* A table that contains the same value for multiple keys is treated as an error.
