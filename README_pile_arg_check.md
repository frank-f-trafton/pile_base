**Version:** 1.0.0

# PILE: argCheck


*argCheck* provides some common argument assertion functions.


## Dependencies

* `pile_interp.lua`


```lua
local argCheck = require("path.to.pile_arg_check")

local function foobar(a)
	argCheck.type(1, a, "string")
end

foobar(1)

--> "XXX: fill in error. Something like: argument #$1: bad type (expected [$2], got $3)"
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


## argCheck.intGE

Raises an error if the argument is not an integer greater than or equal to an arbitrary value.

`argCheck.intGE(n, v, min)`

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
