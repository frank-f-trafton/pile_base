-- Test: pile_path.lua
-- v2.010


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pPath = require(PATH .. "pile_path")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Path", cli_verbosity)


self:registerFunction("pPath.getExtension()", pPath.getExtension)


-- [===[
self:registerJob("pPath.getExtension", function(self)
	-- [====[
	do
		local output = self:expectLuaReturn("Get extension", pPath.getExtension, "foo/bar.zip")
		self:isEqual(output, ".zip")

		local output = self:expectLuaReturn("Gets only the last part of compound extensions", pPath.getExtension, "fo.o/bar.zip.txt")
		self:isEqual(output, ".txt")

		local output = self:expectLuaReturn("Just a dot", pPath.getExtension, "fo.o/bar.")
		self:isEqual(output, ".")

		local output = self:expectLuaReturn("No extension", pPath.getExtension, "fo.o/bar")
		self:isEqual(output, "")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("pPath.join", function(self)
	-- [====[
	do
		local output = self:expectLuaReturn("Join", pPath.join, "foo", "bar")
		self:isEqual(output, "foo/bar")

		local output = self:expectLuaReturn("Strip leading, middle and trailing separators", pPath.join, "//foo//", "//bar//")
		self:isEqual(output, "foo/bar")

		local output = self:expectLuaReturn("Empty first fragment", pPath.join, "", "bar")
		self:isEqual(output, "bar")

		local output = self:expectLuaReturn("Empty last fragment", pPath.join, "foo", "")
		self:isEqual(output, "foo")

		local output = self:expectLuaReturn("Both fragments empty", pPath.join, "", "")
		self:isEqual(output, "")

		local output = self:expectLuaReturn("First fragment is a separator", pPath.join, "/", "")
		self:isEqual(output, "")

		local output = self:expectLuaReturn("Last fragment is a separator", pPath.join, "", "/")
		self:isEqual(output, "")

		local output = self:expectLuaReturn("Both fragments are separators", pPath.join, "/", "/")
		self:isEqual(output, "")

		local output = self:expectLuaReturn("Separators embedded in fragments", pPath.join, "foo/bar", "baz/plorp")
		self:isEqual(output, "foo/bar/baz/plorp")
	end
	--]====]
end
)
--]===]


self:registerFunction("pPath.splitPathAndExtension()", pPath.splitPathAndExtension)


-- [===[
self:registerJob("pPath.splitPathAndExtension", function(self)
	-- [====[
	do
		local path, ext = self:expectLuaReturn("Split", pPath.splitPathAndExtension, "foo/bar.zip")
		self:isEqual(path, "foo/bar")
		self:isEqual(ext, ".zip")

		local path, ext = self:expectLuaReturn("No extension", pPath.splitPathAndExtension, "foo/bar")
		self:isEqual(path, "foo/bar")
		self:isEqual(ext, "")

		local path, ext = self:expectLuaReturn("Extension only", pPath.splitPathAndExtension, ".foobar")
		self:isEqual(path, "")
		self:isEqual(ext, ".foobar")

	end
	--]====]
end
)
--]===]


self:runJobs()
