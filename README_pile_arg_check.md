**Version:** 1.1.91

# PILE: argCheck


*argCheck* provides some common assertions for function arguments.


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


# argCheck API

## argCheck.type

Asserts that an argument is one of various Lua types.

`argCheck.type(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.typeEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.type1

Asserts that an argument is one Lua type.

`argCheck.type1(n, v, e)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.typeEval1

Asserts that an argument is `false`, `nil`, or one Lua type.

`argCheck.typeEval(n, v, e)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.fieldType

Asserts that a field in an argument is one of various Lua types.

`argCheck.fieldType(n, t, id, ...)`

* `n`: The argument number, starting at 1.

* `t`: The table received as the argument.

* `id`: The field to check (`t[id]`).

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.fieldTypeEval

Asserts that a field in an argument is `false`, `nil`, or one of various Lua types.

`argCheck.fieldTypeEval(n, t, id, ...)`

* `n`: The argument number, starting at 1.

* `t`: The table received as the argument.

* `id`: The field to check (`t[id]`).

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.fieldType1

Asserts that a field in an argument is one Lua type.

`argCheck.fieldType1(n, t, id, e)`

* `n`: The argument number, starting at 1.

* `t`: The table received as the argument.

* `id`: The field to check (`t[id]`).

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.fieldTypeEval1

Asserts that a field in an argument is `false`, `nil`, or one Lua type.

`argCheck.fieldTypeEval1(n, t, id, e)`

* `n`: The argument number, starting at 1.

* `t`: The table received as the argument.

* `id`: The field to check (`t[id]`).

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.int

Asserts that an argument is an integer.

`argCheck.int(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.intEval

Asserts that an argument is `false`, `nil` or an integer.

`argCheck.intEval(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.intGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`argCheck.intGE(n, v, min)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intGEEval

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`argCheck.intGEEval(n, v, min)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intRange

Asserts that an argument is an integer within a specified range. Does not show the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStatic

Asserts that an argument is an integer within a specified range. Shows the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Does not show the range in error messages.

`argCheck.intRangeEval(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStaticEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Shows the range in error messages.

`argCheck.intRangeStaticEval(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.numberNotNaN

Asserts that an argument is a number and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaN(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.numberNotNaNEval

Asserts that an argument is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaNEval(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.enum

Asserts that an argument appears in a table as a key.

`argCheck.enum(n, v, id, e)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.enumEval

Asserts that an argument is `false`, `nil`, or that it appears in a table as a key.

`argCheck.enum(n, v, id, e)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.notNil

Asserts that an argument is not nil.

`argCheck.notNil(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.notNilNotNaN

Asserts that an argument is not nil and not NaN ("Not a Number").

`argCheck.notNilNotNaN(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.notNilNotFalse

Asserts that an argument is not nil and not false.

`argCheck.notNilNotFalse(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.notNilNotFalseNotNaN

Asserts that an argument is not nil, not false, and not NaN ("Not a Number").

`argCheck.notNilNotFalseNotNaN(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.notNaN

Asserts that an argument is not NaN ("Not a Number").

`argCheck.notNaN(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


# Notes

All integer functions include a check for NaN.

These are run-time checks, so they will add processing overhead to any functions that they appear in.

The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised inside of the assertions.

It's unlikely that you will need every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.
