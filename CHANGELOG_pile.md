# Changelog: PILE Base

*(Date format: YYYY-MM-DD)*

# v2.012 (2025-12-08)

Changed the version text in the source files, test files and documentation to be uniform, so that it's easier to change with search-and-replace tools.

* `pile_list2.lua`:

  * Fixed `pList2.nodeInList()` incorrectly returning success when beginning the search in the middle of the list (neither the first nor last node). Updated `test_list2.lua`.

* `pile_tree.lua`:

  * Removed an unused argument in `pTree.nodeGetIndex()`.


# v2.011 (2025-12-05)

* `pile_tree.lua`:

  * In the source code, `pTree.nodeAssertIndex()` was incorrectly named `pTree._nodeAssertIndex()` (with a leading underscore).

* `test_tree.lua`:

  * Forgot to include a test job for `pTree.nodeAssertIndex()`.


# v2.010 (2025-12-04)

* Added the modules `pile_line.lua`, `pile_hook.lua`, `pile_list2.lua` and `pile_tree.lua`. The last three are based on work from [ProdUI](https://github.com/frank-f-trafton/prod_ui_wip). `pile_tree.lua` contains a node traversal function that was derived from [LUIGI](https://github.com/airstruck/luigi), so the copyright notice for that library is included as well.

* PILE Rectangle:

  * Added the functions `pRect.flipHorizontal()`, `pRect.flipVertical()`, `pRect.getBounds()` and `pRect.getBoundsT()`.

* PILE Table:

  * Added the function `pTable.arrayHasDuplicateValues()`.

  * Removed an unused depth argument in the internal implementation of `pTable.hasAnyDuplicateTables()`.

* Fixed some mistakes in `test_rectangle.lua`.

* Minor documentation changes/fixes.

* Added the license text to every `.lua` source file, excluding tests.


# v2.000 (2025-11-13)

* Changed license from dual MIT and MIT No Attribution (MIT-0) to just *MIT*.

* `pile_assert.lua`:

  * Added `pAssert.tableWithMetatableEval()` and `pAssert.tableWithoutMetatableEval()`.


# v1.316 (2025-11-04)

* Edited the documentation for PILE Assert and PILE Schema.

* Added some missing tests to `test_assert.lua`.

* Fixed syntax errors in `test_name.lua`.

* `pile_assert.lua`:

  * Renamed `pAssert.tableHasThisMetatable()` to `pAssert.tableWithMetatable()`.

  * Changed some argument names in `pAssert.namedMap()` and `pAssert.namedMapEval()`. These alterations shouldn't cause any change to behavior.

  * Removed `pAssert.numberGEOrOneOf()` because it was too specific.

* `pile_table.lua`:

  * Put the LuaJIT detection code into a `do...end` block to restrict its scope.


# v1.315 (2025-11-03)

* Added `pile_name.lua`.

* Renamed `pile_arg_check.lua` to `pile_assert.lua`.

* `pile_assert.lua`:

  * Argument `n`: added support for functions that return a string.

  * Renamed these integer functions:

	* `pAssert.int()` to `pAssert.integer()`

	* `pAssert.intEval()` to `pAssert.integerEval()`

	* `pAssert.intGE()` to `pAssert.integerGE()`

	* `pAssert.intGEEval()` to `pAssert.integerGEEval()`

	* `pAssert.intRange()` to `pAssert.integerRange()`

	* `pAssert.intRangeEval()` to `pAssert.integerRangeEval()`.

  * Renamed `pAssert.enum()` to `pAssert.namedMap()`

  * Renamed `pAssert.enumEval()` to `pAssert.namedMapEval()`

  * Added `pAssert.fail()` and `pAssert.pass()` (always fail and return, respectively).

* `pile_schema.lua`:

  * Major rewrite. Removed 'Validator' objects entirely. Now, you start the validation procedure by calling `pSchema.validate()` on a model table.

  * Redesigned models to support optional filters (metatable, keys, array, remaining), rather than offering a smorgasbord of model types. Added the function `pSchema.newKeysX()` as a shortcut for the most typical model (filter by key; reject unhandled).

  * Handlers now follow the design of PILE Arg Check functions (beginning with the arguments `n` and `v`; raising an error on failure and returning on success).

  * Removed all of the old built-in handlers, along with the utility functions `pSchema.simpleTypeCheck()`, `pSchema.assertOpts()` and `pSchema.assertOptsSub()`.

  * Changed how nested models are specified. The old way had no means of specifying *optional* model evaluation.

  * Style: removed capitalization of PILE Schema structures (model vs Model, etc.)

* `pile_table.lua`:

  * Renamed `pTable.clear()` to `pTable.clearAll()`, changed its code to remove array indices first, and added an alternate codepath for LuaJIT's `table.clear()`.

  * Removed the metatable for Enums, the function `pTable.getSafeEnumName()`, and migrated the name association logic to `pile_name.lua`.

  * Renamed 'Enum' to 'NamedMap'. (Enumerations are supposed to be ordered.)


# v1.310 (2025-10-22)

* `pile_arg_check.lua`:

  * Renamed these functions:

    * `pArg.type()` -> `pArg.types()`

    * `pArg.typeEval()` -> `pArg.typesEval()`

    * `pArg.type1()` -> `pArg.type()`

    * `pArg.typeEval1()` -> `pArg.typeEval()`

* `pile_schema.lua`:

  * Renamed `handler.type` to `handler.types`.

  * Added tests for `handlers.userdata` when running under LuaJIT. (I don't think there's a way to make a userdata object from PUC-Lua, without help from the host program.)

  * Added tests for LuaJIT's `cdata` type. This is skipped when running under PUC-Lua.


# v1.300 (2025-10-20)

* Added `pile_schema.lua`.

* `pile_table.lua`:

  * Added an `Enum` object, and the functions `pTable.newEnum()`, `pTable.newEnumV()`, and `pTable.safeGetEnumName()`.

  * Added `pTable.safeTableConcat()`.

  * Renamed `pTable.makeLUT()` to `pTable.newLUT()`, and `pTable.makeLUTV()` to `pTable.newLUTV()`.

* `pile_arg_check.lua`:

  * Fixed error messages (incorrect string interpolation) for `pArg.type()` and `pArg.type1()`.

  * Removed some unncesseary checks for NaN (`v ~= v`) in integer assertions, where `math.floor(v) == v` already catches them.

  * Removed `pArg.intRangeStatic()` and `pArg.intRangeStaticEval()` (variants that display the min and max allowed numbers in error messages). I don't think they offer enough context to be helpful, and the user or developer will have to investigate why an out-of-range number was passed to a function anyways.

  * Replaced `pArg.enum()` and `pArg.enumEval()` with functions that take `pTable` Enum objects. Doing it this way eliminates the possibility of mislabeling enums (as the old versions of these functions took a 'name' argument for every call).

  * Added `pArg.oneOf()`.

* `pile_rectangle.lua`:

  * Removed the function `Rect.tostring()`. It was too ambiguous when Rectangle functions are part of a more complex object.


# v1.202 (2025-10-09)

* Added `pile_rectangle.lua` and `pile_pool.lua`.

* `pile_math.lua`:
  * Added `pMath.roundInf()`.

* `pile_table.lua`:
  * Added `pTable.wrap1Array()`.

* `pile_arg_check.lua`:
  * Simplified the implementation of error messages. Removed the 'field' variants of functions, and added a way to get the equivalent 'table X, field X' messaging in the remaining functions.


# v1.201 (2025-09-10)

* `pile_table.lua`:
  * Added `mt_restrict`, a metatable that raises an error when unpopulated fields in a table are read or assigned.


# v1.200 (2025-09-05)
* Changed versioning scheme from `N.N.N` to `N.NNN…`.

* `pile_arg_check.lua`:
  * Updated functions that accept an argument number to use generic error messages when the number is omitted (by passing false/nil).

  * Added these functions, which check values in tables:
    * `pArgCheck.fieldInt()`
    * `pArgCheck.fieldIntEval()`
    * `pArgCheck.fieldIntGE()`
    * `pArgCheck.fieldIntGEEval()`
    * `pArgCheck.fieldIntRange()`
    * `pArgCheck.fieldIntRangeEval()`
    * `pArgCheck.fieldIntRangeStatic()`
    * `pArgCheck.fieldIntRangeStaticEval()`
    * `pArgCheck.fieldNumberNotNaN()`
    * `pArgCheck.fieldNumberNotNaNEval()`
    * `pArgCheck.fieldEnum()`
    * `pArgCheck.fieldEnumEval()`
    * `pArgCheck.fieldNotNil()`
    * `pArgCheck.fieldNotNilNotNaN()`
    * `pArgCheck.fieldNotNilNotFalse()`
    * `pArgCheck.fieldNotNilNotFalseNotNaN()`
    * `pArgCheck.fieldNotNaN()`

  * Changed the arguments and error messages of the existing `pArgCheck.fieldType()`, `pArgCheck.fieldType1()`, `pArgCheck.fieldTypeEval()`, and `pArgCheck.fieldTypeEval1()` functions.

* Minor fixes to documentation. Updated the git repository URL in some places.


# v1.1.91 (2025-08-08)
* `pile_table.lua`:
  * Changed `pTable.patch()` to return a count of fields overwritten (or not overwritten).

* Minor changes to documentation.


# v1.1.9 (2025-07-03)
* `pile_table.lua`:
  * Now depends on `pile_arg_check.lua`.
  * Added `pTable.patch()` and `pTable.hasAnyDuplicateTables()`.
  * Changed `pTable.deepPatch()` to accept another argument, `overwrite`, which controls whether existing key-value pairs in the destination table are overwritten.
  * `pTable.deepPatch()` now verifies that there are no duplicate table references in the provided tables.
  * Changed the internals of `pTable.deepCopy()` and `pTable.deepPatch()` to write array indices from the patch table first. This might help place array indices in the array part of Lua tables, in cases where the patch table contains numeric indices starting from 1.


# v1.1.8 (2025-06-27)
* `pile_table.lua`:
  * Added `pTable.deepPatch()` and `pTable.valueInArray()`.


# v1.1.7 (2025-06-24)
* `pile_table.lua`:
  * Changed `pTable.resolve()` strings so that the initial delimiter is omitted (e.g. change `/foo/bar` to `foo/bar`).


# v1.1.6 (2025-06-20)
* `pile_table.lua`:
  * Now depends on `pile_interp.lua`.
  * Added `pTable.removeElement()`, `pTable.resolve()` and `pTable.assertResolve()`.


# v1.1.5 (2025-06-13)
* Added `pile_math.lua`.
* Added `pile_path.lua`.
* Added `pile_string.lua`.
* `pile_table.lua`:
  * Added `pTable.clear()`, `pTable.clearArray()`, `pTable.copy()`, `pTable.copyArray()`, `pTable.deepCopy()`, `pTable.isArrayOnlyZero()`, `pTable.makeLUTV()`, `pTable.arrayOfHashKeys()`, `pTable.moveElement()`, `pTable.swapElements()`, `pTable.reverseArray()`, `pTable.assignIfNil()`, and `pTable.assignIfNilOrFalse()`.
* Updated copyright year.


# v1.1.4 (2024-11-06)
* `pile_arg_check.lua`:
  * Added `pArgCheck.fieldType()`, `pArgCheck.fieldType1()`, `pArgCheck.fieldTypeEval()`, `pArgCheck.fieldTypeEval1()`
  * Renamed `pArgCheck.evalInt()` to `pArgCheck.intEval()`
  * Renamed `pArgCheck.evalIntGE()` to `pArgCheck.intGEEval()`
  * Renamed `pArgCheck.evalIntRange()` to `pArgCheck.intRangeEval()`
  * Renamed `pArgCheck.evalIntRangeStatic()` to `pArgCheck.intRangeStaticEval()`
  * Fixed error strings used in `pArgCheck.numberNotNaN()` ('unexpected' -> 'expected')
  * Added `pArgCheck.numberNotNaNEval()`
  * Added `pArgCheck.notNil()`, `pArgCheck.notNilNotNaN()`, `pArgCheck.notNilNotFalse()`, `pArgCheck.notNilNotFalseNotNaN()`, and `pArgCheck.notNaN()`
  * Updated some error output to be more descriptive


# v1.1.3 (2024-10-31)

* `pile_arg_check.lua`:
  * All integer assertions now reject NaN values.
  * Fixed order of operations for `pArgCheck.evalInt()` and `pArgCheck.evalIntRange()`.
  * Added `pArgCheck.numberNotNaN()`.
  * Added single-value variants: `pArgCheck.type1()`, `pArgCheck.typeEval1()`
  * Added `pArgCheck.enum()` and `pArgCheck.enumEval()`.
  * Added `pArgCheck.intRangeStatic` and `pArgCheck.evalIntRangeStatic`. These functions report the range in error messages. The original functions now just state that the integer was out of range.

* `pile_utf8.lua`:
  * Minor changes to assertions.
  * No longer prints ranges in error messages due to changes in `pile_arg_check.lua`.

* `pile_utf8_conv.lua`:
  * Minor changes to assertions.
  * Removed unnecessary comma.


# v1.1.2 (2024-10-09)

* `pile_arg_check.lua`:
  * Changed internal table name from `argCheck` to `M`.

* `pile_interp.lua`:
  * Removed unneeded table declaration.

* `pile_utf8_conv.lua`:
  * Added missing comment with version info at the start of the file.


# v1.1.1 (2024-10-07)

* Imported [utf8Tools](https://github.com/rabbitboots/utf8_tools) into PILE Base. Code taken from [kikito/utf8_validator.lua](https://github.com/kikito/utf8_validator.lua) has been removed.
  * `utf8_tools.lua` -> `pile_utf8.lua`
  * `utf8_conv.lua` -> `pile_utf8_conv.lua`


# v1.1.0 (2024-10-04)

* `pile_lut.lua`:
  * Renamed to `pile_table.lua`.
  * Added `pTable.isArray()`
  * Added `pTable.isArrayOnly()`

* `pile_arg_check.lua`:
  * Added `argCheck.evalInt()`
  * Added `argCheck.evalIntGE()`
  * Added `argCheck.evalIntRange()`
  * Tweaked some error strings.


# v1.0.1 (2024-09-23)

* Changed license from MIT to *MIT or MIT-0*.

* Started changelog.
