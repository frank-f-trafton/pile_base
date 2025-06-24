**Version:** v1.1.7

# PILE Math

A small collection of math functions.

There is nothing terribly impressive here, but Lua ships with a pretty meagre math library, so here we are.


```lua
local pMath = require("path.to.pile_math")

print(pMath.clamp(100, 1, 50)) --> 50
```


## Dependencies

None.


# PILE Math API


## pMath.clamp

Clamps a number within a range.

`local clamped = pMath.clamp(n, a, b)`

* `n`: The number to clamp.
* `a`: The minimum value.
* `b`: The maximum value.

**Returns:** The clamped value.

**Notes:**

* If the minimum is greater than the maximum, then this function will return the minimum.


## pMath.lerp

Gets a value between two numbers, using [linear interpolation](https://en.wikipedia.org/wiki/Linear_interpolation).

`local lerped = pMath.lerp(a, b, v)`

* `a`: The first point.
* `b`: The second point.
* `v`: The input value, between 0.0 and 1.0.

**Returns:** The interpolated value.

**Notes:**

* This function does not clamp the input value.


## pMath.sign

Gets the sign of a number.

`local s = pMath.sign(n)`

* `n`: The number to check.

**Returns:** -1 if the number is less than zero, 1 if the number is greater than zero, or 0 if the number is zero.


## pMath.signN

Gets the sign of a number, treating zero as negative.

`local sign = pMath.signN(n)`

* `n`: The number to check.

**Returns:** -1 if the number is zero or less, 1 if the number is greater than zero.


## pMath.signP

Gets the sign of a number, treating zero as positive.

`local s = pMath.signP(n)`

* `n`: The number to check.

**Returns:** -1 if the number is less than zero, 1 if the number is zero or greater.


## pMath.wrap1

Wraps a one-indexed number using the modulo operator.

`local wrapped = pMath.wrap1(n, max)`

* `n`: The number to wrap.
* `max`: The maximum to use with modulo. Should be 1 or greater.

**Returns:** The wrapped number.

**Notes:**

* Intended for Lua array indices.

* A `max` of zero will produce NaN.
