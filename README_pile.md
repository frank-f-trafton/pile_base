**Version:** 2.000

# PILE Base

A utility library for Lua.

## PILE Modules

* `pile_assert.lua`: Assertions for function arguments (type checking, etc.).
  * Requires: `pile_interp.lua`

* `pile_interp.lua`: String interpolation with position-independent arguments.

* `pile_math.lua`: Some basic math functions.

* `pile_name.lua`: Name registry, for associating Lua objects (e.g. metatables) with string IDs.

* `pile_path.lua`: Functions for working with LÖVE virtual filesystem paths.

* `pile_pool.lua`: Pooling of objects. **Experimental**
  * Requires: `pile_assert.lua`

* `pile_rectangle.lua`: Positioning and manipulation of rectangle structures.
  * Requires: `pile_assert.lua`, `pile_math.lua`

* `pile_scale.lua`: Scaling of numbers and integers.
  * Requires: `pile_assert.lua`

* `pile_schema.lua`: Lua table validation.
  * Requires: `pile_assert.lua`, `pile_interp.lua`, `pile_table.lua`

* `pile_string.lua`: Some common string patterns.

* `pile_table.lua`: Table, array functions.
  * Requires: `pile_assert.lua`, `pile_interp.lua`

* `pile_utf8.lua`: UTF-8 helper functions.
  * Requires: `pile_assert.lua`, `pile_interp.lua`

* `pile_utf8_conv.lua`: UTF-8 to UTF-16 conversion functions.
  * Requires: `pile_assert.lua`, `pile_interp.lua`, `pile_utf8.lua`


# Contributors

* [Frank F. Trafton](https://github.com/frank-f-trafton/)


# Code Sourced From Other Libraries

* None (yet)


# License

As of v2.000, PILE Base is provided under the terms of the MIT License. Please see `LICENSE_pile` for the text and copyright notice.

Versions 1.0.1 through 1.316 had a dual license: **MIT** and **MIT No Attribution**. For v2.000, the latter was removed so that functionality from other MIT-licensed libraries could be included.

The libraries in the `test` subdirectory contain additional license details and copyright info.
