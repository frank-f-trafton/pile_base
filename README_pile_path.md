**Version:** v1.201

# PILE: Path

Functions for working with paths.

This module is intended for [LÖVE](https://www.love2d.org/)'s virtual filesystem paths. As such, they assume that all paths use `/` as directory separators, and they are not aware of `.` and `..`.


```lua
local pPath = require("path.to.pile_path")

local my_path = pPath.join("foo", "bar") --> "foo/bar"
```


## Dependencies

None.


# Path API

## pPath.getExtension

Gets the extension at the end of a file path.

`local ext = pPath.getExtension(path)`

* `path`: The file path.

**Returns:** The extension (including the dot), or an empty string if the path did not end with an extension.

**Notes:**

* When the file path ends with multiple extensions, like `my_file.txt.zip`, only the last part (`.zip`) is returned.


## pPath.join

Joins two path fragments.

`local joined = pPath.join(a, b)`

* `a`: The first path fragment.
* `b`: The second path fragment.

**Returns:** The joined path.

**Notes:**

* This function:
  * Adds a slash between 'a' and 'b', when 'a' is not an empty string.
  * Removes leading and trailing slashes.
  * Does *not* remove multiple consecutive slashes within fragments, like `foo//bar`.


## pPath.splitPathAndExtension

Splits the extension from a file path.

`local main, ext = pPath.splitPathAndExtension(path)`

* `path`: The file path.

**Returns:** The main path component and the extension (or an empty string if there was no extension).
