-- Test: pile_assert.lua
-- VERSION: 2.012


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pAssert = require(PATH .. "pile_assert")
local pTable = require(PATH .. "pile_table") -- for pTable.newNamedMap()


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pAssert", cli_verbosity)


local function _funcLabelTest()
	return "Uh-oh"
end


--[[
pAssert's functions do minimal (if any) checking of their own arguments.
--]]


-- [===[
self:registerFunction("pAssert.type()", pAssert.type)
self:registerJob("pAssert.type()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", pAssert.type, 1, 100, "number")
		self:expectLuaError("Will always fail when no option is provided", pAssert.type, 1, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.type, nil, true, "number")
		self:expectLuaError("argument 1: error", pAssert.type, 1, true, "number")
		self:expectLuaError("argument 100: error", pAssert.type, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pAssert.type, "foo", true, "number")
		self:expectLuaError("table-key: error", pAssert.type, {"t1", "x"}, true, "number")
		self:expectLuaError("function: error", pAssert.type, _funcLabelTest, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.typeEval()", pAssert.typeEval)
self:registerJob("pAssert.typeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", pAssert.typeEval, 1, 100, "number")
		self:expectLuaReturn("false is ignored", pAssert.typeEval, 1, false, "string")
		self:expectLuaReturn("nil is ignored", pAssert.typeEval, 1, nil, "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", pAssert.typeEval, 1, false)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.typeEval, nil, true, "number")
		self:expectLuaError("argument 1: error", pAssert.typeEval, 1, true, "number")
		self:expectLuaError("argument 100: error", pAssert.typeEval, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pAssert.typeEval, "foo", true, "number")
		self:expectLuaError("table-key: error", pAssert.typeEval, {"t1", "x"}, true, "number")
		self:expectLuaError("function: error", pAssert.typeEval, _funcLabelTest, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.types()", pAssert.types)
self:registerJob("pAssert.types()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", pAssert.types, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", pAssert.types, 1, true, "number", "boolean", "string")
		self:expectLuaError("will always fail when no options are provided", pAssert.types, 1, true)
		self:expectLuaError("bad type, multiple options", pAssert.types, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.types, nil, true, "number")
		self:expectLuaError("argument 1: error", pAssert.types, 1, true, "number")
		self:expectLuaError("argument 100: error", pAssert.types, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pAssert.types, "foo", true, "number")
		self:expectLuaError("table-key: error", pAssert.types, {"t1", "x"}, true, "number")
		self:expectLuaError("function: error", pAssert.types, _funcLabelTest, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.typesEval()", pAssert.typesEval)
self:registerJob("pAssert.typesEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", pAssert.typesEval, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", pAssert.typesEval, 1, true, "number", "boolean", "string")
		self:expectLuaReturn("false is ignored", pAssert.typesEval, 1, false, "number", "string")
		self:expectLuaReturn("nil is ignored", pAssert.typesEval, 1, nil, "number", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", pAssert.typesEval, 1, false)
		self:expectLuaError("bad type, multiple options", pAssert.typesEval, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.typesEval, nil, true, "number")
		self:expectLuaError("argument 1: error", pAssert.typesEval, 1, true, "number")
		self:expectLuaError("argument 100: error", pAssert.typesEval, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pAssert.typesEval, "foo", true, "number")
		self:expectLuaError("table-key: error", pAssert.typesEval, {"t1", "x"}, true, "number")
		self:expectLuaError("function: error", pAssert.typesEval, _funcLabelTest, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.oneOf()", pAssert.oneOf)
self:registerJob("pAssert.oneOf()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.oneOf, 1, "foo", "GoodList", "fwoop", "foop", "foo")
		self:expectLuaError("not in vararg list", pAssert.oneOf, 1, "bar", "BadList", "fwoop", "foop", "foo")
		self:expectLuaReturn("accept false, if in list", pAssert.oneOf, 1, false, "FalseList", true, false, nil, "yeah")
		self:expectLuaReturn("accept nil, if in list", pAssert.oneOf, 1, nil, "NilList", true, false, nil, "yeah")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.oneOf, nil, true, "TestList", false)
		self:expectLuaError("argument 1: error", pAssert.oneOf, 1, true, "TestList", false)
		self:expectLuaError("argument 100: error", pAssert.oneOf, 100, true, "TestList", false)
		self:expectLuaError("arbitrary string: error", pAssert.oneOf, "foo", true, "TestList", false)
		self:expectLuaError("table-key: error", pAssert.oneOf, {"t1", "x"}, true, "TestList", false)
		self:expectLuaError("function: error", pAssert.oneOf, _funcLabelTest, true, "TestList", false)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.oneOfEval()", pAssert.oneOfEval)
self:registerJob("pAssert.oneOfEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.oneOfEval, 1, "foo", "GoodList", "fwoop", "foop", "foo")
		self:expectLuaError("not in vararg list", pAssert.oneOfEval, 1, "bar", "BadList", "fwoop", "foop", "foo")
		self:expectLuaReturn("always accept false", pAssert.oneOfEval, 1, false, "FalseList", true, 1, "yeah")
		self:expectLuaReturn("always accept nil", pAssert.oneOfEval, 1, nil, "NilList", true, 1, "yeah")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.oneOfEval, nil, true, "TestList", 0)
		self:expectLuaError("argument 1: error", pAssert.oneOfEval, 1, true, "TestList", 0)
		self:expectLuaError("argument 100: error", pAssert.oneOfEval, 100, true, "TestList", 0)
		self:expectLuaError("arbitrary string: error", pAssert.oneOfEval, "foo", true, "TestList", 0)
		self:expectLuaError("table-key: error", pAssert.oneOfEval, {"t1", "x"}, true, "TestList", 0)
		self:expectLuaError("function: error", pAssert.oneOfEval, _funcLabelTest, true, "TestList", 0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.numberNotNaN()", pAssert.numberNotNaN)
self:registerJob("pAssert.numberNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberNotNaN, 1, 5)
		self:expectLuaError("wrong type", pAssert.numberNotNaN, 1, true)
		self:expectLuaError("reject NaN", pAssert.numberNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberNotNaN, nil, true)
		self:expectLuaError("argument 1: error", pAssert.numberNotNaN, 1, true)
		self:expectLuaError("argument 100: error", pAssert.numberNotNaN, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.numberNotNaN, "foo", true)
		self:expectLuaError("table-key: error", pAssert.numberNotNaN, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.numberNotNaN, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.numberNotNaNEval()", pAssert.numberNotNaNEval)
self:registerJob("pAssert.numberNotNaNEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberNotNaNEval, 1, 5)
		self:expectLuaError("wrong type", pAssert.numberNotNaNEval, 1, true)
		self:expectLuaError("reject NaN", pAssert.numberNotNaNEval, 1, 0/0)
		self:expectLuaReturn("accept false", pAssert.numberNotNaNEval, 1, false)
		self:expectLuaReturn("accept nil", pAssert.numberNotNaNEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberNotNaNEval, nil, true)
		self:expectLuaError("argument 1: error", pAssert.numberNotNaNEval, 1, true)
		self:expectLuaError("argument 100: error", pAssert.numberNotNaNEval, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.numberNotNaNEval, "foo", true)
		self:expectLuaError("table-key: error", pAssert.numberNotNaNEval, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.numberNotNaNEval, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.numberGE()", pAssert.numberGE)
self:registerJob("pAssert.numberGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberGE, 1, 100, 50)
		self:expectLuaError("bad type", pAssert.numberGE, 1, false, 50)
		self:expectLuaError("under the minimum", pAssert.numberGE, 1, 5, 80)
		self:expectLuaError("NaN", pAssert.numberGE, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberGE, nil, 50, 100)
		self:expectLuaError("argument 1: error", pAssert.numberGE, 1, 50, 100)
		self:expectLuaError("argument 100: error", pAssert.numberGE, 100, 50, 100)
		self:expectLuaError("arbitrary string: error", pAssert.numberGE, "foo", 50, 100)
		self:expectLuaError("table-key: error", pAssert.numberGE, {"t1", "x"}, 50, 100)
		self:expectLuaError("function: error", pAssert.numberGE, _funcLabelTest, 50, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.numberGEEval()", pAssert.numberGEEval)
self:registerJob("pAssert.numberGEEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberGEEval, 1, 100, 50)
		self:expectLuaReturn("expected behavior (eval false)", pAssert.numberGEEval, 1, false, 50)
		self:expectLuaError("bad type", pAssert.numberGEEval, 1, true, 50)
		self:expectLuaError("under the minimum", pAssert.numberGEEval, 1, 5, 80)
		self:expectLuaError("NaN", pAssert.numberGEEval, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberGEEval, nil, 5, 80)
		self:expectLuaError("argument 1: error", pAssert.numberGEEval, 1, 5, 80)
		self:expectLuaError("argument 100: error", pAssert.numberGEEval, 100, 5, 80)
		self:expectLuaError("arbitrary string: error", pAssert.numberGEEval, "foo", 5, 80)
		self:expectLuaError("table-key: error", pAssert.numberGEEval, {"t1", "x"}, 5, 80)
		self:expectLuaError("function: error", pAssert.numberGEEval, _funcLabelTest, 5, 80)
	end
	--]====]
end
)
--]===]

-- [===[
self:registerFunction("pAssert.numberRange()", pAssert.numberRange)
self:registerJob("pAssert.numberRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberRange, 1, 100, 0, 100)
		self:expectLuaError("bad type", pAssert.numberRange, 1, false, 50, 55)
		self:expectLuaError("less than the minimum", pAssert.numberRange, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pAssert.numberRange, 1, 100, 80, 90)
		self:expectLuaError("NaN", pAssert.numberRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberRange, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pAssert.numberRange, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pAssert.numberRange, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pAssert.numberRange, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pAssert.numberRange, {"t1", "x"}, 5, 80, 90)
		self:expectLuaError("function: error", pAssert.numberRange, _funcLabelTest, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.numberRangeEval()", pAssert.numberRangeEval)
self:registerJob("pAssert.numberRangeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.numberRangeEval, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", pAssert.numberRangeEval, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", pAssert.numberRangeEval, 1, nil, 0, 100)
		self:expectLuaError("bad type", pAssert.numberRangeEval, 1, {}, 50, 55)
		self:expectLuaError("less than the minimum", pAssert.numberRangeEval, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pAssert.numberRangeEval, 1, 100, 80, 90)
		self:expectLuaError("NaN", pAssert.numberRangeEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.numberRangeEval, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pAssert.numberRangeEval, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pAssert.numberRangeEval, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pAssert.numberRangeEval, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pAssert.numberRangeEval, {"t1", "x"}, 5, 80, 90)
		self:expectLuaError("function: error", pAssert.numberRangeEval, _funcLabelTest, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.integer()", pAssert.integer)
self:registerJob("pAssert.integer()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integer, 1, 100)
		self:expectLuaError("bad type", pAssert.integer, 1, false)
		self:expectLuaError("not an integer", pAssert.integer, 1, 5.5)
		self:expectLuaError("NaN", pAssert.integer, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integer, nil, true)
		self:expectLuaError("argument 1: error", pAssert.integer, 1, true)
		self:expectLuaError("argument 100: error", pAssert.integer, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.integer, "foo", true)
		self:expectLuaError("table-key: error", pAssert.integer, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.integer, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.integerEval()", pAssert.integerEval)
self:registerJob("pAssert.integerEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integerEval, 1, 100)
		self:expectLuaError("bad type", pAssert.integerEval, 1, true)
		self:expectLuaError("not an integer", pAssert.integerEval, 1, 5.5)
		self:expectLuaError("NaN", pAssert.integerEval, 1, 0/0)
		self:expectLuaReturn("accept false", pAssert.integerEval, 1, false)
		self:expectLuaReturn("accept nil", pAssert.integerEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integerEval, nil, true)
		self:expectLuaError("argument 1: error", pAssert.integerEval, 1, true)
		self:expectLuaError("argument 100: error", pAssert.integerEval, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.integerEval, "foo", true)
		self:expectLuaError("table-key: error", pAssert.integerEval, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.integerEval, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.integerGE()", pAssert.integerGE)
self:registerJob("pAssert.integerGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integerGE, 1, 100, 50)
		self:expectLuaError("bad type", pAssert.integerGE, 1, false, 50)
		self:expectLuaError("not an integer", pAssert.integerGE, 1, 5.5, 1)
		self:expectLuaError("under the minimum", pAssert.integerGE, 1, 5, 80)
		self:expectLuaError("NaN", pAssert.integerGE, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integerGE, nil, 50, 100)
		self:expectLuaError("argument 1: error", pAssert.integerGE, 1, 50, 100)
		self:expectLuaError("argument 100: error", pAssert.integerGE, 100, 50, 100)
		self:expectLuaError("arbitrary string: error", pAssert.integerGE, "foo", 50, 100)
		self:expectLuaError("table-key: error", pAssert.integerGE, {"t1", "x"}, 50, 100)
		self:expectLuaError("function: error", pAssert.integerGE, _funcLabelTest, 50, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.integerGEEval()", pAssert.integerGEEval)
self:registerJob("pAssert.integerGEEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integerGEEval, 1, 100, 50)
		self:expectLuaReturn("expected behavior (eval false)", pAssert.integerGEEval, 1, false, 50)
		self:expectLuaError("bad type", pAssert.integerGEEval, 1, true, 50)
		self:expectLuaError("not an integer", pAssert.integerGEEval, 1, 5.5, 1)
		self:expectLuaError("under the minimum", pAssert.integerGEEval, 1, 5, 80)
		self:expectLuaError("NaN", pAssert.integerGEEval, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integerGEEval, nil, 5, 80)
		self:expectLuaError("argument 1: error", pAssert.integerGEEval, 1, 5, 80)
		self:expectLuaError("argument 100: error", pAssert.integerGEEval, 100, 5, 80)
		self:expectLuaError("arbitrary string: error", pAssert.integerGEEval, "foo", 5, 80)
		self:expectLuaError("table-key: error", pAssert.integerGEEval, {"t1", "x"}, 5, 80)
		self:expectLuaError("function: error", pAssert.integerGEEval, _funcLabelTest, 5, 80)
	end
	--]====]
end
)
--]===]

-- [===[
self:registerFunction("pAssert.integerRange()", pAssert.integerRange)
self:registerJob("pAssert.integerRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integerRange, 1, 100, 0, 100)
		self:expectLuaError("bad type", pAssert.integerRange, 1, false, 50, 55)
		self:expectLuaError("not an integer", pAssert.integerRange, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", pAssert.integerRange, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pAssert.integerRange, 1, 100, 80, 90)
		self:expectLuaError("NaN", pAssert.integerRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integerRange, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pAssert.integerRange, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pAssert.integerRange, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pAssert.integerRange, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pAssert.integerRange, {"t1", "x"}, 5, 80, 90)
		self:expectLuaError("function: error", pAssert.integerRange, _funcLabelTest, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.integerRangeEval()", pAssert.integerRangeEval)
self:registerJob("pAssert.integerRangeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.integerRangeEval, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", pAssert.integerRangeEval, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", pAssert.integerRangeEval, 1, nil, 0, 100)
		self:expectLuaError("bad type", pAssert.integerRangeEval, 1, {}, 50, 55)
		self:expectLuaError("not an integer", pAssert.integerRangeEval, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", pAssert.integerRangeEval, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pAssert.integerRangeEval, 1, 100, 80, 90)
		self:expectLuaError("NaN", pAssert.integerRangeEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.integerRangeEval, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pAssert.integerRangeEval, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pAssert.integerRangeEval, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pAssert.integerRangeEval, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pAssert.integerRangeEval, {"t1", "x"}, 5, 80, 90)
		self:expectLuaError("function: error", pAssert.integerRangeEval, _funcLabelTest, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.namedMap()", pAssert.namedMap)
self:registerJob("pAssert.namedMap()", function(self)
	-- [====[
	do
		local n_map = pTable.newNamedMap("FooMap", {foo=true})
		self:expectLuaReturn("expected behavior", pAssert.namedMap, 1, "foo", n_map)
		self:expectLuaError("not in NamedMap", pAssert.namedMap, 1, "bar", n_map)
	end
	--]====]


	-- [====[
	do
		local n_map = pTable.newNamedMap("FooMap", {foo=true})
		self:expectLuaError("no argument: error", pAssert.namedMap, nil, true, n_map)
		self:expectLuaError("argument 1: error", pAssert.namedMap, 1, true, n_map)
		self:expectLuaError("argument 100: error", pAssert.namedMap, 100, true, n_map)
		self:expectLuaError("arbitrary string: error", pAssert.namedMap, "foo", true, n_map)
		self:expectLuaError("table-key: error", pAssert.namedMap, {"t1", "x"}, true, n_map)
		self:expectLuaError("function: error", pAssert.namedMap, _funcLabelTest, true, n_map)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.namedMapEval()", pAssert.namedMapEval)
self:registerJob("pAssert.namedMapEval()", function(self)
	-- [====[
	do
		local n_map = pTable.newNamedMap("FooMap", {foo=true})
		self:expectLuaReturn("expected behavior", pAssert.namedMapEval, 1, "foo", n_map)
		self:expectLuaError("not in NamedMap", pAssert.namedMapEval, 1, "bar", n_map)
		self:expectLuaReturn("accept false", pAssert.namedMapEval, 1, false, n_map)
		self:expectLuaReturn("accept nil", pAssert.namedMapEval, 1, nil, n_map)
	end
	--]====]


	-- [====[
	do
		local n_map = pTable.newNamedMap("FooMap", {foo=true})
		self:expectLuaError("no argument: error", pAssert.namedMapEval, nil, true, n_map)
		self:expectLuaError("argument 1: error", pAssert.namedMapEval, 1, true, n_map)
		self:expectLuaError("argument 100: error", pAssert.namedMapEval, 100, true, n_map)
		self:expectLuaError("arbitrary string: error", pAssert.namedMapEval, "foo", true, n_map)
		self:expectLuaError("table-key: error", pAssert.namedMapEval, {"t1", "x"}, true, n_map)
		self:expectLuaError("function: error", pAssert.namedMapEval, _funcLabelTest, true, n_map)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.notNil()", pAssert.notNil)
self:registerJob("pAssert.notNil()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.notNil, 1, "foo")
		self:expectLuaReturn("accept false", pAssert.notNil, 1, false)
		self:expectLuaReturn("accept NaN", pAssert.notNil, 1, 0/0)
		self:expectLuaError("reject nil", pAssert.notNil, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.notNil, nil, nil)
		self:expectLuaError("argument 1: error", pAssert.notNil, 1, nil)
		self:expectLuaError("argument 100: error", pAssert.notNil, 100, nil)
		self:expectLuaError("arbitrary string: error", pAssert.notNil, "foo", nil)
		self:expectLuaError("table-key: error", pAssert.notNil, {"t1", "x"}, nil)
		self:expectLuaError("function: error", pAssert.notNil, _funcLabelTest, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.notNilNotNaN()", pAssert.notNilNotNaN)
self:registerJob("pAssert.notNilNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.notNilNotNaN, 1, "foo")
		self:expectLuaError("reject nil", pAssert.notNilNotNaN, 1, nil)
		self:expectLuaReturn("accept false", pAssert.notNilNotNaN, 1, false)
		self:expectLuaError("reject NaN", pAssert.notNilNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.notNilNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", pAssert.notNilNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", pAssert.notNilNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", pAssert.notNilNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", pAssert.notNilNotNaN, {"t1", "x"}, nil)
		self:expectLuaError("function: error", pAssert.notNilNotNaN, _funcLabelTest, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.notNilNotFalse()", pAssert.notNilNotFalse)
self:registerJob("pAssert.notNilNotFalse()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.notNilNotFalse, 1, "foo")
		self:expectLuaError("reject nil", pAssert.notNilNotFalse, 1, nil)
		self:expectLuaError("reject false", pAssert.notNilNotFalse, 1, false)
		self:expectLuaReturn("accept NaN", pAssert.notNilNotFalse, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.notNilNotFalse, nil, nil)
		self:expectLuaError("argument 1: error", pAssert.notNilNotFalse, 1, nil)
		self:expectLuaError("argument 100: error", pAssert.notNilNotFalse, 100, nil)
		self:expectLuaError("arbitrary string: error", pAssert.notNilNotFalse, "foo", nil)
		self:expectLuaError("table-key: error", pAssert.notNilNotFalse, {"t1", "x"}, nil)
		self:expectLuaError("function: error", pAssert.notNilNotFalse, _funcLabelTest, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.notNilNotFalseNotNaN()", pAssert.notNilNotFalseNotNaN)
self:registerJob("pAssert.notNilNotFalseNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.notNilNotFalseNotNaN, 1, "foo")
		self:expectLuaError("reject nil", pAssert.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("reject false", pAssert.notNilNotFalseNotNaN, 1, false)
		self:expectLuaError("reject NaN", pAssert.notNilNotFalseNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.notNilNotFalseNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", pAssert.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", pAssert.notNilNotFalseNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", pAssert.notNilNotFalseNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", pAssert.notNilNotFalseNotNaN, {"t1", "x"}, nil)
		self:expectLuaError("function: error", pAssert.notNilNotFalseNotNaN, _funcLabelTest, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.notNaN()", pAssert.notNaN)
self:registerJob("pAssert.notNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.notNaN, 1, "foo")
		self:expectLuaReturn("accept nil", pAssert.notNaN, 1, nil)
		self:expectLuaReturn("accept false", pAssert.notNaN, 1, false)
		self:expectLuaError("reject NaN", pAssert.notNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.notNaN, nil, 0/0)
		self:expectLuaError("argument 1: error", pAssert.notNaN, 1, 0/0)
		self:expectLuaError("argument 100: error", pAssert.notNaN, 100, 0/0)
		self:expectLuaError("arbitrary string: error", pAssert.notNaN, "foo", 0/0)
		self:expectLuaError("table-key: error", pAssert.notNaN, {"t1", "x"}, 0/0)
		self:expectLuaError("function: error", pAssert.notNaN, _funcLabelTest, 0/0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.tableWithMetatable()", pAssert.tableWithMetatable)
self:registerJob("pAssert.tableWithMetatable()", function(self)
	-- [====[
	do
		local mt, mt2 = {}, {}
		local t = setmetatable({}, mt)
		self:expectLuaReturn("expected behavior", pAssert.tableWithMetatable, 1, setmetatable({}, mt), mt)
		self:expectLuaError("missing metatable", pAssert.tableWithMetatable, 1, {}, mt)
		self:expectLuaError("wrong metatable", pAssert.tableWithMetatable, 1, setmetatable(t, mt2), mt)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.tableWithMetatable, nil, true)
		self:expectLuaError("argument 1: error", pAssert.tableWithMetatable, 1, true)
		self:expectLuaError("argument 100: error", pAssert.tableWithMetatable, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.tableWithMetatable, "foo", true)
		self:expectLuaError("table-key: error", pAssert.tableWithMetatable, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.tableWithMetatable, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.tableWithMetatableEval()", pAssert.tableWithMetatableEval)
self:registerJob("pAssert.tableWithMetatableEval()", function(self)
	-- [====[
	do
		local mt, mt2 = {}, {}
		local t = setmetatable({}, mt)
		self:expectLuaReturn("expected behavior", pAssert.tableWithMetatableEval, 1, setmetatable({}, mt), mt)
		self:expectLuaReturn("accept false", pAssert.tableWithMetatableEval, 1, false, mt)
		self:expectLuaError("missing metatable", pAssert.tableWithMetatableEval, 1, {}, mt)
		self:expectLuaError("wrong metatable", pAssert.tableWithMetatableEval, 1, setmetatable(t, mt2), mt)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.tableWithMetatableEval, nil, true)
		self:expectLuaError("argument 1: error", pAssert.tableWithMetatableEval, 1, true)
		self:expectLuaError("argument 100: error", pAssert.tableWithMetatableEval, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.tableWithMetatableEval, "foo", true)
		self:expectLuaError("table-key: error", pAssert.tableWithMetatableEval, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.tableWithMetatableEval, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.tableWithoutMetatable()", pAssert.tableWithoutMetatable)
self:registerJob("pAssert.tableWithoutMetatable()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.tableWithoutMetatable, 1, {})
		self:expectLuaError("has a metatable", pAssert.tableWithoutMetatable, 1, setmetatable({}, {}))
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.tableWithoutMetatable, nil, true)
		self:expectLuaError("argument 1: error", pAssert.tableWithoutMetatable, 1, true)
		self:expectLuaError("argument 100: error", pAssert.tableWithoutMetatable, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.tableWithoutMetatable, "foo", true)
		self:expectLuaError("table-key: error", pAssert.tableWithoutMetatable, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.tableWithoutMetatable, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.tableWithoutMetatableEval()", pAssert.tableWithoutMetatableEval)
self:registerJob("pAssert.tableWithoutMetatableEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pAssert.tableWithoutMetatableEval, 1, {})
		self:expectLuaReturn("accept false", pAssert.tableWithoutMetatableEval, 1, false)
		self:expectLuaError("has a metatable", pAssert.tableWithoutMetatableEval, 1, setmetatable({}, {}))
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.tableWithoutMetatableEval, nil, true)
		self:expectLuaError("argument 1: error", pAssert.tableWithoutMetatableEval, 1, true)
		self:expectLuaError("argument 100: error", pAssert.tableWithoutMetatableEval, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.tableWithoutMetatableEval, "foo", true)
		self:expectLuaError("table-key: error", pAssert.tableWithoutMetatableEval, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.tableWithoutMetatableEval, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.fail()", pAssert.fail)
self:registerJob("pAssert.fail()", function(self)
	-- [====[
	do
		self:expectLuaError("always fails", pAssert.fail, 1, nil, "Uh oh")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.fail, nil, true)
		self:expectLuaError("argument 1: error", pAssert.fail, 1, true)
		self:expectLuaError("argument 100: error", pAssert.fail, 100, true)
		self:expectLuaError("arbitrary string: error", pAssert.fail, "foo", true)
		self:expectLuaError("table-key: error", pAssert.fail, {"t1", "x"}, true)
		self:expectLuaError("function: error", pAssert.fail, _funcLabelTest, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pAssert.pass()", pAssert.pass)
self:registerJob("pAssert.pass()", function(self)
	-- [====[
	do
		self:expectLuaReturn("always passes", pAssert.pass, 1, "all", "arguments", "are", "ignored")
	end
	--]====]

	-- Can't test name tags in this function, as they never come into play.
end
)
--]===]


-- [===[
self:registerFunction("pAssert.assert()", pAssert.assert)
self:registerJob("pAssert.assert()", function(self)
	-- [====[
	do
		self:expectLuaReturn("success", pAssert.assert, 1, type("foo") == "string", "Uh oh!")
		self:expectLuaError("failure", pAssert.assert, 1, type("foo") == "boolean", "Uh oh!")
	end
	--]====]

	-- [====[
	do
		self:expectLuaError("no argument: error", pAssert.assert, nil, false)
		self:expectLuaError("argument 1: error", pAssert.assert, 1, false)
		self:expectLuaError("argument 100: error", pAssert.assert, 100, false)
		self:expectLuaError("arbitrary string: error", pAssert.assert, "foo", false)
		self:expectLuaError("table-key: error", pAssert.assert, {"t1", "x"}, false)
		self:expectLuaError("function: error", pAssert.assert, _funcLabelTest, false)
	end
	--]====]
end
)
--]===]


self:runJobs()
