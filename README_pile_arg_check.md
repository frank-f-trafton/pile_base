**Version:** 1.1.3

# PILE: argCheck


*argCheck* provides some common assertions for function arguments.


## Dependencies

* `pile_interp.lua`


```lua
local argCheck = require("path.to.pile_arg_check")

local function foobar(a)
	argCheck.type(1, a, "string")
end

foobar(1)

--> stdin:1: argument #1: bad type (expected [string], got number)
```


# argCheck API

## argCheck.type

Asserts that an argument is one of various Lua types.

`argCheck.type(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.type1

Asserts that an argument is one Lua type.

`argCheck.type(n, v, e)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.typeEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.typeEval1

Asserts that an argument is `false`, `nil`, or one Lua type.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.int

Asserts that an argument is an integer.

`argCheck.int(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.evalInt

Asserts that an argument is `false`, `nil` or an integer.

`argCheck.evalInt(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.intGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`argCheck.intGE(n, v, min)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.evalIntGE

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`argCheck.evalIntGE(n, v, min)`

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


## argCheck.evalIntRange

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Does not show the range in error messages.

`argCheck.evalIntRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.evalIntRangeStatic

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Shows the range in error messages.

`argCheck.evalIntRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.numberNotNaN

Asserts that an argument is a number and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaN(n, v)`

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


# Notes

All integer functions include a check for NaN.

These are run-time checks, so they will add processing overhead to any functions they appear in.

It's unlikely that you will require every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.
