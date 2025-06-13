**Version:** 1.1.5

# PILE: table

Provides helper functions for Lua tables.


```lua
local pTable = require("path.to.pile_table")

local lut_foo = pTable.makeLUT({"foo", "bar", "baz"})
--> {foo=true, bar=true, baz=true}
```


## Dependencies

None.


# pTable API


## pTable.clear

Erases all keys in a table.

`pTable.clear(t)`

* `t`: The table to clear.


## pTable.clearArray

Erases a table's array indices.

`pTable.clearArray(t)`

* `t`: The table/array to clear.


## pTable.copy

Makes a "shallow" copy of a table. Sub-tables are copied as references.

`local copied = pTable.copy(t)`

* `t`: The table to copy.

**Returns:** The copied table.


## pTable.copyArray

Makes a copy of a table's array indices.

`local copied = pTable.copyArray(t)`

* `t`: The array to copy.

**Returns:** The copied array.


## pTable.deepCopy

Makes a recursive "deep" copy of a table.

`local copied = pTable.deepCopy(t)`

* `t`: The table to deep-copy.

**Returns:** The copied table.

**Notes:**

* There are many ways to copy a Lua table, and no single way covers all use cases. This is a pretty narrow implementation:
  * It does not handle tables as keys: `t = {[{true}] = "foo"}`
  * It does not handle loops ('A' referring to 'B' referring back to 'A'; the stack will overflow)
  * Multiple appearances of the same table in the source will generate unique tables in the destination.


## pTable.isArray

Checks that a table is an array, with indices from 1 to its highest integer key, with no gaps. Other keys are ignored.

`local ok pTable.isArray(t)`

**Returns:** `true` if the table has contiguous array indices, `false` otherwise.

**Notes:**

* This function treats tables with no integer indices as arrays that are empty.


## pTable.isArrayOnly

Checks that a table *only* contains array indices from 1 to its highest integer key, with no gaps and no additional hash keys.

`local ok = pTable.isArrayOnly(t)`

* `t`: The table to check.

**Returns:** True if the table contains only array indices, false otherwise.

**Notes:**

* This function treats empty tables as arrays that are empty.


## pTable.isArrayOnlyZero

Checks that a table, with the exception of index zero, *only* contains array indices from 1 to its highest integer key, with no gaps and no additional hash keys.

`local ok = pTable.isArrayOnlyZero(t)`

* `t`: The table to check.

**Returns:** True if the table contains only array indices (and optionally index 0), false otherwise.


## pTable.makeLUT

Makes a hash lookup table from an array.

`local lookup = pTable.makeLUT(t)`

* `t`: The array to convert.

**Returns:** The converted hash table.

**Notes:**

* For example:

```lua
local array = {"one", "two", "three"}
local hash = pTable.makeLUT(array)
--> {one=true, two=true, three=true}
```

## pTable.makeLUTV

Makes a hash lookup table from a varargs list.

`local lookup = pTable.makeLUTV(...)`

* `...`: Varargs to use as keys.

**Returns:** The converted hash table.

**Notes:**

* For example:

```lua
local hash = pTable.makeLUTV("four", "five", "six")
--> {four=true, five=true, six=true}
```


## pTable.invertLUT

Makes a inverted copy (keys and values swapped) of a hash table. The table must have unique values for all keys.

`local inverted = pTable.invertLUT(t)`

* `t`: The hash table to invert.

**Returns:** The inverted hash table.

**Notes:**

* The function will raise an error if duplicate values are encountered (`{a=1, b=1}`).


## pTable.arrayOfHashKeys

Given a hash table, makes an array of its keys.

`local array = pTable.arrayOfHashKeys(t)`

* `t`: The hash table.

**Returns:** An array of the input table's keys.

**Notes:**

* The array order is undefined.


## pTable.moveElement

Moves a table array element from one index to another.

`pTable.moveElement(t, i, j)`

* `t`: The array.

* `i`: The element's current index.

* `j`: The destination index.

**Notes:**

* Both `t[i]` and `t[j]` must be populated (that is, not nil).

* Performance may be poor when moving many low indices in extremely large arrays.


## pTable.swapElements

Swaps two array elements in a table.

`pTable.swapElements(t, i, j)`

* `t`: The array.

* `i`: The first index.

* `j`: The second index.

**Notes:**

* Both `t[i]` and `t[j]` must be populated (that is, not nil).


## pTable.reverseArray

Reverses the contents of an array.

`pTable.reverseArray(t)`

* `t`: The array to reverse.


## pTable.assignIfNil

If `table[key]` is nil, assigns the first non-nil value from a vararg list.

`pTable.assignIfNil(t, k, ...)`

* `t`: The target table.
* `k`: The target key.
* `...`: A list of values to consider. The first non-nil value is assigned.

**Notes:**

* For example:

```lua
local t = {}
pTable.assignIfNil(t, "foo", nil) -- (No change)
pTable.assignIfNil(t, "foo", "bar", "zoop") --> t[foo] = "bar"
pTable.assignIfNil(t, "foo", false) --> t[foo] = false
```


## pTable.assignIfNilOrFalse

If *table[key]* is nil or false, assigns the first non-nil, non-false value from a vararg list.

`pTable.assignIfNilOrFalse(t, k, ...)`

* `t`: The target table.
* `k`: The target key.
* `...`: A list of values to consider. The first non-nil, non-false value is assigned.

**Notes:**

* For example:

```lua
local t = {foo=false}
pTable.assignIfNil(t, "foo", nil) -- (No change)
pTable.assignIfNil(t, "foo", true, 100) --> t[foo] = true
pTable.assignIfNil(t, "foo", false) -- (No change)
```
