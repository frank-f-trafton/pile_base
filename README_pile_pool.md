VERSION: 2.023

**This module is experimental. Please see the notes at the bottom of this README.**

# PILE Pool

Creates stacks of pooled resources (mainly tables or userdata).


```lua
local pPool = require("pile_pool")

local function _popping(r)
	if not r then r = {} end
	r[1], r[2], r[3], r[4] = 0, 0, 0, 0
	return r
end

local function _pushing(r)
	if type(r) ~= "table" then error("expected table") end
	return r
end

local threshold = 5

local stack = pPool.new(_popping, _pushing, threshold)

-- get a resource
local color1 = stack:pop()

-- (do stuff with 'color1')

-- return the resource to the stack
color1 = stack:push(color1) -- 'color1' is now nil
```


## Dependencies

* `pile_assert.lua`

* `pile_name.lua`


# PILE Pool API


## pPool.new

Creates a new pool stack.

`local stack = pPool.new(popping, pushing, threshold)`

* `popping`: *(false)* The initialization function, for creating new resources or refreshing old ones. It takes one argument for the resource (which may be nil if the stack is empty), and returns the resource.

* `pushing`: *(false)* The cleanup function, for winding down resources before they are returned to the stack or discarded. It takes one argument for the resource, and returns the resource (or nil to discard it).

* `threshold`: *(0)* How many resources to hold in the stack before pushed resources are simply discarded.

**Returns:** The new pool stack.

### Notes

* The default `threshold` of zero will always keep the pool stack empty.


# Pool Stack Methods

## Pool:pop

Retrieves or creates a new resource.

`local r = Pool:pop()`

**Returns:** The new or used resource.


## Pool:push

Pushes a resource onto the stack (or discards it if the stack is full).

`Pool:push(r)`

* `r`: The resource to push.


## Pool:setThreshold

Sets the pool stack's threshold (at what size it should begin to discard pushed resources). A value of zero makes the stack discard all resources.

`Pool:setThreshold(threshold)`

* `threshold`: The threshold number.


## Pool:getThreshold

Gets the pool stack's current threshold.

`local threshold = Pool:getThreshold()`

**Returns:** The threshold number.


## Pool:reduceStack

Discards a certain number of resources in the stack.

`Pool:reduceStack(n)`

* `n`: *(0)* Resources above this index are discarded.


# Notes on this module

Some *do*'s and *don't*s and other tips:

* When you push a resource onto a pool stack, you must *not* continue to use it through any existing references.

* Do not push the same resource onto a pool stack multiple times.

* Junk fields in tables will persist across pushes and pops, unless you go out of your way to clean them (which leads to more overhead).

* Rather than push extremely large arrays, you can discard them in the 'pushing' callback by returning nil.

* If you suspect that pooling is causing trouble, you can effectively disable pool stacks by setting their threshold numbers to zero.
