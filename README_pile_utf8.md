VERSION: 2.022

# PILE UTF-8

*pUTF8* contains a set of UTF-8 utility functions for Lua 5.1 - 5.4.

`pile_utf8.lua` is the main file.

`pile_utf8_conv.lua` contains auxiliary functions for converting UTF-16 and ISO 8859-1 (Latin-1) to UTF-8 and back.


```lua
local pUTF8 = require("pile_utf8")

print(pUTF8.check("good string"))
--> 11

print(pUTF8.check("bad" .. string.char(0xff) .. "string"))
--> nil; unknown UTF-8 byte length marker; 4
```

## Dependencies

### pile_utf8.lua

* `pile_assert.lua`

* `pile_interp.lua`


### pile_utf8_conv.lua

* `pile_assert.lua`

* `pile_interp.lua`

* `pile_utf8.lua`


# UTF8 API

## pUTF8.getCheckSurrogates

Gets the library's setting for checking surrogate values.

`local enabled = pUTF8.getCheckSurrogates()`

**Returns:** `true` if surrogates are rejected as invalid, `false` if they are ignored.


## pUTF8.setCheckSurrogates

*Default: true*

Sets the library to check or ignore surrogate values.

`pUTF8.setCheckSurrogates(enabled)`

* `enabled`: `true` to reject surrogates as invalid, `false/nil` to ignore them.


## pUTF8.check

Checks a UTF-8 string for encoding problems and invalid code points.

`local ok, err, byte = pUTF8.check(s, [i], [j])`

* `s`: The string to check.

* `[i]`: *(empty string: 0; non-empty string: 1)* The first byte index.

* `[j]`: *(#str)* The last byte index. Cannot be lower than `i`.

**Returns:** If no problems were found, the total number of code points scanned. Otherwise, `nil`, error string, and byte index.

**Notes:**

* As a special case, this function will return `0` when given an empty string and values of zero for `i` and `j`. (In other words, `pUTF8.check("")` will always return `0`.)

* For non-empty strings, if the range arguments are specified, then `i` needs to point to a UTF-8 Start Byte, and `j` needs to point to the last byte of a UTF-8-encoded character.


## pUTF8.scrub

Replaces bad UTF-8 Sequences in a string.

`local str = pUTF8.scrub(s, repl)`

* `s`: The string to scrub.

* `repl`: A replacement string to use in place of the bad UTF-8 Sequences. Use an empty string to remove the invalid bytes.

**Returns:** The scrubbed UTF-8 string.


## pUTF8.codeFromString

Gets a Unicode Code Point and its isolated UTF-8 Sequence from a string.

`local code, u8_seq = pUTF8.codeFromString(s, [i])`

* `s`: The UTF-8 string to read. Cannot be empty.

* `[i]`: *(1)* The byte position to read from. Must point to a valid UTF-8 Start Byte.

**Returns:** The code point number and its equivalent UTF-8 Sequence as a string, or `nil` plus an error string if unsuccessful.


## pUTF8.stringFromCode

Converts a code point in numeric form to a UTF-8 Sequence (string).

`local u8_seq, err = pUTF8.stringFromCode(c)`

* `c`: The code point number.

**Returns:** the UTF-8 Sequence (string), or `nil` plus an error string if unsuccessful.


## pUTF8.step

Looks for a Start Byte from a byte position through to the end of the string.

This function **does not validate** the encoding.

`local index = pUTF8.step(s, i)`

* `s`: The string to search.

* `i`: Starting position; bytes *after* this index are checked. Can be from `0` to `#str`.

**Returns:** Index of the next Start Byte, or `nil` if the end of the string is reached.

**Notes:**

* With empty strings, the only accepted position for `i` is 0.


## pUTF8.stepBack

Looks for a Start Byte from a byte position through to the start of the string.

This function **does not validate** the encoding.

`local index = pUTF8.stepBack(s, i)`

* `s`: The string to search.

* `i`: Starting position; bytes *before* this index are checked. Can be from `1` to `#str + 1`.

**Returns:** Index of the previous Start Byte, or `nil` if the start of the string is reached.

**Notes:**

* With empty strings, the only accepted position for `i` is 1.


## pUTF8.codes

A loop iterator for code points in a UTF-8 string, where `i` is the byte position, `c` is the code point number, and `u` is the code point's UTF-8 substring.

This function **raises a Lua error** if it encounters a problem with the UTF-8 encoding or with the code point values.

`for i, c, u in utf8.codes(s) do …`

* `s`: The string to iterate.

**Returns:** The byte position `i`, the code point number `c`, and the code point's UTF-8 string representation `u`.


## pUTF8.concatCodes

Creates a UTF-8 string from one or more code point numbers.

This function **raises a Lua error** if it encounters a problem with the code point numbers.

`local str = pUTF8.concatCodes(...)`

* `...`: Code point numbers.

**Returns:** A concatenated UTF-8 string.

**Notes:**

* This function allocates a temporary table. To convert single code points, `pUTF8.stringFromCode()` can be used instead.


# UTF8Conv API

## pUTF8Conv.latin1_utf8

Converts a Latin 1 (ISO 8859-1) string to UTF-8.

`pUTF8Conv.latin1_utf8(s)`

* `s`: The Latin 1 string to convert.

**Returns:** The converted UTF-8 string, or `nil`, error string, and byte index if there was a problem.


## pUTF8Conv.utf8_latin1

Converts a UTF-8 string to Latin 1 (ISO 8859-1).

Only code points 0 through 255 can be directly mapped to a Latin 1 string. Use the `[unmapped]` argument to control what happens when an unmappable code point is encountered.

`pUTF8Conv.utf8_latin1(s, [unmapped])`

* `s`: The UTF-8 string to convert.

* `[unmapped]`: When `unmapped` is a string, it is used in place of unmappable code points. (Pass in an empty string to ignore unmappable code points.) When `unmapped` is any other type, the function returns `nil`, an error string, and the byte where the unmappable code point was encountered.

**Returns:** The converted Latin 1 string, or `nil`, error string, and byte index if there was a problem.


## pUTF8Conv.utf16_utf8

Converts a UTF-16 string to UTF-8.

`pUTF8Conv.utf16_utf8(s, [big_en])`

* `s`: The UTF-16 string to convert.

* `[big_en]`: *(nil)* `true` if the input UTF-16 string is big-endian, `false/nil` if it is little-endian.

**Returns:** The converted UTF-8 string, or `nil`, error string, and byte index if there was a problem.


## pUTF8Conv.utf8_utf16

Converts a UTF-8 string to UTF-16.

`pUTF8Conv.utf8_utf16(s, [big_en])`

* `s`: The UTF-8 string to convert.

* `[big_en]`: *(nil)* `true` if the converted UTF-16 string is big-endian, `false/nil` if it is little-endian.

**Returns:** The converted UTF-16 string, or `nil`, error string, and byte index if there was a problem.


# Notes

## Terminology

**Code Point**: a Unicode Code Point, stored as a Lua number. `65` (for A)

**UTF-8 Sequence**: A single Unicode Code Point, encoded in UTF-8 and stored as a Lua string. `"A"`

**Start Byte**: The first byte in a UTF-8 Sequence. The length of the sequence is encoded in the start byte.

**Continuation Byte**: The second, third or fourth byte in a UTF-8 Sequence. A UTF-8 Sequence may not be longer than 4 bytes.

**Surrogate**: Values in the range of U±D800 to U±DFFF are reserved for *surrogate pairs* in UTF-16, and are not valid code points.


## References

* [UTF-8 RFC 3629](https://tools.ietf.org/html/rfc3629)

* [UTF-16 RFC 2781](https://www.rfc-editor.org/rfc/rfc2781)

* [Wikipedia: Unicode](https://en.wikipedia.org/wiki/Unicode)

* [Wikipedia: UTF-8](https://en.wikipedia.org/wiki/UTF-8)
