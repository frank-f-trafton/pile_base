**Version:** 2.011

# PILE Line

Functions for placing and mutating axis-aligned line segments.

This is a one-dimensional version of **PILE Rectangle**.


```lua
local pLine = require("pile_line")

local l1 = {x=0, w=16}
local l2 = {x=0, w=8}
pLine.copy(l1, l2)

print(l2.x, l2.w) --> 0 16
```


## Dependencies

* `pile_assert.lua`

* `pile_math.lua`


## Structures

PILE Line does not come with functions to create the following structures. Any table that contains the expected fields may be used. Out of concern for overhead, function arguments are not validated by default.

### LineSegment

PILE Line's main structure is a table with `x` and `w` fields, both numbers. The width is assumed to be greater than or equal to zero.

`local LineSegment = {x=0, w=0}`


### SideDelta

A table with measurements for each side of a LineSegment. These are typically used to apply margins, padding, etc.

`local sd = {x1=0, x2=0} -- left, right`


# API: PILE Line

Functions that would only change one variable in a trivial way, like `setPosition()` or `setWidth()`, are omitted from the API.

## pLine.set

Sets a LineSegment's position and dimension.

`pLine.set(a, x, w)`

* `a`: The LineSegment to modify.

* `x`: The new position.

* `w`: The new width.

**Returns:** `a`, for method chaining.


## pLine.copy

Overwrites the position and dimensions of LineSegment `b` with those of `a`.

`pLine.copy(a, b)`

* `a`: The source LineSegment.

* `b`: The LineSegment to overwrite.

**Returns:** `a`, for method chaining.


## pLine.expand, pLine.reduce

Resizes a LineSegment by shifting its sides.

`pLine.expand(a, x1, x2)`

`pLine.reduce(a, x1, x2)`

* `a`: The LineSegment to modify.

* `x1`: The amount to shift the left side.

* `x2`: The amount to shift the right side.

**Returns:** `a`, for method chaining.


## pLine.expandT, pLine.reduceT

These functions are Like `pLine.expand()` and `pLine.reduce()`, but they take SideDelta tables.

`pLine.expandT(a, sd)`

`pLine.reduceT(a, sd)`

* `a`: The LineSegment to modify.

* `sd`: The SideDelta to use.

**Returns:** `a`, for method chaining.


## pLine.expandLeft, pLine.reduceLeft

Shifts a LineSegment's left side.

`pLine.expandLeft(a, x1)`

`pLine.reduceLeft(a, x1)`

* `a`: The LineSegment to modify.

* `x1`: The amount to shift the left side.

**Returns:** `a`, for method chaining.


## pLine.expandRight, pLine.reduceRight

Shifts a LineSegment's right side.

`pLine.expandRight(a, x2)`

`pLine.reduceRight(a, x2)`

* `a`: The LineSegment to modify.

* `x2`: The amount to shift the right side.

**Returns:** `a`, for method chaining.


## pLine.splitLeft

Shortens LineSegment `a` by cutting a chunk from its left side, and overwrites LineSegment `b` to match the chunk.

`pLine.splitLeft(a, b, len)`

* `a`: The LineSegment to shorten.

* `b`: The LineSegment to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pLine.splitRight

Shortens LineSegment `a` by cutting a chunk from its right side, and overwrites LineSegment `b` to match the chunk.

`pLine.splitRight(a, b, len)`

* `a`: The LineSegment to shorten.

* `b`: The LineSegment to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pLine.split

Splits a LineSegment.

`pLine.split(a, b, side, len)`

* `a`: The input LineSegment.

* `b`: The output LineSegment.

* `side`: The side to split: `left` or `right`.

* `len`: The length of the split.

**Returns:** `a`, for method chaining.


## pLine.splitOrOverlay

Splits or copies a LineSegment, based on the arguments provided.

`pLine.splitOrOverlay(a, b, placement, len)`

* `a`: The input LineSegment.

* `b`: The output LineSegment.

* `placement`: How to place LineSegment `b`: by splitting LineSegment `a` (`left` or `right`), or by copying it (`overlay`).

* `len`: The length of the split. Not used when the placement mode is `overlay`.

**Returns:** `a`, for method chaining.


## pLine.placeInner

Places LineSegment `b` within the boundaries of LineSegment `a` at an interpolated position.

`pLine.placeInner(a, b, unit)`

* `a`: The reference LineSegment.

* `b`: The LineSegment to place.

* `unit`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Assumes that `a` is at least as big as `b`.

* Rounds the final position of `b` to integers.


## pLine.placeMidpoint

Places LineSegment `b`'s center point within the boundaries of LineSegment `a`, at an interpolated position.

`pLine.placeMidpoint(a, b, unit)`

* `a`: The reference LineSegment.

* `b`: The LineSegment to place.

* `unit`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Rounds the final position of `b` to integers.


## pLine.placeOuter

Places LineSegment `b` within or just outside the boundaries of LineSegment `a` at an interpolated position.

`pLine.placeOuter(a, b, unit)`

* `a`: The reference LineSegment.

* `b`: The LineSegment to place.

* `unit`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Rounds the final position of `b` to integers.


## pLine.center

Centers LineSegment `b` within LineSegment `a`.

`pLine.center(a, b)`

* `a`: The reference LineSegment.

* `b`: The LineSegment to center.

**Returns:** `a`, for method chaining.


## pLine.flip

Flips the LineSegment in relation to another LineSegment.

`pLine.flip(a, b)`

* `a`: The reference LineSegment.

* `b`: The LineSegment to flip.

**Returns:** `a`, for method chaining.


## pLine.positionOverlap

Checks if a position is within a LineSegment.

`local overlap = pLine.positionOverlap(a, x)`

* `a`: The LineSegment to check.

* `x`: The position.

**Returns:** true if the point overlaps the LineSegment, false if not.


## pLine.getBounds

Gets the range of a group of LineSegments.

`local x1, x2 = pLine.getBounds(...)`

* `...`: A vararg list of LineSegments.

**Returns:** The furthest left and right positions.

**Notes:**

* If no LineSegments are provided, this function will return zero for both positions.


## pLine.getBoundsT

Like `pLine.getBounds()`, but takes an array of LineSegments rather than a vararg list.

`local x1, x2 = pLine.getBoundsT(list)`

* `list`: An array of LineSegments.

**Returns:** The furthest left and right positions.

**Notes:**

* If there are no elements in the array, this function will return zero for both positions.
