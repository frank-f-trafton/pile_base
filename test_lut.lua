-- Test: pile_lut.lua


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local lut = require(PATH .. "pile_lut")


local hex = string.char


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("lut", cli_verbosity)


self:registerFunction("lut.make()", lut.make)


-- [===[
self:registerJob("lut.make()", function(self)
	self:expectLuaError("arg #1 bad type", lut.make, 123)

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", lut.make, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", lut.make, {1, 2, "a", "Z"})
		self:isEqual(output[1], true)
		self:isEqual(output[2], true)
		self:isEqual(output.a, true)
		self:isEqual(output.Z, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("lut.invert()", lut.invert)


-- [===[
self:registerJob("lut.invert()", function(self)
	self:expectLuaError("arg #1 bad type", lut.invert, 123)
	self:expectLuaError("duplicate values", lut.invert, {a=1, b=1})

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", lut.invert, {})
		self:isEqual(next(output), nil)
	end
	--]====]

	-- [====[
	do
		local output = self:expectLuaReturn("make inverted lookup table", lut.invert, {a=1, b=2, c=3})
		self:isEqual(output[1], "a")
		self:isEqual(output[2], "b")
		self:isEqual(output[3], "c")
	end
	--]====]
end
)
--]===]


self:runJobs()
