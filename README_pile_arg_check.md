**Version:** 1.202

# PILE: ArgCheck


*ArgCheck* provides some common Lua assertions with (mostly) apropos error messages.


```lua
local argCheck = require("path.to.pile_arg_check")

local function foobar(a)
	argCheck.type(1, a, "string")
end

foobar(1)

--> stdin:1: argument #1: bad type (expected [string], got number)
```


## Dependencies

* `pile_interp.lua`


# ArgCheck API

## argCheck.type

Asserts that an argument is one of various Lua types.

`argCheck.type(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.typeEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.type1

Asserts that an argument is one Lua type.

`argCheck.type1(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.typeEval1

Asserts that an argument is `false`, `nil`, or one Lua type.

`argCheck.typeEval(n, v, e)`

* `n`: The argument number.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.int

Asserts that an argument is an integer.

`argCheck.int(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.intEval

Asserts that an argument is `false`, `nil` or an integer.

`argCheck.intEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.intGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`argCheck.intGE(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intGEEval

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`argCheck.intGEEval(n, v, min)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intRange

Asserts that an argument is an integer within a specified range. Does not show the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStatic

Asserts that an argument is an integer within a specified range. Shows the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Does not show the range in error messages.

`argCheck.intRangeEval(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStaticEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Shows the range in error messages.

`argCheck.intRangeStaticEval(n, v, min, max)`

* `n`: The argument number.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.numberNotNaN

Asserts that an argument is a number, and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.numberNotNaNEval

Asserts that an argument is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaNEval(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.enum

Asserts that an argument appears in a table as a key.

`argCheck.enum(n, v, id, e)`

* `n`: The argument number.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.enumEval

Asserts that an argument is `false`, `nil`, or that it appears in a table as a key.

`argCheck.enumEval(n, v, id, e)`

* `n`: The argument number.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.notNil

Asserts that an argument is not nil.

`argCheck.notNil(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.notNilNotNaN

Asserts that an argument is not nil and not NaN ("Not a Number").

`argCheck.notNilNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.notNilNotFalse

Asserts that an argument is not nil and not false.

`argCheck.notNilNotFalse(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.notNilNotFalseNotNaN

Asserts that an argument is not nil, not false, and not NaN ("Not a Number").

`argCheck.notNilNotFalseNotNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


## argCheck.notNaN

Asserts that an argument is not NaN ("Not a Number").

`argCheck.notNaN(n, v)`

* `n`: The argument number.

* `v`: The value to check.


# Notes

* These are run time checks, so they will add processing overhead to any functions that they are called from.

* The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised from within assertions.

* All integer functions include a check for NaN.

* It's unlikely that you will need every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.

## Argument Number

The argument `n` is ostensibly the argument number…

`argCheck.int(1, 1.1)` --> **argument #1:** expected integer

…but it has been extended to support a few additional modes:

* `false` or `nil`, for no first part:

`argCheck.int(nil, 1.1)` --> expected integer

* An arbitrary string:

`argCheck.int("Something Important", 1.1)` --> **Something Important:** expected integer

* A table with its first two indices set to a table name and field ID, respectively:

`argCheck.int({"hash", "foo"}, 1.1)` --> **table 'hash', field 'foo':** expected integer

(To reduce the creation of throwaway tables, A shared table can be reused for many calls. The table `argCheck.L` is allocated for this purpose.)
