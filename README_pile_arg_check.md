**Version:** 1.201

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


# ArgCheck API: Function Arguments

## argCheck.type

Asserts that an argument is one of various Lua types.

`argCheck.type(n, v, ...)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.typeEval

Asserts that an argument is `false`, `nil`, or one of various Lua types.

`argCheck.typeEval(n, v, ...)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.type1

Asserts that an argument is one Lua type.

`argCheck.type1(n, v, e)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.typeEval1

Asserts that an argument is `false`, `nil`, or one Lua type.

`argCheck.typeEval(n, v, e)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.int

Asserts that an argument is an integer.

`argCheck.int(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.intEval

Asserts that an argument is `false`, `nil` or an integer.

`argCheck.intEval(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.intGE

Asserts that an argument is an integer, greater or equal to a minimum value.

`argCheck.intGE(n, v, min)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intGEEval

Asserts that an argument is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`argCheck.intGEEval(n, v, min)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.


## argCheck.intRange

Asserts that an argument is an integer within a specified range. Does not show the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStatic

Asserts that an argument is an integer within a specified range. Shows the range in error messages.

`argCheck.intRange(n, v, min, max)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Does not show the range in error messages.

`argCheck.intRangeEval(n, v, min, max)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.intRangeStaticEval

Asserts that an argument is `false`, `nil`, or an integer within a specified range. Shows the range in error messages.

`argCheck.intRangeStaticEval(n, v, min, max)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.numberNotNaN

Asserts that an argument is a number, and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaN(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.numberNotNaNEval

Asserts that an argument is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`argCheck.numberNotNaNEval(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.enum

Asserts that an argument appears in a table as a key.

`argCheck.enum(n, v, id, e)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.enumEval

Asserts that an argument is `false`, `nil`, or that it appears in a table as a key.

`argCheck.enumEval(n, v, id, e)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.notNil

Asserts that an argument is not nil.

`argCheck.notNil(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.notNilNotNaN

Asserts that an argument is not nil and not NaN ("Not a Number").

`argCheck.notNilNotNaN(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.notNilNotFalse

Asserts that an argument is not nil and not false.

`argCheck.notNilNotFalse(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.notNilNotFalseNotNaN

Asserts that an argument is not nil, not false, and not NaN ("Not a Number").

`argCheck.notNilNotFalseNotNaN(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


## argCheck.notNaN

Asserts that an argument is not NaN ("Not a Number").

`argCheck.notNaN(n, v)`

* `n`: The argument number, or `false`/`nil` to omit that part of the error message.

* `v`: The value to check.


# ArgCheck API: Table Fields

All of these functions take the table name, the table object, and the field ID as their first three arguments.

## argCheck.fieldType

Asserts that a value in a table is one of various Lua types.

`argCheck.fieldType(t, tn, f, ...)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.fieldTypeEval

Asserts that a value in a table is `false`, `nil`, or one of various Lua types.

`argCheck.fieldTypeEval(t, tn, f, ...)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `...`: Varargs list of accepted type strings (`"boolean"`, etc.)


## argCheck.fieldType1

Asserts that a value in a table is one Lua type.

`argCheck.fieldType1(t, tn, f, e)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.fieldTypeEval1

Asserts that a value in a table is `false`, `nil`, or one Lua type.

`argCheck.fieldTypeEval1(t, tn, f, e)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `e`: The expected type string (`"boolean"`, etc.)


## argCheck.fieldInt

Asserts that a value in a table is an integer.

`argCheck.fieldInt(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldIntEval

Asserts that a value in a table is `false`, `nil` or an integer.

`argCheck.fieldIntEval(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldIntGE

Asserts that a value in a table is an integer, greater or equal to a minimum value.

`argCheck.fieldIntGE(t, tn, f, min)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.


## argCheck.fieldIntGEEval

Asserts that a value in a table is `false`, `nil`, or an integer that is greater or equal to a minimum value.

`argCheck.fieldIntGEEval(t, tn, f, min)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.


## argCheck.fieldIntRange

Asserts that a value in a table is an integer within a specified range. Does not show the range in error messages.

`argCheck.fieldIntRange(t, tn, f, min, max)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.fieldIntRangeEval

Asserts that a value in a table is `false`, `nil`, or an integer within a specified range. Does not show the range in error messages.

`argCheck.fieldIntRangeEval(t, tn, f, min, max)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.fieldIntRangeStatic

Asserts that a value in a table is an integer within a specified range. Shows the range in error messages.

`argCheck.fieldIntRangeStatic(t, tn, f, min, max)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.fieldIntRangeStaticEval

Asserts that a value in a table is `false`, `nil`, or an integer within a specified range. Shows the range in error messages.

`argCheck.fieldIntRangeStaticEval(t, tn, f, min, max)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `min`: The minimum permitted value.

* `max`: The maximum permitted value.


## argCheck.fieldNumberNotNaN

Asserts that a value in a table is a number, and that it isn't NaN ("Not a Number").

`argCheck.fieldNumberNotNaN(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldNumberNotNaNEval

Asserts that a value in a table is `false`, `nil`, or a number, and that it isn't NaN ("Not a Number").

`argCheck.fieldNumberNotNaNEval(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldEnum

Asserts that a value in a table appears in an enum hash as a key.

`argCheck.fieldEnum(t, tn, f, id, e)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.fieldEnumEval

Asserts that a value in a table is `false`, `nil`, or that it appears in an enum hash as a key.

`argCheck.fieldEnumEval(t, tn, f, id, e)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.

* `id`: String identifier for the enum.

* `e`: The enum table.


## argCheck.fieldNotNil

Asserts that a value in a table is not nil.

`argCheck.fieldNotNil(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldNotNilNotNaN

Asserts that a value in a table is not nil and not NaN ("Not a Number").

`argCheck.fieldNotNilNotNaN(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldNotNilNotFalse

Asserts that a value in a table is not nil and not false.

`argCheck.fieldNotNilNotFalse(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldNotNilNotFalseNotNaN

Asserts that a value in a table is not nil, not false, and not NaN ("Not a Number").

`argCheck.fieldNotNilNotFalseNotNaN(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


## argCheck.fieldNotNaN

Asserts that a value in a table is not NaN ("Not a Number").

`argCheck.fieldNotNaN(t, tn, f)`

* `t`, `tn`, `f`: The table name, the table itself and the field ID.


# Notes

* These are run time checks, so they will add processing overhead to any functions that they are called from.

* The assertions don't check their own arguments. Incorrect arguments can lead to misleading error messages, or incidental errors being raised from within assertions.

* All integer functions include a check for NaN.

* Functions which accept an argument number will use generic error messages when `false/nil` is used for `n`. For example:

  * `argCheck.int(1, 1.1)` -> argument #1: expected integer

  * `argCheck.int(nil, 1.1)` -> expected integer

* It's unlikely that you will need every function in this module, so it has been organized to allow deleting unwanted functions without affecting the others.
