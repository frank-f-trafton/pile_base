**Version:** 1.300

# PILE: String

This module is a dumping ground for string functions and patterns.


## Dependencies

None.


# String API

## pString.ptn_dollar

A pattern for [string.gsub](https://www.lua.org/manual/5.1/manual.html#pdf-string.gsub), matching a dollar sign followed by any combination of ASCII letters, numbers and underscores.

* `$FOO_bar123`


## pString.ptn_percent

A pattern for [string.gsub](https://www.lua.org/manual/5.1/manual.html#pdf-string.gsub), matching a two percent signs surrounding any combination of ASCII letters, numbers and underscores.

* `%FOO_bar123%`
