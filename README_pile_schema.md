**Version:** 1.300

**This module is experimental.**

# PILE Schema

*pSchema* validates the contents of tables.


```lua
local pSchema = require("pile_schema")

local rectangle = {x=0, y=0, w=32, h=64}

local models, handlers = pSchema.models, pSchema.handlers
local Validator = pSchema.newValidator("Rectangle", nil, {
	main = models.keys {
		x = handlers.number,
		y = handlers.number,
		w = {handlers.number, min=0},
		h = {handlers.number, min=0}
	}
})

local ok, err
ok, err = Validator:validate(rectangle) -- OK

local rect_outta_spec = {x="foo", y="bar", w=-100, h=true}

ok, err = Validator:validate(rect_outta_spec)
--> Rectangle > x: expected number
--> Rectangle > y: expected number
--> Rectangle > w: number is out of range
--> Rectangle > h: expected number
```


# Dependencies

* `pile_interp.lua`

* `pile_arg_check.lua`

* `pile_string.lua`

* `pile_table.lua`


# Structures

## Validator

The main object. Validates tables against **Models**.


## Model

A table that describes how one kind of table should be validated, by associating keys with **Handlers**.

There are multiple Model types, which can be created by functions in the table `pSchema.models`.

### keys

Selects arbitrary hash keys.


```lua
model = models.keys {
	foo = <reference>,
	[7] = <reference>,
	[false] = <reference>,
	-- etc.
}
```


### keysX

Selects arbitrary hash keys. Any unhandled keys are treated as failures.


```lua
model = models.keysX {
	-- same as 'keys'
}
```


### keyM

Selects arbitrary hash keys, and checks the table's metatable.


```lua
model = models.keysM {
	metatable = <reference>,

	keys = {
		foo = <reference>,
		-- etc.
	}
}
```


### keyMX

Selects arbitrary hash keys, and checks the table's metatable. Any unhandled keys are treated as failures.


```lua
model = models.keysMX {
	-- same as 'keysM'
}
```


### array

Selects array indices, from 1 to #tbl.


```lua
model = models.array {
	-- Optional settings: exact, minimum, and maximum values for #tbl
	--len = 3,
	--min = 3,
	--max = 3,

	ref = <reference>
}
```


### arrayX

Selects array indices, from 1 to #tbl. Any unhandled keys are treated as failures.


```lua
model = models.arrayX {
	-- same as 'array'
}
```


### arrayM

Selects array indices, and checks the table's metatable.


```lua
model = models.arrayM {
	metatable = <reference>,

	-- Optional settings: exact, minimum, and maximum values for #tbl
	--len = 3,
	--min = 3,
	--max = 3,

	ref = <reference> -- for array
}
```


### arrayMX

Selects array indices, and checks the table's metatable. Any unhandled keys are treated as failures.


```lua
model = models.arrayMX {
	-- same as 'arrayM'
}
```


### mixed

Selects arbitrary hash keys, then array indices. Any keys that were selected as hash keys are omitted when testing array indices.


```lua
model = M.mixed {
	keys = {
		foo = <reference>,
		-- etc.
	},

	-- Optional settings: exact, minimum, and maximum values for #tbl
	--len = 3,
	--min = 3,
	--max = 3,

	ref = <reference> -- for array
}
```


### mixedX

Selects arbitrary hash keys, then array indices. Any keys that are selected as hash keys are omitted when testing array indices. Unhandled keys are treated as failures.


```lua
model = M.mixedX {
	-- same as 'mixed'
}
```


### mixedM

Selects arbitrary hash keys, then array indices. Any keys that are selected as hash keys are omitted when testing array indices. Also checks the table's metatable.


```lua
model = M.mixedM {
	metatable = <reference>,

	keys = {
		foo = <reference>,
		bar = <reference>,
		-- etc.
	},

	-- Optional settings: exact, minimum, and maximum values for #tbl
	--len = 3,
	--min = 3,
	--max = 3,

	ref = <reference> -- for array
}
```


### mixedMX

Selects arbitrary hash keys, then array indices. Any keys that are selected as hash keys are omitted when testing array indices. Also checks the table's metatable. Unhandled keys are treated as failures.


```lua
model = M.mixedMX {
	-- same as 'mixedM'
}
```


### all

Selects all keys.

```lua
model = M.all {
	ref = <reference>
}
```


### allM

Selects all keys, and checks the table's metatable.

```lua
model = M.allM {
	metatable = <reference>,

	ref = <reference>
}
```


## Handler

A function that validates one value in a table.

`local function myHandler(k, v, opts, user, tbl)`

* `k`: The key, if applicable (see notes).

* `v`: The value.

* `opts`: A table of options that may go with the handler. May be false. If this is a table, treat it as read-only.

* `user`: A table of arbitrary user settings, from the Validator. May be false.

* `tbl`: The table being checked.

**Returns:** Boolean true if the input is valid, or false/nil, plus an error string if there was a problem.

**Notes:**

* On success Handlers *must* return boolean true, not just a value that evaluates to true. This helps weed out functions that have been incorrectly assigned as Handlers.

* When a Handler is called on a metatable, `k` is nil, since it didn't originate from a table key.

* The argument `tbl` allows a Handler to mutate the table in place. Use with discretion, and *never* add new keys to `tbl` from within a Handler function.


```lua
-- A custom, one-off Handler.

model = models.keys {
	foobar = function(k, v)
		if v == "foobar" then
			return true
		end
		return false, "expected the string 'foobar'",
	end
}
```


## Reference Notation

### Handler References

Handler References can be written in "long form" or "short form." (Not all Handlers support the short form.)

#### Long Form

The Handler Reference is a table with its function stored in the key `[1]`. This table may contain arbitrary data that is passed to the Handler function as the argument `opts`.

`foo = {someHandlerFunction, arbitrary_fields="foobar"}`


#### Short Form

The Handler Reference is just a function. The argument `opts` is false.

`foo = someHandlerFunction`


### Model References

Use a Model name in place of a Handler to check a table within a table. (Watch out for stack overflows.) By convention, the primary Model is named `main`.


```lua
local handlers, models = pSchema.handlers, pSchema.models
local Validator = pSchema.newValidator("TestVal", nil, {
	main = models.keys {
		bip = handlers.number,
		bop = "aux" -- !
	},

	aux = models.keys {
		dup = handlers.string
	}
}

local tbl = {
	bip = 2,
	bop = {
		dup = "foo"
	}
}

Validator:validate(tbl) -- should return with no failures
```


# API: PILE Schema

## pSchema.newValidator

Creates a new Validator.

`local proc = pSchema.newValidator([name], [models])`

* `[name]`: *("Unnamed")* The Validator's name, for error messages.

* `[models]`: *(empty table)* A table of models for this Validator to use. If not provided here, the library user is expected to add model tables later with `Validator:setModel()`.

**Returns:** The new Validator.


# API: Validator

## Validator:setName

Sets the Validator's name, for error messages.

`Validator:setName(name)`

* `name`: (string) The Validator name.

**Returns:** `self`, for method chaining.


## Validator:getName

Gets the Validator's name.

`local name = Validator:getName()`

**Returns:** The Validator name.


## Validator:setModel

Assigns, overwrites or removes a Model.

`Validator:setModel(id, md)`

* `id`: The Model ID string.

* `md`: The Model table, or false/nil to remove any Model with this ID.

**Returns:** `self`, for method chaining.


## Validator:getModel

Gets the Model with this ID.

`local model = Validator:getModel(id)`

**Returns:** The Model table, or nil if the ID is unassigned.


## Validator:setUserTable

Sets the Validator's User Table.

`Validator:setUserTable([user])`

* `[user]`: The User Table, or false/nil to unassign any current User Table.

**Returns:** `self`, for method chaining.

**Notes:**

* This is an arbitrary table that is passed to Handler functions.


## Validator:getUserTable

Gets the Validator's User Table.

`local user = Validator:getUserTable()`

**Returns:** The User Table, or false if no User Table is currently assigned.


## Validator:validate

Validates the contents of a table.

`local ok, err_msgs = Validator:validate(tbl, [model_id], [fatal])`

* `tbl`: The table to validate.

* `[model_id]`: *("main")* ID of the Model to compare against.

* `[fatal]`: *(false)* When true, raises a Lua error at the first validation failure.

**Returns:** true, or (assuming `fatal` is off) false, plus an array of error messages if there was a problem.

**Notes:**

* The order in which the Validator checks values is not 100% deterministic (because `pairs()` is used to iterate hash keys). The error messages array can be sorted with `table.sort()` before its contents are presented to the user.

* `fatal` affects validation failures. Other problems, like missing data in the Models, will raise Lua errors without regard for this setting.

* `fatal` can be used with `pcall()` to stop processing a table as soon as it is found to be invalid, without crashing the program (for example, if the validation action is time-sensitive).


## Validator:_failure

An internal method which is called when a Handler fails or a Model is not found. Depending on the `fatal` argument passed to `Validator:validate()`, either it appends a string to the error log, or it raises a Lua error.

`Validator:_failure(str)`

* `str`: The failure message.

**Notes:**

* This method is publicly exposed so that library users can replace it for special use cases. For example, you may want to print failure messages to the terminal as they happen, or raise a Lua error *immediately*, without fussing with string concatenations.


# Built-in Handlers

PILE Schema includes a set of built-in Handlers in the table `pSchema.handlers`. You may need to write more Handlers to cover all of your use cases.

By convention, Handlers that end with 'eval' will pass values that are false or nil.

## type

The value's type matches one of a set of types.

`No short form.`

`key = {handlers.type, "number", "string", "nil"}`


## number

The value is a number.

`key = handlers.number`

`key = {handlers.number, [min=-math.huge], [max=math.huge]}`

* `min`: *(-math.huge)* The minimum value.

* `max`: *(math.huge)* The maximum value.


## numberEval

The value is a number, or false/nil.

`key = handlers.numberEval`

`key = {handlers.numberEval, [min=-math.huge], [max=math.huge]}`

* `min`: *(-math.huge)* The minimum value.

* `max`: *(math.huge)* The maximum value.


## integer

The value is a number and an integer.

`key = handlers.integer`

`key = {handlers.integer, [min=-math.huge], [max=math.huge]}`

* `min`: *(-math.huge)* The minimum value.

* `max`: *(math.huge)* The maximum value.


## integerEval

The value is a number and an integer, or false/nil.

`key = handlers.integerEval`

`key = {handlers.integerEval, [min=-math.huge], [max=math.huge]}`

* `min`: *(-math.huge)* The minimum value.

* `max`: *(math.huge)* The maximum value.


## string

The value is of type string. It may optionally have to match one or multiple string patterns.

`key = handlers.string`

`key = {handlers.string, [patterns…]}`

* `[patterns…]`: Optional string patterns, beginning at index #2. When present, the handler fails if the text doesn't match.


## stringEval

The value is of type string, or false/nil. It may optionally have to match one or multiple string patterns.

`key = handlers.stringEval`

`key = {handlers.stringEval, [pattern="^FoObAr$"], [patterns={"^%s+foobar%s+$", "e.t.c"}]}`

* `[pattern]`: An optional string pattern. When present, the handler fails if the text doesn't match.

* `[patterns]`: An optional array of Lua string patterns.


## table

The value is a table.

`key = handlers.table`

`key = {handlers.table}`


## tableEval

The value is a table, or false/nil.

`key = handlers.tableEval`

`key = {handlers.tableEval}`


## function

The value is a function.

`key = handlers["function"]`

`key = {handlers["function"]}`

**Notes:**

* `function` is a reserved keyword in Lua, so this handler name must be enclosed within quotes and square brackets.


## functionEval

The value is a function, or false/nil.

`key = handlers.functionEval`

`key = {handlers.functionEval}`


## userdata

The value is of type `userdata`.

`key = handlers.userdata`

`key = {handlers.userdata}`


## userdataEval

The value is of type `userdata`, or false/nil.

`key = handlers.userdataEval`

`key = {handlers.userdataEval}`


## thread

The value is of type `thread`.

`key = handlers.thread`

`key = {handlers.thread}`


## threadEval

The value is of type `thread`, or false/nil.

`key = handlers.threadEval`

`key = {handlers.threadEval}`


## boolean

The value is of type `boolean`.

`key = handlers.boolean`

`key = {handlers.boolean}`


## booleanEval

The value is of type `boolean`, or false/nil.

`key = handlers.booleanEval`

`key = {handlers.booleanEval}`


## nil

The value is nil.

`key = handlers["nil"]`

`key = {handlers["nil"]}`

**Notes:**

* `nil` is a reserved keyword in Lua, so this handler name must be enclosed within quotes and square brackets.


## notNil

The value is **not** nil.

`key = handlers.notNil`

`key = {handlers.notNil}`


## notFalseNotNil

The value is **not** false or nil (in other words, it evaluates to true).

`key = handlers.notFalseNotNil`

`key = {handlers.notFalseNotNil}`


## notFalseNotNilNotNan

The value is **not** false, nil, or a number which is NaN (Not a Number).

`key = handlers.notFalseNotNilNotNan`

`key = {handlers.notFalseNotNilNotNan}`


## this

The value matches one value exactly.

`No short form.`

`key = {handlers.this, "foobar"}`


## oneOf

The value matches one of multiple values.

`No short form.`

`key = {handlers.oneOf, "foobar", 3.14, true}`


## enum

The value matches a key in a hash table.

`No short form.`

`key = {handlers.enum, {left=true, center=true, right=true}}`


## enumEval

The value matches a key in a hash table, or is false/nil.

`No short form.`

`key = {handlers.enumEval, {left=true, center=true, right=true}}`


## choice

The value matches against one of a sequence of handler functions.

`No short form.`

```lua
key = {handlers.choice,
	handlers.integer,
	{handlers.string, pattern="^[Ff][Oo][Oo]$"}
}
```

**Notes:**

* `choice`'s failure message, which itemizes the returned error strings of every sub-handler, is not very helpful. It may be better to write a new handler function that tests all expected variations (in the case of the example above, writing an `integerOrFoo` handler) and which provides a concise error message.


## pass

Always passes. Assign in cases where a Handler must be provided in a given Model, but you don't care to actually check the value.

`key = handlers.pass`

`key = {handlers.pass}`


## fail

Always fails. Assign in cases where a specific key should *not* appear in a table.

`key = handlers.fail`

`key = {handlers.fail}`

**Notes:**

* This Handler is incompatible with "exclusive" Models (those suffixed with an `X`) that treat unhandled keys as failures.


# API: Utility Functions

These functions are used by the built-in Handlers for basic housekeeping. They are made public so that library users can use them in their own Handler functions, if so desired.

## pSchema.assertOpts

In Handlers, asserts that the `opts` table is provisioned. If `opts` is not a table, raises a Lua error.

`pSchema.assertOpts(opts)`

* `opts`: The `opts` table.


## pSchema.assertOptsSub

In Handlers, asserts that `opts` contains a sub-table at the key `k`, and returns the table. If there is no table at `opts[k]`, raises a Lua error.

`local sub = pSchema.assertOptsSub(opts, k)`

* `opts`: The Handler's `opts` argument.

* `k`: The key to check.

**Returns:** The sub-table.


## pSchema.simpleTypeCheck

Performs a basic type check assertion on a value. This function is wrapped by several built-in Handlers.

`pSchema.simpleTypeCheck(typ, v, eval)`

* `typ`: The expected type.

* `v`: The value to check.

* `eval`: When true, always pass values that are false or nil.

**Returns:** If the type matches, true; if not, false, plus a error message.


# General Notes

* When you write duplicate keys in a table constructor, Lua silently discards the previous values:

```lua
local handlers, models = pSchema.handlers, pSchema.models
local Validator = pSchema.newValidator(nil, nil, {
	main = models.keys {
		foo = handlers.number,
		foo = handlers.string,
		foo = handlers.boolean
	}
}
-- main.foo points to 'handlers.boolean'.
```

* The Handlers `enum` and `enumEval` work both with plain hash tables and Enum objects created with `pTable`.
