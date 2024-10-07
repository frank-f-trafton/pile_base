# Changelog: PILE Base

*(Date format: YYYY-MM-DD)*

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
