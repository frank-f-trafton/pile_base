-- Test: pile_scale.lua
-- v1.315


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")


local pScale = require(PATH .. "pile_scale")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Scale", cli_verbosity)


-- [===[
self:registerFunction("pScale.number()", pScale.number)
self:registerJob("pScale.number", function(self)
	-- [====[
	do
		local rv

		rv = self:expectLuaReturn("scale a number", pScale.number, 2, 5)
		self:isEqual(rv, 10)

		rv = self:expectLuaReturn("scale a number (enforce minimum)", pScale.number, 2, 5, 80)
		self:isEqual(rv, 80)

		rv = self:expectLuaReturn("scale a number (enforce maximum)", pScale.number, 2, 5, nil, 3)
		self:isEqual(rv, 3)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("pScale.number() arg 1 bad type", pScale.number, function() end, 2, 0, 100)
		self:expectLuaError("pScale.number() arg 2 bad type", pScale.number, 5, {}, 0, 100)
		self:expectLuaError("pScale.number() arg 3 bad type", pScale.number, 5, 2, true, 100)
		self:expectLuaError("pScale.number() arg 4 bad type", pScale.number, 5, 2, 0, 0/0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pScale.integer()", pScale.integer)
self:registerJob("pScale.integer", function(self)
	-- [====[
	do
		local rv

		rv = self:expectLuaReturn("scale a number", pScale.integer, 2.1, 5)
		self:isEqual(rv, 10)

		rv = self:expectLuaReturn("scale a number (enforce minimum)", pScale.integer, 2.1, 5, 80)
		self:isEqual(rv, 80)

		rv = self:expectLuaReturn("scale a number (enforce maximum)", pScale.integer, 2.1, 5, nil, 3)
		self:isEqual(rv, 3)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("pScale.integer() arg 1 bad type", pScale.integer, function() end, 2, 0, 100)
		self:expectLuaError("pScale.integer() arg 2 bad type", pScale.integer, 5, {}, 0, 100)
		self:expectLuaError("pScale.integer() arg 3 bad type", pScale.integer, 5, 2, true, 100)
		self:expectLuaError("pScale.integer() arg 4 bad type", pScale.integer, 5, 2, 0, 0/0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pScale.fieldNumber()", pScale.fieldNumber)
self:registerJob("pScale.fieldNumber", function(self)
	-- [====[
	do
		local t = {}

		t.k = 5
		self:expectLuaReturn("scale a number in a table", pScale.fieldNumber, 2, t, "k")
		self:isEqual(t.k, 10)

		t.k = 5
		self:expectLuaReturn("scale a number in a table (enforce minimum)", pScale.fieldNumber, 2, t, "k", 80)
		self:isEqual(t.k, 80)

		t.k = 5
		self:expectLuaReturn("scale a number in a table (enforce maximum)", pScale.fieldNumber, 2, t, "k", nil, 3)
		self:isEqual(t.k, 3)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("pScale.fieldNumber() arg 1 bad type", pScale.fieldNumber, function() end, {k=1}, "k", 0, 100)
		self:expectLuaError("pScale.fieldNumber() arg 2 bad type", pScale.fieldNumber, 5, true, "k", 0, 100)
		-- don't test arg 3
		self:expectLuaError("pScale.fieldNumber() arg 4 bad type", pScale.fieldNumber, 5, {k=1}, "k", true, 100)
		self:expectLuaError("pScale.fieldNumber() arg 5 bad type", pScale.fieldNumber, 5, {k=1}, "k", 0, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pScale.fieldInteger()", pScale.fieldInteger)
self:registerJob("pScale.fieldInteger", function(self)
	-- [====[
	do
		local t = {}

		t.k = 5
		self:expectLuaReturn("scale a number in a table", pScale.fieldInteger, 2.1, t, "k")
		self:isEqual(t.k, 10)

		t.k = 5
		self:expectLuaReturn("scale a number in a table (enforce minimum)", pScale.fieldInteger, 2.1, t, "k", 80)
		self:isEqual(t.k, 80)

		t.k = 5
		self:expectLuaReturn("scale a number in a table (enforce maximum)", pScale.fieldInteger, 2.1, t, "k", nil, 3)
		self:isEqual(t.k, 3)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("pScale.fieldInteger() arg 1 bad type", pScale.fieldInteger, function() end, {k=1}, "k", 0, 100)
		self:expectLuaError("pScale.fieldInteger() arg 2 bad type", pScale.fieldInteger, 5, true, "k", 0, 100)
		-- don't test arg 3
		self:expectLuaError("pScale.fieldInteger() arg 4 bad type", pScale.fieldInteger, 5, {k=1}, "k", true, 100)
		self:expectLuaError("pScale.fieldInteger() arg 5 bad type", pScale.fieldInteger, 5, {k=1}, "k", 0, true)
	end
	--]====]
end
)
--]===]


self:runJobs()
