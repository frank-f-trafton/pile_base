**Version:** 2.010

# PILE Hook

Creates callable arrays of functions.


```lua
local pHook = require("pile_hook")

local hooks = pHook.newHookList()

table.insert(hooks, function(color) if color == "violet" then return 1 end end)
table.insert(hooks, function(color) if color == "viridian" then return 2 end end)
table.insert(hooks, function(color) if color == "vermillian" then return 3 end end)

hooks("viridian") --> 2
hooks("blue") --> nil
```


## Dependencies

None.


# HookLists

A HookList is an array with an attached `__call` metamethod. The array contains *hooks* (functions), and when it is called like a function, the hooks are executed in order, stopping when any hook returns a non-nil value.

An optional *filter* function may be assigned to index 0. When present, the hooks will only be processed if the filter returns a truthy value.


# API: PILE Hook

## pHook.newHookList

Creates a new HookList array.

`local hooks = pHook.newHookList([back])`

* `[back]`: When true, the HookList will iterate backwards by default when called as `hooks(...)`.

**Returns:** The new HookList, which can be called as `hooks(...)` or with `pHook.callHooks()` or `pHook.callHooksBack()`.


## pHook.callHooks

The `__call` metamethod for calling hooks in forward order.

`local a,b,c,d = pHook.callHooks(hl, ...)`

* `hl`: The calling HookList.

* `...`: Arguments for the hooks.

**Returns:** Up to four return values provided by a successful hook, or nil.


## pHook.callHooksBack

The `__call` metamethod for calling hooks in backward order.

`local a,b,c,d = pHook.callHooks(hl, ...)`

* `hl`: The calling HookList.

* `...`: Arguments for the hooks.

**Returns:** Up to four return values provided by a successful hook, or nil.


## pHook.wrap

Returns a function that calls a HookList. May be useful in cases where a function expects a function as an argument.

`local fn = pHook.wrap(hl)`

* `hl`: The HookList.

**Returns:** A function that calls the HookList.


# Module Notes

To run a HookList in a specific order (regardless of how it was created with `pHook.newHookList()`), just call `pHook.callHooks(hl, ...)` or `pHook.callHooksBack(hl, ...)`. This unfortunately does not work with HookLists that are called via function wrappers.

The filter's return value is not propagated anywhere: its only purpose is to tell the hook caller whether or not it's OK to proceed.
