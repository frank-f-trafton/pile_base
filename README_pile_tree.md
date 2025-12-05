**Version:** 2.010

# PILE Tree

Functions for working with Lua tables as nodes in a tree.


```lua
local pTree = require("pile_tree")

local root = pTree.nodeNew()
local a = pTree.nodeAdd(root)
local b = pTree.nodeAdd(a)

print(a.parent == root) --> true
print(b.parent == a) --> true
print(pTree.nodeGetDepth(b)) --> 3
```


## Dependencies

* `pile_assert.lua`

* `pile_interp.lua`


# Nodes

All pTree nodes have a table of children at `node["nodes"]`, and all nodes except for roots have a link to their parent at `node["parent"]`. (The square bracket notation is used so that the field names can be easily changed with a search-and-replace mechanism.) Every node in a tree must be unique table, or else you risk breaking the traversal code.

PILE Tree's functions can be called as object methods (ie `obj:nodeGetDepth()`) if you attach them to nodes or otherwise make them callable through `__index`.

For more complex use cases, you may need to write your own versions of the functions to create, add and remove nodes.


# API: Node Management

## pTree.nodeNew

Creates a new root node.

`local node = pTree.nodeNew()`

**Returns:** The new root node.


## pTree.nodeAdd

Creates a new child node, attaches it to `self`, and returns the child.

`local child = pTree.nodeAdd(self, [pos])`

* `self`: The node.

* `pos`: *(#nodes + 1)* Where to place the child among `self`'s other children (if any).

**Returns:** The new child node.


## pTree.nodeAttach

Attaches an existing node as a child to `self`. The node to attach must not currently have a parent.

`local child = pTree.nodeAttach(self, node, [pos])`

* `self`: The node.

* `node`: The node to attach.

* `pos`: *(#nodes + 1)* Where to place the child among `self`'s other children (if any).

**Returns:** The newly attached node.

**Notes:**

* Never attach a root node to its own descendants.


## pTree.nodeRemove

Removes a node from its parent. **Cannot be used with root nodes.**

`pTree.nodeRemove(self)`

* `self`: The node to remove.

**Notes:**

* Do not call this function on nodes while looping forward through siblings or walking a tree in pre-order fashion.


## pTree.nodeGetIndex

Gets a node's sibling array index. **Cannot be used with root nodes.**

`pTree.nodeGetIndex(self)`

* `self`: The node.

**Returns:** The index.


## pTree.nodeAssertIndex

Like `pTree.nodeGetIndex()`, but assumes the caller has already checked the parent and obtained a reference to the table of siblings. **Cannot be used with root nodes.**

`pTree.nodeAssertIndex(self, siblings)`

* `self`: The node.

* `siblings`: The table of siblings to check.

**Returns:** The index.


## pTree.nodeGetDepth

Gets a count of a node's ancestors.

`local depth = pTree.nodeGetDepth(self)`

* `self`: The node.

**Returns:** The node's depth in the tree.


## pTree.nodeAssertNoCycles

Checks a tree for duplicate nodes, raising a Lua error if any are found.

`pTree.nodeAssertNoCycles(self)`

* `self`: The node, which should be the tree root.

**Notes:**

* This function incurs some overhead, because it makes a list of visited nodes every time it gets called.


# API: Tree traversal and iterators


## pTree.nodeGetNext

Gets the next node, in pre-order fashion.

`local node = pTree.nodeGetNext(self)`

* `self`: The node.

**Returns:** The next node, or `nil` if this is the very last node.


## pTree.nodeGetPrevious

Gets the previous node, in reverse post-order fashion.

`local node = pTree.nodeGetPrevious(self)`

* `self`: The node.

**Returns:** The previous node, or `nil` if this is the first (root) node.


## pTree.nodeGetNextSibling

Gets the node's next sibling, if any. **Cannot be used with root nodes.**

`local node = pTree.nodeGetNextSibling(self)`

* `self`: The node.

**Returns:** The next sibling, or nil.


## pTree.nodeGetPreviousSibling

Gets the node's previous sibling, if any. **Cannot be used with root nodes.**

`local node = pTree.nodeGetPreviousSibling(self)`

* `self`: The node.

**Returns:** The previous sibling, or nil.


## pTree.nodeGetChild

Gets one of the node's children, or nil if there is no child with this sibling index.

`local child = pTree.nodeGetChild(self, n)`

* `self`: The node.

* `n`: The sibling array index.

**Returns:** The child with this index, or nil.


**Notes:**

* This may be helpful if the `["nodes"]` field has been renamed.


## pTree.nodeGetChildren

Gets the node's table of children.

`local children = pTree.nodeGetChildren(self)`

* `self`: The node.

**Returns:** The node's table of children.

**Notes:**

* This may be helpful if the `["nodes"]` field has been renamed. Note that the returned table is a direct reference to `self["nodes"]`, *not* a copy.


## pTree.nodeGetSiblings

Gets the table of siblings which this node belongs to. **Cannot be run on root nodes.**

`local siblings = pTree.nodeGetSiblings(self)`

* `self`: The node.

**Returns:** The table of siblings.

**Notes:**

* This may be helpful if the `["parent"]` and `["nodes"]` fields have been renamed. Note that the returned table is a direct reference to `self["parent"]["nodes"]`, *not* a copy.


## pTree.nodeGetParent

Gets the node's parent, or nil if it's a root node.

`local parent = pTree.nodeGetParent(self)`

* `self`: any node in the tree.

**Returns:** The parent node, or nil.

**Notes:**

* This may be helpful if the `["parent"]` field has been renamed.


## pTree.nodeAssertParent

Like `pTree.nodeGetParent()`, but raises an error if the parent value is not a table. **Cannot be used with root nodes.**

`pTree.nodeAssertParent(self)`

* `self`: The node.

**Returns:** The parent node.


## pTree.nodeGetRoot

Gets the root node. If this *is* the root node, then returns `self`.

`local root = pTree.nodeGetRoot(self)`

* `self`: any node in the tree.

**Returns:** The root node.


## pTree.nodeGetVeryLast

Gets the very last descendant in the tree, from the perspective of this node. (Keeps selecting the last child until a leaf node is reached.)

`local node = pTree.nodeGetVeryLast(self)`

* `self`: The node to begin searching from.

**Returns:** The deepest and last node, or `self` if the calling node has no descendants.

**Notes:**

* Via [LUIGI](https://github.com/airstruck/luigi/blob/gh-pages/luigi/widget.lua#L375).


## pTree.nodeIterate

A pre-order iterator.

`for node in pTree.nodeIterate(self) do … end`

* `self`: The node, first to be visited.

**Returns:** Each node in the tree, in pre-order fashion, starting with the calling node.


## pTree.nodeIterateBack

A reverse post-order iterator.

`for node in pTree.nodeIterateBack(self) do … end`

* `self`: The node, last to be visited.

**Returns:** Each node in the tree, depth-first, starting with the last, deepest node.


## pTree.nodeForEach

Runs a callback function on the calling node (optionally), and its descendants, in pre-order fashion, stopping if any callback returns a truthy value.

`local a,b,c,d = pTree.nodeForEach(self, inclusive, callback, [...])`

* `self`: The node.

* `inclusive`: When true, runs the callback on `self` before the descendants. When false, skips `self`.

* `callback`: The callback function to run, as `callback(node, ...)`.

* `[...]`: Additional arguments to pass to the callback.

**Returns:** Up to four arguments that were provided by a successful callback, or nil.


## pTree.nodeForEachBack

Like `pTree.nodeForEach()`, but iterates in reverse post-order fashion.

`local a,b,c,d = pTree.nodeForEachBack(self, inclusive, callback, [...])`

* `self`: The node.

* `inclusive`: When true, runs the callback on `self` after the descendants. When false, skips `self`.

* `callback`: The callback function to run, as `callback(node, ...)`

* `[...]`: Additional arguments to pass to the callback.

**Returns:** Up to four arguments that were provided by a successful callback, or nil.


# API: Searches and ownership checks

## pTree.nodeHasThisAncestor

Checks if a node is an ancestor of another node.

`local check = pTree.nodeHasThisAncestor(self, node)`

* `self`: The node to begin searching from.

* `node`: The potential ancestor.

**Returns:** True if the node is an ancestor, false if not.


## pTree.nodeIsInLineage

Like `pTree.nodeHasThisAncestor()`, but also checks `self`.

`local check = pTree.nodeIsInLineage(self, node)`

* `self`: The node.

* `node`: The potential ancestor or `self`.

**Returns:** True if the node is an ancestor or `self == node`, false otherwise.


## pTree.nodeFindKeyInChildren

Looks for a key and value pair in a node's children, starting from index `i`.

`local node, v, i = pTree.nodeFindKeyInChildren(self, i, k, [v])`

* `self`: The node.

* `i`: (*1)* Which child index to start searching from.

* `k`: The key to look for.

* `v`: (*nil*) The value to look for. When nil, any non-false value will be accepted.

**Returns:** On success, the node, the value (`node[k]`), and the node's child index. On failure, nil.

**Notes:**

* Returns the first successful match.


## pTree.nodeFindKeyDescending

Looks for a key and value pair in a node, searching downward through this node's descendants (and optionally itself).

`local node, v = pTree.nodeFindKeyDescending(self, inclusive, k, [v])`

* `self`: The node.

* `inclusive`: When true, include the calling node in the search.

* `k`: The key to look for.

* `v`: (*nil*) The value to look for. When nil, any non-false value will be accepted.

**Returns:** On success, the node and the value (`node[k]`). On failure, nil.

**Notes:**

* Does not return multiple successful candidates.


## pTree.nodeFindKeyAscending

Looks for a key and value pair in a node, searching upward through this node's direct ancestors (and optionally itself).

`local node, v = pTree.nodeFindKeyAscending(self, inclusive, k, [v])`

* `self`: The node.

* `inclusive`: When true, include the calling node in the search.

* `k`: The key to look for.

* `v`: (*nil*) The value to look for. When nil, any non-false value will be accepted.

**Returns:** On success, the node and the value (`node[k]`). On failure, nil.

**Notes:**

* Does not return multiple successful candidates.


# Module Notes

## Traversal order

Given a tree with one root (R), two children (A, B), and four grandchildren (two per child; A1, A2, B1, B2)…

```
           ╭───╮
           │ R │
           ╰─┬─╯
     ┌───────┴───────┐
   ╭─┴─╮           ╭─┴─╮
   │ A │           │ B │
   ╰─┬─╯           ╰─┬─╯
  ┌──┴──┐         ┌──┴──┐
╭─┴─╮ ╭─┴─╮     ╭─┴─╮ ╭─┴─╮
│A1 │ │ A2│     │B1 │ │ B2│
╰───╯ ╰───╯     ╰───╯ ╰───╯
```

…the tree traversals look like this:

Pre-order: R, A, A1, A2, B, B1, B2

Reverse post-order: B2, B1, B, A2, A1, A, R
