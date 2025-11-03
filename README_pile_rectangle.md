**Version:** 1.315

# PILE Rectangle

Functions for placing and mutating axis-aligned rectangles.


```lua
local pRect = require("path.to.pile_rectangle")

local r1 = {x=0, y=0, w=16, h=16}
local r2 = {x=0, y=0, w=8, h=8}
pRect.copy(r1, r2)

print(r2.w, r2.h) --> 16 16
```


## Dependencies

* `pile_assert.lua`

* `pile_math.lua`


## Structures

PILE Rectangle does not come with functions to create the following structures. Any table that contains the expected fields may be used. Out of concern for overhead, function arguments are not validated by default.

### Rectangle

PILE Rectangle's main structure is a table with `x`, `y`, `w` and `h` fields, all numbers. The width and height are assumed to be greater than or equal to zero.

`local rect = {x=0, y=0, w=0, h=0}`


### SideDelta

A table with measurements for each side of a rectangle. These are typically used to apply margins, padding, etc.

`local sd = {x1=0, y1=0, x2=0, y2=0} -- left, top, right, bottom`


# Rectangle API

Functions that would only change one variable in a trivial way, like `setX()` or `setHeight()`, are omitted from the API.

## pRect.set, pRect.setPosition, pRect.setDimensions

Sets a Rectangle's position and dimensions.

`pRect.set(r, x, y, w, h)`

`pRect.setPosition(r, x, y)`

`pRect.setDimensions(r, w, h)`

* `r`: The Rectangle to modify.

* `x`, `y`: The new position.

* `w`, `h`: The new dimensions.

**Returns:** `r`, for method chaining.


## pRect.copy

Overwrites the position and dimensions of Rectangle `b` with those of `a`.

`pRect.copy(a, b)`

* `a`: The source Rectangle.

* `b`: The Rectangle to overwrite.

**Returns:** `a`, for method chaining.


## pRect.expand, pRect.reduce

Resizes a Rectangle by shifting its sides.

`pRect.expand(r, x1, y1, x2, y2)`

`pRect.reduce(r, x1, y1, x2, y2)`

* `r`: The Rectangle to expand.

* `x1`, `y1`: The amount to shift the left and top sides.

* `x2`, `y2`: The amount to shift the right and bottom sides.

**Returns:** `r`, for method chaining.


## pRect.expandT, pRect.reduceT

These functions are Like `pRect.expand()` and `pRect.reduce()`, but they take SideDelta tables.

`pRect.expandT(r, sd)`

`pRect.reduceT(r, sd)`

* `r`: The Rectangle to change.

* `sd`: The SideDelta to use.

**Returns:** `r`, for method chaining.


## pRect.expandHorizontal, pRect.reduceHorizontal

Shifts a Rectangle's left and right sides.

`pRect.expandHorizontal(r, x1, x2)`

`pRect.reduceHorizontal(r, x1, x2)`

* `r`: The Rectangle to change.

* `x1`, `x2`: The amount to shift the left and right sides.

**Returns:** `r`, for method chaining.


## pRect.expandVertical, pRect.reduceVertical

Shifts a Rectangle's top and bottom sides.

`pRect.expandVertical(r, y1, y2)`

`pRect.reduceVertical(r, y1, y2)`

* `r`: The Rectangle to change.

* `y1`, `y2`: The amount to shift the top and bottom sides.

**Returns:** `r`, for method chaining.


## pRect.expandLeft, pRect.reduceLeft

Shifts a Rectangle's left side.

`pRect.expandLeft(r, x1)`

`pRect.reduceLeft(r, x1)`

* `r`: The Rectangle to change.

* `x1`: The amount to shift the left side.

**Returns:** `r`, for method chaining.


## pRect.expandRight, pRect.reduceRight

Shifts a Rectangle's right side.

`pRect.expandRight(r, x2)`

`pRect.reduceRight(r, x2)`

* `r`: The Rectangle to change.

* `x2`: The amount to shift the right side.

**Returns:** `r`, for method chaining.


## pRect.expandTop, pRect.reduceTop

Shifts a Rectangle's top side.

`pRect.expandTop(r, y1)`

`pRect.reduceTop(r, y1)`

* `r`: The Rectangle to change.

* `y1`: The amount to shift the top side.

**Returns:** `r`, for method chaining.


## pRect.expandBottom, pRect.reduceBottom

Shifts a Rectangle's bottom side.

`pRect.expandBottom(r, y2)`

`pRect.reduceBottom(r, y2)`

* `r`: The Rectangle to change.

* `y2`: The amount to shift the bottom side.

**Returns:** `r`, for method chaining.


## pRect.splitLeft

Shortens Rectangle `a` by cutting a chunk from its left side, and overwrites Rectangle `b` to match the chunk.

`pRect.splitLeft(a, b, len)`

* `a`: The Rectangle to shorten.

* `b`: The Rectangle to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pRect.splitRight

Shortens Rectangle `a` by cutting a chunk from its right side, and overwrites Rectangle `b` to match the chunk.

`pRect.splitRight(a, b, len)`

* `a`: The Rectangle to shorten.

* `b`: The Rectangle to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pRect.splitTop

Shortens Rectangle `a` by cutting a chunk from its top side, and overwrites Rectangle `b` to match the chunk.

`pRect.splitTop(a, b, len)`

* `a`: The Rectangle to shorten.

* `b`: The Rectangle to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pRect.splitBottom

Shortens Rectangle `a` by cutting a chunk from its bottom side, and overwrites Rectangle `b` to match the chunk.

`pRect.splitBottom(a, b, len)`

* `a`: The Rectangle to shorten.

* `b`: The Rectangle to be assigned the removed part.

**Returns:** `a`, for method chaining.


## pRect.split

Splits a Rectangle.

`pRect.split(a, b, side, len)`

* `a`: The input Rectangle

* `b`: The output Rectangle.

* `side`: The side to split: `left`, `right`, `top`, or `bottom`.

* `len`: The length of the split.

**Returns:** `a`, for method chaining.


## pRect.splitOrOverlay

Splits or copies a Rectangle, based on the arguments provided.

`pRect.splitOrOverlay(a, b, placement, len)`

* `a`: The input Rectangle

* `b`: The output Rectangle.

* `placement`: How to place Rectangle `b`: by splitting Rectangle `a` (`left`, `right`, `top`, `bottom`), or by copying it (`overlay`).

* `len`: The length of the split. Not used when the placement mode is `overlay`.

**Returns:** `a`, for method chaining.


## pRect.placeInner

Places Rectangle `b` within the boundaries of Rectangle `a` at an interpolated position.

`pRect.placeInner(a, b, ux, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Assumes that `a` is at least as big as `b`.

* Rounds the final position of `b` to integers.


## pRect.placeInnerHorizontal

Like `pRect.placeInner()`, but acts only on the horizontal axis.

`pRect.placeInnerHorizontal(a, b, ux)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.placeInnerVertical

Like `pRect.placeInner()`, but acts only on the vertical axis.

`pRect.placeInnerVertical(a, b, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.placeMidpoint

Places Rectangle `b`'s center point within the boundaries of Rectangle `a`, at an interpolated position.

`pRect.placeMidpoint(a, b, ux, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Rounds the final position of `b` to integers.


## pRect.placeMidpointHorizontal

Like `pRect.placeMidpoint()`, but acts only on the horizontal axis.

`pRect.placeMidpointHorizontal(a, b, ux)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.placeMidpointVertical

Like `pRect.placeMidpoint()`, but acts only on the vertical axis.

`pRect.placeMidpointVertical(a, b, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.placeOuter

Places Rectangle `b` within or just outside the boundaries of Rectangle `a` at an interpolated position.

`pRect.placeOuter(a, b, ux, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.

**Notes:**

* Rounds the final position of `b` to integers.


## pRect.placeOuterHorizontal

Like `pRect.placeOuter()`, but acts only on the horizontal axis.

`pRect.placeOuterHorizontal(a, b, ux)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `ux`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.placeOuterVertical

Like `pRect.placeOuter()`, but acts only on the vertical axis.

`pRect.placeOuterVertical(a, b, uy)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to place.

* `uy`: A number from 0.0 to 1.0.

**Returns:** `a`, for method chaining.


## pRect.center

Centers Rectangle `b` within Rectangle `a`.

`pRect.center(a, b)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to center.

**Returns:** `a`, for method chaining.


## pRect.centerHorizontal

Like `pRect.center()`, but acts only on the horizontal axis.

`pRect.centerHorizontal(a, b)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to center.

**Returns:** `a`, for method chaining.


## pRect.centerVertical

Like `pRect.center()`, but acts only on the vertical axis.

`pRect.centerVertical(a, b)`

* `a`: The reference Rectangle.

* `b`: The Rectangle to center.

**Returns:** `a`, for method chaining.


## pRect.pointOverlap

Checks if a point is within a Rectangle.

`local overlap = pRect.pointOverlap(r, x, y)`

* `r`: The Rectangle to check.

* `x`, `y`: The point's position.

**Returns:** true if the point overlaps the Rectangle, false if not.
