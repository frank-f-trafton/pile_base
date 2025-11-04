**Version:** 1.316

# PILE Name

Associates Lua objects (functions, tables, threads, userdata) with string names. An object may have up to one name; the same name may be used among multiple objects.

This module is intended to help identify objects when reporting errors. Names are stored in a weak table, so registering an object to this module will not prevent it from being deleted by the garbage collector.


```lua
local pName = require("path.to.pile_name")


local function _assertMetatable(v, mt)
	if getmetatable(v) ~= mt then
		error("invalid " .. pName.safeGet(mt))
	end
end


local _mt_point = {}
_mt_point.__index = _mt_point
pName.set(_mt_point, "Point")


local function newPoint(x, y)
	return setmetatable({x=x, y=y}, _mt_point)
end


local my_point = newPoint(0, 5)
_assertMetatable(my_point, _mt_point) -- OK

local not_my_point = {}
_assertMetatable(not_my_point, _mt_point) --> invalid Point
```


## Dependencies

None.


# API: Name Registry


## pName.set

Assigns, overwrites or deletes a name for a Lua object.

`retval = pName.set(o, [name])`

* `o`: The Lua object (function, table, thread or userdata).

* `[name]` The name (string), or false/nil to erase any existing name.

**Returns:** The Lua object, to support one-liners like `local tbl = pName.set({}, "SomeName")`.


## pName.get

Gets the name for a Lua object.

`local name = pName.get(o)`

**Returns:** * The Lua object's registered name, or nil if there is no name.


## pName.safeGet

Gets the name for a Lua object, or a fallback name if no name is registered.

`local name = pName.safeGet(o, [fallback_name])`

* `o`: The Lua object (function, table, thread or userdata).

* `[fallback_name]`: *("Unknown")* The name to use if no name is registered.
