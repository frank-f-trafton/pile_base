# Changelog: PILE Base

*(Date format: YYYY-MM-DD)*

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
