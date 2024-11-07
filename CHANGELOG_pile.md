# Changelog: PILE Base

*(Date format: YYYY-MM-DD)*

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
