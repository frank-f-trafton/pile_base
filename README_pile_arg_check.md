**Version:** 1.300

# PILE: Argument Check


*pArg* provides some common Lua assertions with (mostly) apropos error messages.


```lua
local pArg = require("path.to.pile_arg_check")

local function aStringCalledFoobar(a)
	pArg.type(1, a, "string")

	return a == "foobar"
end

aStringCalledFoobar(1)

--> stdin:1: argument #1: bad type (expected [string], got number)
```


## Dependencies

* `pile_interp.lua`


# API: PILE Argument Check

## pArg.type

Asserts that an argument is one of various Lua types.

`pArg.type(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## pArg.typeEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`pArg.typeEval(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## pArg.type1

Asserts that an argument is one Lua type.

`pArg.type1(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pArg.typeEval1

Asserts that an argument is `false`, `nil`, or one Lua type.

`pArg.typeEval(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## pArg.int

Asserts that an argument is an integer.

`pArg.int(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.intEval

Asserts that an argument is `false`, `nil` or an integer.

`pArg.intEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.intGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`pArg.intGE(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pArg.intGEEval

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`pArg.intGEEval(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## pArg.intRange

Asserts that an argument is an integer within a specified range.

`pArg.intRange(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pArg.intRangeEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range.

`pArg.intRangeEval(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## pArg.numberNotNaN

Asserts that an argument is a number, and that it isn't NaN ("Not a Number").

`pArg.numberNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.numberNotNaNEval

Asserts that an argument is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`pArg.numberNotNaNEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.enum

Asserts that an argument appears in a `pTable` Enum table as a key.

`pArg.enum(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The enum table.


## pArg.enumEval

Asserts that an argument is `false`, `nil`, or that it appears in a `pTable` Enum table as a key.

`pArg.enumEval(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The enum table.


## pArg.oneOf

Asserts that an argument matches one of any values in a vararg list.

`pArg.oneOf(n, v, id, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `id`: What to the call the list in error messages.

* `...`: Vararg list of values to check.

**Notes:**

* There is no `pArg.oneOfEval()`, as you can include `false` and `nil` in the vararg list to achieve the same effect.


## pArg.notNil

Asserts that an argument is not nil.

`pArg.notNil(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.notNilNotNaN

Asserts that an argument is not nil and not NaN ("Not a Number").

`pArg.notNilNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.notNilNotFalse

Asserts that an argument is not nil and not false.

`pArg.notNilNotFalse(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.notNilNotFalseNotNaN

Asserts that an argument is not nil, not false, and not NaN ("Not a Number").

`pArg.notNilNotFalseNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## pArg.notNaN

Asserts that an argument is not NaN ("Not a Number").

`pArg.notNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


# Notes

* These are run time checks, so they will add processing overhead to any functions in which they are called.

* The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised from within assertions.

* All integer checks (`math.floor(v) == v`) also reject NaN.

* It's unlikely that you will need every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.

## Argument Number

The argument `n` is ostensibly the argument number…

`pArg.int(1, 1.1)` --> **argument #1:** expected integer

…but it has been extended to support a few additional modes:

* `false` or `nil`, for no first part:

`pArg.int(nil, 1.1)` --> expected integer

* An arbitrary string:

`pArg.int("Something Important", 1.1)` --> **Something Important:** expected integer

* A table with its first two indices set to a table name and field ID, respectively:

`pArg.int({"hash", "foo"}, 1.1)` --> **table 'hash', field 'foo':** expected integer

(To reduce the creation of throwaway tables, A shared table can be reused for many calls. The table `pArg.L` is allocated for this purpose.)
