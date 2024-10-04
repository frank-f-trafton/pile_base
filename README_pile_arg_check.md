**Version:** 1.1.0

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

Raises an error if the argument is not one of a series of types.

`argCheck.type(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.typeEval

Like `argCheck.type`, but allows `false` and `nil` values.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.int

Raises an error if the argument is not an integer.

`argCheck.int(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.evalInt

Like `argCheck.int`, but allows `false` and `nil` values.

`argCheck.evalInt(n, v)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.


## argCheck.intGE

Raises an error if the argument is not an integer greater than or equal to a minimum value.

`argCheck.intGE(n, v, min)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.evalIntGE

Like `argCheck.intGE`, but allows `false` and `nil` values.

`argCheck.evalIntGE(n, v, min)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intRange

Raises an error if the argument is not an integer within a specified range.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.evalIntRange

Like `argCheck.intRange`, but allows `false` and `nil` values.

`argCheck.evalIntRange(n, v, min, max)`

* `n`: The argument number, starting at 1.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


# Notes

These are run-time checks, so they will add processing overhead to functions where they are used.

It's unlikely that you will require every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.
