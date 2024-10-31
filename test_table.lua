-- Test: pile_table.lua
-- v1.1.3


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pTable = require(PATH .. "pile_table")


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


local self = errTest.new("pTable", cli_verbosity)


self:registerFunction("pTable.makeLUT()", pTable.makeLUT)


-- [===[
self:registerJob("pTable.makeLUT()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.makeLUT, 123)

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.makeLUT, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", pTable.makeLUT, {1, 2, "a", "Z"})
		self:isEqual(output[1], true)
		self:isEqual(output[2], true)
		self:isEqual(output.a, true)
		self:isEqual(output.Z, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.invertLUT()", pTable.invertLUT)


-- [===[
self:registerJob("pTable.invertLUT()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.invertLUT, 123)
	self:expectLuaError("duplicate values", pTable.invertLUT, {a=1, b=1})

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.invertLUT, {})
		self:isEqual(next(output), nil)
	end
	--]====]

	-- [====[
	do
		local output = self:expectLuaReturn("make inverted lookup table", pTable.invertLUT, {a=1, b=2, c=3})
		self:isEqual(output[1], "a")
		self:isEqual(output[2], "b")
		self:isEqual(output[3], "c")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("pTable.isArrayOnly()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.isArrayOnly, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table", pTable.isArrayOnly, {})
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array", pTable.isArrayOnly, {"foo", "bar", "baz"})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not just an array (non-numeric indices)", pTable.isArrayOnly, {"foo", "bar", "baz", a=1})
		self:isEvalFalse(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not just an array (index 0 is populated)", pTable.isArrayOnly, {[0]=0, 1, 2, 3})
		self:isEvalFalse(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not an array (sparse)", pTable.isArrayOnly, {1, 2, nil, 4, 5})
		self:isEvalFalse(ret)
	end
	--]====]
end
)


-- [===[
self:registerJob("pTable.isArray()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.isArray, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table", pTable.isArray, {})
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array", pTable.isArray, {"foo", "bar", "baz"})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array (plus non-numeric indices)", pTable.isArray, {"foo", "bar", "baz", a=1})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array (plus index 0 is populated)", pTable.isArray, {[0]=0, 1, 2, 3})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not an array (sparse)", pTable.isArray, {1, 2, nil, 4, 5})
		self:isEvalFalse(ret)
	end
	--]====]
end
)


self:runJobs()
