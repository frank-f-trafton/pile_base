**Version:** 2.010

**This module is experimental.**

# PILE Schema

*pSchema* validates the contents of tables.


```lua
local pSchema = require("pile_schema")

local rect = {x=0, y=0, w=32, h=64}

local model = pSchema.newModel {
	reject_unhandled = true,

	keys = {
		x = {pAssert.type, "number"},
		y = {pAssert.type, "number"},
		w = {pAssert.numberGE, 0},
		h = {pAssert.numberGE, 0}
	}
}

local function printErr(err)
	if err then
		print(table.concat(err, "\n"))
	end
end

local ok, err

ok, err = pSchema.validate(model, rect, "Rectangle")
printErr(err) -- OK

local rect_outta_spec = {x="foo", y=nil, w=-100, h=true}

ok, err = pSchema.validate(rect_outta_spec, model, "Rectangle")
printErr(err)
--> Rectangle > x: expected number
--> Rectangle > y: unhandled key
--> Rectangle > w: number is out of range
--> Rectangle > h: expected number
```


# Dependencies

* `pile_assert.lua`

* `pile_interp.lua`


# Structures

## Model

A table that describes how one kind of table should be validated. Has **filters** which associate keys with **handler** functions and other models.


## Handler

A function that validates one value in a table. handlers are based on the function signature used in **PILE Assert**. On failure, handlers should raise a Lua error; on success, they should do nothing.

`local function myHandler(n, v, ...)`

* `n`: An argument number or generic label. (Unused, but needed to maintain compatibility with `pAssert` functions.)

* `v`: The value to check.

* `...`: Additional function arguments.


```lua
local function myFoobar(n, v)
	if v ~= "foobar" then
		error("expected the string 'foobar'")
	end
end
}
```


## Reference

An instance of a handler or a model. (See **Reference Notation** below.)


## Filter

Selects keys during validation. All filters are optional, and they run in the same hard-coded sequence.

### 'metatable'

Selects the table's metatable.


```lua
local model = pSchema.newModel {
	metatable = <reference>
}
```


### 'keys'

Selects specific keys.


```lua
local model = pSchema.newModel {
	keys = {
		foo = <reference>,
		bar = <reference>
	}
}
```


### 'array'


Selects the table's array keys, from 1 to #tbl. Any keys that were already selected by the **keys** filter are skipped.

```lua
local model = pSchema.newModel {
	array = <reference>
}
```


### 'remaining'

Selects any keys which have not been selected by the **keys** and **array** filters.

```lua
local model = pSchema.newModel {
	remaining = <reference>
}


# Model Options

* `reject_unhandled`: (Boolean/Nil) When true, treat any keys that were not selected by a model's filter as failures. This is effectively the same as assigning a handler that always fails to the **remaining** filter.

These options apply when an **array** filter is present:

* `array_len`: (Number) `#tbl` must match this exactly.

* `array_min`: (Number) `#tbl` must be greater or equal to this.

* `array_max`: (Number) `#tbl` must be less or equal to this.


# Reference Notation

## Handler References

Handler references can be written in *long form* or *short form*. (Not all handlers support the short form.)

### Long Form

The handler reference is a table with its function stored in key `[1]`. Array elements starting at `[2]` are passed as arguments to the function.

`foo = {someHandlerFunction, "foobar", 12345}`

The above example would call `someHandlerFunction(nil, v, "foobar", 12345)`.

**Important:** Arrays of arguments do not support nil "gaps" because they will break the table length operator (`#`):

`foo = {myHandler, "foo", nil, "baz"}` -- #foo could be 2 or 4!


### Short Form

The handler reference is just a function.

`foo = someHandlerFunction`

The above example would call `someHandlerFunction(nil, v)`.


## Sub-Models

Model references look like this:

```lua
foo = {"sub", model_table},
bar = model_table -- short version of the above
baz = {"sub-eval", model_table}, -- only runs if the value is neither false nor nil
```


Here is an example of validating a table within a table:


```lua
local pAssert = require("pile_assert")
local pSchema = require("pile_schema")

local md_bar = pSchema.newModel {
	keys = {
		zoot = {pAssert.type, "string"}
	}
}

local md_foo = pSchema.newModel {
	keys = {
		doop = {pAssert.type, "number"},
		foos = {"sub", md_bar}
	}
}

local tbl = {
	doop = 3,
	foos = {
		zoot = "woo"
	}
}

pSchema.validate(md_foo, tbl, "TestSubModel") -- should return with no failures
```


# API: PILE Schema


## pSchema.setMaxMessages

Sets the maximum number of failure messages per validation call.

`pSchema.setMaxMessages([n])`

* `[n]`: *(500)* The maximum number of messages. Must be at least 1.

**Notes:**

* When the maximum number of messages is reached, an additional message is appended to the final error output which states that this is the case.


## pSchema.getMaxMessages

Gets the current maximum number of failure messages per validation call.

`local n = pSchema.getMaxMessages()`

**Returns:** The current max message count for validation failures.


## pSchema.checkModel

Checks a model table, raising a Lua error if a problem is found.

`pSchema.checkModel(md)`

* `md`: The model to check.


## pSchema.newModel

Creates a new model table.

`local md = pSchema.newModel(t)`

* `t`: The table to use as the model. Should be a freshly created table with no metatable.

**Returns:** The table.


## pSchema.newKeysX

A shortcut for creating a table with a **keys** filter and the option `reject_unhandled` enabled. (This is a common configuration in the workloads that PILE Schema was designed for.)

`local md = pSchema.newKeysX(keys)`

* `keys`: The **keys** filter table. Should be a freshly created table with no metatable.

**Returns:** A new model table with `keys` attached.


## pSchema.validate

Tests a table against a model.

`local ok, err = pSchema.validate(model, tbl, [name], [fatal])`

* `model`: The model table.

* `tbl`: The table to validate.

* `[name]`: An optional name to display as the first label in error messages. When passing false or nil, this initial name is omitted.

* `[fatal]`: When true, the Validator raises a Lua error upon the first validation failure. This may be desired when the validation action is time-sensitive.

**Returns:** true, or false plus an error string if there was a problem.


# General Notes

* When you write duplicate keys in a table constructor, Lua silently discards the previous values:


```lua
local models = pSchema.models
local Validator = pSchema.newValidator("Test", {
	main = models.keys {
		foo = {pAssert.type, "number"},
		foo = {pAssert.type, "string"},
		foo = {pAssert.type, "boolean"}
	}
}
-- main.foo points to `{pAssert.type, "boolean"}`.
```


* The order in which PILE Schema checks values is not deterministic, because `pairs()` is used to iterate hash keys. As a result, the order of failure messages may vary.
