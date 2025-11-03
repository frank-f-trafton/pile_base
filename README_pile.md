**Version:** 1.315

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


# LICENSE

PILE is provided under two licenses: **MIT** and **MIT-0**. The latter does not require attribution, which may be desirable when including PILE modules in other libraries.

Note that the `test` folder contains libraries which do require attribution.

```
MIT License

Copyright (c) 2024 - 2025 PILE Contributors

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


```
MIT No Attribution

Copyright (c) 2024 - 2025 PILE Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
