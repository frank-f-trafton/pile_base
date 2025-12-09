VERSION: 2.012

# PILE Math

A small collection of math functions.

There is nothing terribly impressive here, but Lua ships with a pretty meagre math library, so here we are.


```lua
local pMath = require("pile_math")

print(pMath.clamp(100, 1, 50)) --> 50
```


## Dependencies

None.


# Math API


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


## pMath.roundInf

Rounds a number towards infinity. `0.5` rounds to `1.0`; `-0.5` rounds to `-1.0`.

`local rounded = pMath.roundInf(n)`

* `n`: The number to round.

**Returns:** The rounded number.

**Notes**:

* This function is susceptible to floating point rounding error when the input is extremely close to, but not exactly 0.5 or -0.5:

```lua
print(pMath.roundInf(0.49999999999999994)) --> 1
print(pMath.roundInf(-0.49999999999999994)) --> -1
```


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
