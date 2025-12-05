**Version:** 2.011

# PILE List2

**pList2** provides functions for working with doubly linked lists.


```lua
local pList2 = require("pile_list2")

local head = pList2.nodeNew()

local a = pList2.nodeNew()
pList2.nodeLink(head, a) -- [head]--[a]

local b = pList2.nodeNew()
pList2.nodeLink(a, b) -- [head]--[a]--[b]

pList2.nodeUnlink(a, b) -- [head]--[b]

```


## Dependencies

* `pile_assert.lua`

* `pile_interp.lua`


# Nodes

All pList2 nodes reference the next and previous nodes as `node["next"]` and `node["prev"]`. (The square bracket notation is used so that the field names can be easily changed with a search-and-replace mechanism.) Every node in a list must be unique table, or else you risk breaking the traversal code.

pList2's functions can be called as object methods (ie `obj:nodeGetHead()`) if you attach them to nodes or otherwise make them callable through `__index`.

For more complex use cases, you may need to write your own versions of the functions to create, link and unlink nodes.


# API: Node Management

## pList2.nodeNew

Creates a new list node.

`local node = pList2.nodeNew()`

**Returns:** The new node.


## pList2.nodeLink

Links two nodes together. Any existing links are removed.

`pList2.nodeLink(from, to)`

* `from`: The first node to link.

* `to`: The second node to link.


## pList2.nodeUnlink

Unlinks a node from the list and connects its neighbors.

`pList2.nodeUnlink(self)`

* `self`: The node to unlink.


**Notes:**

For example:

```lua
-- Before:
[n1]-[n2]-[n3]-[n4]-[n5]

-- After pList2.nodeUnlink(n3):
[n1]-[n2]-[n4]-[n5]

       [n3]
```


## pList2.nodeUnlinkNext

Unlinks the next node.

`pList2.nodeUnlinkNext(self)`

**Notes:**

For example:

```lua
-- Before:
[n1]-[n2]-[n3]-[n4]-[n5]

-- After pList2.nodeUnlinkNext(n3):
[n1]-[n2]-[n3] × [n4]-[n5]
```


## pList2.nodeUnlinkPrevious

Unlinks the previous node.

`pList2.nodeUnlinkPrevious(self)`

* `self`: The node to unlink.

**Notes:**

For example:

```lua
-- Before:
[n1]-[n2]-[n3]-[n4]-[n5]

-- After pList2.nodeUnlinkPrevious(n3):
[n1]-[n2] × [n3]-[n4]-[n5]
```


## pList2.nodeAssertNoCycles

Raises an error if a list contains cycles (duplicate references or looping) in either direction.

`pList2.nodeAssertNoCycles(self)`

* `self`: Any node in the list to be checked.


# API: List traversal


## pList2.nodeGetHead

Gets the list head (the first node).

`local head = pList2.nodeGetHead(self)`

* `self`: Any node in the list.

**Returns:** The node head.


## pList2.nodeGetTail

Gets the list tail (the last node).

`local tail = pList2.nodeGetTail(self)`

* `self`: Any node in the list.

**Returns:** The node tail.


## pList2.nodeGetNext

Gets the next node.

`local next_node = pList2.nodeGetNext(self)`

* `self`: The node.

**Returns:** The node after `self`, or nil if the end of the list is reached.

**Notes:**

* This may be helpful if the field `["next"]` has been renamed.


## pList2.nodeGetPrevious

Gets the previous node.

`local prev_node = pList2.nodeGetPrevious(self)`

* `self`: The node.

**Returns:** The node before `self`, or nil if the beginning of the list is reached.

**Notes:**

* This may be helpful if the field `["prev"]` has been renamed.


## pList2.nodeIterateNext

An iterator that steps forward through a list.

`for node in pList2.nodeIterateNext(self) do … end`

* `self`: The first node to consider.

**Returns:** Each node in the list, from `self`, stepping forward.


## pList2.nodeIteratePrevious

An iterator that steps backward through a list.

`for node in pList2.nodeIteratePrevious(self) do … end`

* `self`: The first node to consider.

**Returns:** Each node in the list, from `self`, stepping backward.


# API: Ownership checks


## pList2.nodeInListForward

Checks if `node` is in a list, from `self`, marching forward.

`local in_list = pList2.inListForward([self], node)`

* `[self]`: The node to start searching from. Can be false/nil, such that `node["next"]` may be specified.

* `node`: The node to look for.

**Returns:** True if there is a match, false otherwise.


## pList2.nodeInListBackward

Checks if `node` is in a list, from `self`, marching backward.

`local in_list = pList2.nodeInListBackward([self], node)`

* `[self]`: The node to start searching from. Can be false/nil, such that `node["prev"]` may be specified.

* `node`: The node to look for.

**Returns:** True if there is a match, false otherwise.


## pList2.nodeInList

Checks if `node` is in a list.

`local in_list = pList2.nodeInList(self, node)`

* `self`: Any node that *is* part of the list. Cannot be nil.

* `node`: The node to look for.

**Returns:** True if there is a match, false otherwise.
