**Version:** 1.1.0

# PILE: table


*pTable* provides helper functions for Lua tables.


```lua
local pTable = require("path.to.pile_table")

local lut_foo = pTable.makeLUT({"foo", "bar", "baz"})

--> {foo=true, bar=true, baz=true}
```


# pTable API


## pTable.isArray

Checks if a table contains array indices from 1..n, with no gaps. Other keys are ignored.

`local ok pTable.isArray(t)`

**Returns:** `true` if the table contains array indices in the range of 1..n with no gaps, `false` otherwise.


## pTable.isArrayOnly

Checks if a table contains *only* array indices from 1..n, with no gaps and no additional hash keys.

`local ok = pTable.isArrayOnly(t)`

* `t`: The table to check.

**Returns:** `true` if the table contains only array indices, `false` if it contains non-integral indices, or is sparse (has gaps), or has hash keys.


## pTable.makeLUT

Makes a hash lookup table from an array. The hash table's keys are values from the array, and its values are all `true`.

`local lookup = pTable.makeLUT(t)`

* `t`: The array to convert.

**Returns:** A converted hash table.


## pTable.invertLUT

Makes a inverted copy (keys and values swapped) of a hash table. The table is expected to have unique values for all keys.

`local inverted = pTable.invertLUT(t)`

* `t`: The hash table to invert.

**Returns:** The inverted hash table.

**Notes:**

* The function will raise an error if duplicate values are encountered (`{a=1, b=1}`).
