VERSION: 2.023

# PILE Assert


*pAssert* provides Lua assertions with (mostly) apropos error messages.


```lua
local pAssert = require("pile_assert")

local function aStringCalledFoobar(a)
	pAssert.type(1, a, "string")

	return a == "foobar"
end

aStringCalledFoobar(1)
--> stdin:1: argument #1: bad type (expected string, got number)
```


## Dependencies

* `pile_interp.lua`

* `pile_name.lua`


# The PILE Assert Function Signature

All PILE Assert functions share these first two arguments:

`pAssert.someFunction(n, v)`

* `n`: The name tag (typically an argument count).

* `v`: The value to check.

If the value passes, nothing happens. If a problem is determined, then the assertion will *(surprise!)* raise a Lua error.

The name tag can be used in a few different ways. For more info, see the section **Uses of Name Tags** near the bottom of this README.


# API: PILE Assert

## pAssert.type

The value is one Lua type.

`pAssert.type(n, v, e)`

* `n`: The name tag.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pAssert.typeEval

The value is false/nil, or one Lua type.

`pAssert.typeEval(n, v, e)`

* `n`: The name tag.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pAssert.types

The value is one of various Lua types.

`pAssert.types(n, v, ...)`

* `n`: The name tag.

* `v`: The value to check.

* `...`: A vararg list of accepted type strings (`"boolean"`, etc.)


## pAssert.typesEval

The value is false/nil, or one of various Lua types.

`pAssert.typesEval(n, v, ...)`

* `n`: The name tag.

* `v`: The value to check.

* `...`: A vararg list of accepted type strings (`"boolean"`, etc.)


## pAssert.oneOf

The value matches one of any values in a vararg list.

`pAssert.oneOf(n, v, id, ...)`

* `n`: The name tag.

* `v`: The value to check.

* `id`: What to the call the list in error messages.

* `...`: Vararg list of values to check.


## pAssert.oneOfEval

The value is false/nil, or it matches one of any values in a vararg list.

`pAssert.oneOfEval(n, v, id, ...)`

* `n`: The name tag.

* `v`: The value to check.

* `id`: What to the call the list in error messages.

* `...`: Vararg list of values to check.


## pAssert.numberNotNaN

The value is a number that isn't NaN.

`pAssert.numberNotNaN(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.numberNotNaNEval

The value is false/nil, or a number that isn't NaN.

`pAssert.numberNotNaNEval(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.numberGE

The value is a number that is greater or equal to a minimum value.

`pAssert.numberGE(n, v, min)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.numberGEEval

The value is false/nil, or a number that is greater or equal to a minimum value.

`pAssert.numberGEEval(n, v, min)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.numberRange

The value is a number within a specified range.

`pAssert.numberRange(n, v, min, max)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.numberRangeEval

The value is false/nil, or a number within a specified range.

`pAssert.numberRangeEval(n, v, min, max)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.integer

The value is an integer.

`pAssert.integer(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.integerEval

The value is false/nil, or an integer.

`pAssert.integerEval(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.integerGE

The value is an integer, greater or equal to a minimum value.

`pAssert.integerGE(n, v, min)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pAssert.integerGEEval

The value is false/nil, or an integer that is greater or equal to a minimum value.

`pAssert.integerGEEval(n, v, min)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pAssert.integerRange

The value is an integer within a specified range.

`pAssert.integerRange(n, v, min, max)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.integerRangeEval

The value is false/nil, or an integer within a specified range.

`pAssert.integerRangeEval(n, v, min, max)`

* `n`: The name tag.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.namedMap

The value appears in a `pTable` NamedMap (or any other Lua table) as a key.

`pAssert.namedMap(n, v, map)`

* `n`: The name tag.

* `v`: The value to check.

* `map`: The NamedMap table.


## pAssert.namedMapEval

The value is false/nil, or it appears in a `pTable` NamedMap (or any other Lua table) as a key.

`pAssert.namedMapEval(n, v, map)`

* `n`: The name tag.

* `v`: The value to check.

* `map`: The NamedMap table.


## pAssert.notNil

The value is not nil.

`pAssert.notNil(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.notNilNotNaN

The value is not nil and not NaN.

`pAssert.notNilNotNaN(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.notNilNotFalse

The value is not nil and not false.

`pAssert.notNilNotFalse(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.notNilNotFalseNotNaN

The value is not nil, not false, and not NaN.

`pAssert.notNilNotFalseNotNaN(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.notNaN

The value is not NaN.

`pAssert.notNaN(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.tableWithMetatable

The value is a table which has a specific metatable assigned.

`pAssert.tableWithMetatable(n, v, mt)`

* `n`: The name tag.

* `v`: The value to check.

* `mt`: The metatable to check.


## pAssert.tableWithMetatableEval

The value is false/nil, or a table which has a specific metatable assigned.

`pAssert.tableWithMetatableEval(n, v, mt)`

* `n`: The name tag.

* `v`: The value to check.

* `mt`: The metatable to check.


## pAssert.tableWithoutMetatable

The value is a table with no metatable assigned.

`pAssert.tableWithoutMetatable(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.tableWithoutMetatableEval

The value is false/nil, or a table with no metatable assigned.

`pAssert.tableWithoutMetatableEval(n, v)`

* `n`: The name tag.

* `v`: The value to check.


## pAssert.fail

Always raises an error.

`pAssert.fail(n, v, [err])`

* `n`: The name tag.

* `v`: The value to check. (Unused.)

* `[err]`: An optional error message to display.


## pAssert.pass

Does nothing.

`pAssert.pass(n, v)`

* `n`: The name tag. (Unused.)

* `v`: The value to check. (Unused.)


## pAssert.assert

The value is not false/nil.

`pAssert.assert(n, v, [err])`

* `n`: The name tag.

* `v`: The value to check.

* `[err]`: An optional error message to display.


# Notes

* These are run time checks, so they will add processing overhead to any functions in which they are called.

* The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised from within assertions.

* All integer checks, and all number checks with a minimum or maximum bound also reject NaN.

## What's NaN?

NaN ("Not a Number") is basically an error state for floating point numbers.


## Uses of Name Tags

The name tag `n` can be used in the following ways:

* false/nil, for nothing:

`pAssert.integer(nil, 1.1)` --> expected integer

* A number, for an argument count:

`pAssert.integer(1, 1.1)` --> **argument #1:** expected integer

* A string, for any arbitrary tag:

`pAssert.integer("Something Important", 1.1)` --> **Something Important:** expected integer

* A table with its first two indices set, for table and field names:

`pAssert.integer({"hash", "foo"}, 1.1)` --> **table 'hash', field 'foo':** expected integer

(To reduce the creation of throwaway tables, a shared table can be reused for many calls. The table `pAssert.L` is allocated for this purpose.)

* A function that returns a string, for any arbitrary tag:

```lua
local function F()
	return "Nuh-uh"
end

`pAssert.integer(F, 1.1)` --> **Nuh-uh:** expected integer
```
