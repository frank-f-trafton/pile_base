**Version:** 2.010

# PILE Base

A utility library for Lua.

## PILE Modules

* `pile_assert.lua`: Assertions for function arguments (type checking, etc.).
  * Requires: `pile_interp.lua`

* `pile_hook.lua`: Callable arrays of functions.
  * Requires: `pile_assert.lua`

* `pile_interp.lua`: String interpolation with position-independent arguments.

* `pile_line.lua`: Manipulates axis-aligned line segments.
  * Requires: `pile_assert.lua`, `pile_math.lua`

* `pile_math.lua`: Some basic math functions.

* `pile_name.lua`: Name registry, for associating Lua objects (e.g. metatables) with string IDs.

* `pile_path.lua`: Functions for working with LÖVE virtual filesystem paths.

* `pile_pool.lua`: Pooling of objects. **Experimental**
  * Requires: `pile_assert.lua`

* `pile_rectangle.lua`: Manipulates axis-aligned rectangles.
  * Requires: `pile_assert.lua`, `pile_math.lua`

* `pile_scale.lua`: Scales numbers, particularly integers.
  * Requires: `pile_assert.lua`

* `pile_schema.lua`: Validates Lua tables.
  * Requires: `pile_assert.lua`, `pile_interp.lua`, `pile_table.lua`

* `pile_string.lua`: Some common string patterns.

* `pile_table.lua`: Table, array functions.
  * Requires: `pile_assert.lua`, `pile_interp.lua`

* `pile_tree.lua`: An implementation of tree structures.
  * Requires: `pile_assert.lua`, `pile_interp.lua`

* `pile_utf8.lua`: UTF-8 helper functions.
  * Requires: `pile_assert.lua`, `pile_interp.lua`

* `pile_utf8_conv.lua`: Converts UTF-8 to UTF-16 and vice versa.
  * Requires: `pile_assert.lua`, `pile_interp.lua`, `pile_utf8.lua`


# Contributors

* [Frank F. Trafton](https://github.com/frank-f-trafton/)


# License

As of v2.000, PILE Base is provided under the terms of the MIT License. Please see `LICENSE_pile` for the text and copyright notice.

Versions 1.0.1 through 1.316 had a dual license: **MIT** and **MIT No Attribution**. For v2.000, the latter was removed so that code from other MIT-licensed libraries could be included.

The libraries in the `test` subdirectory contain additional license details and copyright info.


```
MIT License

Copyright (c) 2024 - 2025 PILE Contributors

PILE Base uses code from these libraries:

PILE Tree:
  LUIGI
  Copyright (c) 2015 airstruck
  License: MIT
  https://github.com/airstruck/luigi


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
