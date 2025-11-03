**Version:** 1.315

# PILE Assert


*pAssert* provides some common Lua assertions with (mostly) apropos error messages.


```lua
local pAssert = require("path.to.pile_assert")

local function aStringCalledFoobar(a)
	pAssert.type(1, a, "string")

	return a == "foobar"
end

aStringCalledFoobar(1)

--> stdin:1: argument #1: bad type (expected string, got number)
```


## Dependencies

* `pile_interp.lua`


# API: PILE Assert

## pAssert.type

Asserts that an argument is one Lua type.

`pAssert.type(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pAssert.typeEval

Asserts that an argument is `false`, `nil`, or one Lua type.

`pAssert.typeEval(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pAssert.types

Asserts that an argument is one of various Lua types.

`pAssert.types(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## pAssert.typesEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`pAssert.typesEval(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## pAssert.integer

Asserts that an argument is an integer.

`pAssert.integer(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.integerEval

Asserts that an argument is `false`, `nil` or an integer.

`pAssert.integerEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.integerGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`pAssert.integerGE(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pAssert.integerGEEval

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`pAssert.integerGEEval(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pAssert.integerRange

Asserts that an argument is an integer within a specified range.

`pAssert.integerRange(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.integerRangeEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range.

`pAssert.integerRangeEval(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pAssert.numberNotNaN

Asserts that an argument is a number, and that it isn't NaN ("Not a Number").

`pAssert.numberNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.numberNotNaNEval

Asserts that an argument is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`pAssert.numberNotNaNEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.namedMap

Asserts that an argument appears in a `pTable` NamedMap (or any other Lua table) as a key.

`pAssert.namedMap(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The NamedMap table.


## pAssert.namedMapEval

Asserts that an argument is `false`, `nil`, or that it appears in a `pTable` NamedMap (or any other Lua table) as a key.

`pAssert.namedMapEval(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The NamedMap table.


## pAssert.oneOf

Asserts that an argument matches one of any values in a vararg list.

`pAssert.oneOf(n, v, id, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `id`: What to the call the list in error messages.

* `...`: Vararg list of values to check.

**Notes:**

* There is no `pAssert.oneOfEval()`, as you can include `false` and `nil` in the vararg list to achieve the same effect.


## pAssert.notNil

Asserts that an argument is not nil.

`pAssert.notNil(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.notNilNotNaN

Asserts that an argument is not nil and not NaN ("Not a Number").

`pAssert.notNilNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.notNilNotFalse

Asserts that an argument is not nil and not false.

`pAssert.notNilNotFalse(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.notNilNotFalseNotNaN

Asserts that an argument is not nil, not false, and not NaN ("Not a Number").

`pAssert.notNilNotFalseNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pAssert.notNaN

Asserts that an argument is not NaN ("Not a Number").

`pAssert.notNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


# Notes

* These are run time checks, so they will add processing overhead to any functions in which they are called.

* The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised from within assertions.

* All integer checks (`math.floor(v) == v`) also reject NaN.

* It's unlikely that you will need every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.


## Argument Number

`n` is ostensibly the argument number…

`pAssert.integer(1, 1.1)` --> **argument #1:** expected integer

…but it can be used in a few other ways:

* `false` or `nil`, for no first part:

`pAssert.integer(nil, 1.1)` --> expected integer

* An arbitrary string:

`pAssert.integer("Something Important", 1.1)` --> **Something Important:** expected integer

* A table with its first two indices set to a table name and field ID, respectively:

`pAssert.integer({"hash", "foo"}, 1.1)` --> **table 'hash', field 'foo':** expected integer

(To reduce the creation of throwaway tables, a shared table can be reused for many calls. The table `pAssert.L` is allocated for this purpose.)

* A function that returns a string:

```lua
local function F()
	return "Nuh-uh"
end

`pAssert.integer(F, 1.1)` --> **Nuh-uh:** expected integer
```
