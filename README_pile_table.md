**Version:** 1.201

# PILE: Table

Provides helper functions for Lua tables.


```lua
local pTable = require("path.to.pile_table")

local lut_foo = pTable.makeLUT({"foo", "bar", "baz"})
--> {foo=true, bar=true, baz=true}
```


## Dependencies

* `pile_interp.lua`


# Table API


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
  * It does not handle loops ('A' referring to 'B' referring back to 'A'); the Lua stack will overflow.
  * Multiple appearances of the same table in the source will generate unique tables in the copy.


## pTable.patch

Given two tables, copies values from the second table to the first.

`pTable.patch(a, b, overwrite)`

* `a`: The table to be modified.
* `b`: The table with patch values.
* `overwrite`: When true, existing values in `a` are overwritten by those in `b` with matching keys. When false, existing values in `a` (including `false`) are preserved.


**Returns:** A count of how many fields were overwritten (or if `overwrite` is false, then how many fields were *not* overwritten).

**Notes:**

* Sub-tables within `b` are copied by reference to `a`.


## pTable.deepPatch

Given two tables, recursively copies values from the second table to the first. The procedure runs on all table values in the patch table. If the destination table is lacking a sub-table that is present in the patch table, then a new table will be assigned.

`pTable.deepPatch(a, b, overwrite)`

* `a`: The table to be modified.
* `b`: The table with patch values.
* `overwrite`: When true, existing values in `a` are overwritten by those in `b` with matching keys. When false, existing values in `a` (including `false`) are preserved.

**Notes:**

* Limitations:
  * All tables involved *must* be unique.
  * It does not support tables as keys.
  * It can modify, but not replace existing tables in the destination.


## pTable.hasAnyDuplicateTables

Checks a list of tables for duplicate table references.

`local t = pTable.hasAnyDuplicateTables(...)`

* `...`: A vararg list of tables to check.

**Returns:** The first duplicate table encountered, or nil if there are no duplicates.

**Notes:**

* Does not check metatables.


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


## pTable.removeElement

Removes elements from an array that are equal to a value, iterating backwards from the last entry.

`local count = pTable.removeElement(t, v, [n])`

* `t`: The table to scan.
* `v`: The value to be removed.
* `[n]`: (*math.huge*) How many elements to remove in this call.

**Returns:** The number of elements removed.


## pTable.valueInArray

Checks if a value is in an array.

`local index = pTable.valueInArray(t, v, [i])`

* `t`: The array to check.
* `v`: The value.
* `[i]`: (*1*) The starting index.

**Returns:** The index of the value when found, or nil if it was not found.


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
pTable.assignIfNil(t, "foo", false) --> (No change)
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


## pTable.resolve

Looks up a value in a nested table structure by following a string of fields delimited by slashes (`/`).

`local value, count = pTable.resolve(t, str, [raw])`

* `t`: The starting table.
* `str`: The string of delimited fields to check.
* `[raw]`: When true, uses `rawget()` to read table fields (thus ignoring the mechanisms of Lua metatables).

**Returns:** 1) The resolved value or `nil`, followed by 2) the count of delimited fields when the search stopped.

**Notes:**

* The call `local v = pTable.resolve(tbl, "foo/bar")` is analogous to `local v = tbl.foo.bar`.

* The function will raise a Lua error if `t`'s starting value is not a table, or if any of the fields are empty (like `foo//bar`).


## pTable.assertResolve

A wrapper for `pTable.resolve()` which raises a Lua error if no value was found.

`local value, count = pTable.assertResolve(t, str, [raw])`

* `t`: The starting table.
* `str`: The string of delimited fields to check. Cannot be an empty string.
* `[raw]`: When true, uses `rawget()` to read table fields (thus ignoring the mechanisms of Lua metatables).

**Returns:** 1) The resolved value or `nil`, followed by 2) the count of delimited fields when the search stopped.


## pTable.mt_restrict

A metatable that raises an error when accessing or assigning unpopulated fields in a table *(see notes)*.

```lua
my_table = {foo=1, bar=2}
setmetatable(my_table, pTable.mt_restrict)
my_table.foo = 3
my_table.zut = 4 -- Error
```

### Notes

This metatable is similar in purpose to the ([strict.lua](https://www.lua.org/extras/)) snippet, but it has enough differences in behavior that it cannot be treated as a drop-in replacement.

`mt_restrict` cannot do anything about the usage of `rawget()` or `rawset()`.

The behavior of `table.insert()` changed in Lua 5.3, as the langauge designers updated the `table` library to respect metamethods.
