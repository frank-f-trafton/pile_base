-- Test: pile_arg_check.lua
-- v1.300


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pArg = require(PATH .. "pile_arg_check")
local pTable = require(PATH .. "pile_table") -- for pTable.newEnum()


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pArg", cli_verbosity)


--[[
pArg's functions do minimal (if any) checking of their own arguments.
--]]


-- [===[
self:registerFunction("pArg.type()", pArg.type)
self:registerJob("pArg.type()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", pArg.type, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", pArg.type, 1, true, "number", "boolean", "string")
		self:expectLuaError("will always fail when no options are provided", pArg.type, 1, true)
		self:expectLuaError("bad type, multiple options", pArg.type, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.type, nil, true, "number")
		self:expectLuaError("argument 1: error", pArg.type, 1, true, "number")
		self:expectLuaError("argument 100: error", pArg.type, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pArg.type, "foo", true, "number")
		self:expectLuaError("table-key: error", pArg.type, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.typeEval()", pArg.typeEval)
self:registerJob("pArg.typeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", pArg.typeEval, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", pArg.typeEval, 1, true, "number", "boolean", "string")
		self:expectLuaReturn("false is ignored", pArg.typeEval, 1, false, "number", "string")
		self:expectLuaReturn("nil is ignored", pArg.typeEval, 1, nil, "number", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", pArg.typeEval, 1, false)
		self:expectLuaError("bad type, multiple options", pArg.typeEval, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.typeEval, nil, true, "number")
		self:expectLuaError("argument 1: error", pArg.typeEval, 1, true, "number")
		self:expectLuaError("argument 100: error", pArg.typeEval, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pArg.typeEval, "foo", true, "number")
		self:expectLuaError("table-key: error", pArg.typeEval, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.type1()", pArg.type1)
self:registerJob("pArg.type1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", pArg.type1, 1, 100, "number")
		self:expectLuaError("Will always fail when no option is provided", pArg.type1, 1, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.type1, nil, true, "number")
		self:expectLuaError("argument 1: error", pArg.type1, 1, true, "number")
		self:expectLuaError("argument 100: error", pArg.type1, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pArg.type1, "foo", true, "number")
		self:expectLuaError("table-key: error", pArg.type1, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.typeEval1()", pArg.typeEval1)
self:registerJob("pArg.typeEval1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", pArg.typeEval1, 1, 100, "number")
		self:expectLuaReturn("false is ignored", pArg.typeEval1, 1, false, "string")
		self:expectLuaReturn("nil is ignored", pArg.typeEval1, 1, nil, "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", pArg.typeEval1, 1, false)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.typeEval1, nil, true, "number")
		self:expectLuaError("argument 1: error", pArg.typeEval1, 1, true, "number")
		self:expectLuaError("argument 100: error", pArg.typeEval1, 100, true, "number")
		self:expectLuaError("arbitrary string: error", pArg.typeEval1, "foo", true, "number")
		self:expectLuaError("table-key: error", pArg.typeEval1, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.int()", pArg.int)
self:registerJob("pArg.int()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.int, 1, 100)
		self:expectLuaError("bad type", pArg.int, 1, false)
		self:expectLuaError("not an integer", pArg.int, 1, 5.5)
		self:expectLuaError("NaN", pArg.int, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.int, nil, true)
		self:expectLuaError("argument 1: error", pArg.int, 1, true)
		self:expectLuaError("argument 100: error", pArg.int, 100, true)
		self:expectLuaError("arbitrary string: error", pArg.int, "foo", true)
		self:expectLuaError("table-key: error", pArg.int, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.intEval()", pArg.intEval)
self:registerJob("pArg.intEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.intEval, 1, 100)
		self:expectLuaError("bad type", pArg.intEval, 1, true)
		self:expectLuaError("not an integer", pArg.intEval, 1, 5.5)
		self:expectLuaError("NaN", pArg.intEval, 1, 0/0)
		self:expectLuaReturn("accept false", pArg.intEval, 1, false)
		self:expectLuaReturn("accept nil", pArg.intEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.intEval, nil, true)
		self:expectLuaError("argument 1: error", pArg.intEval, 1, true)
		self:expectLuaError("argument 100: error", pArg.intEval, 100, true)
		self:expectLuaError("arbitrary string: error", pArg.intEval, "foo", true)
		self:expectLuaError("table-key: error", pArg.intEval, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.intGE()", pArg.intGE)
self:registerJob("pArg.intGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.intGE, 1, 100, 50)
		self:expectLuaError("bad type", pArg.intGE, 1, false, 50)
		self:expectLuaError("not an integer", pArg.intGE, 1, 5.5, 1)
		self:expectLuaError("under the minimum", pArg.intGE, 1, 5, 80)
		self:expectLuaError("NaN", pArg.intGE, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.intGE, nil, 50, 100)
		self:expectLuaError("argument 1: error", pArg.intGE, 1, 50, 100)
		self:expectLuaError("argument 100: error", pArg.intGE, 100, 50, 100)
		self:expectLuaError("arbitrary string: error", pArg.intGE, "foo", 50, 100)
		self:expectLuaError("table-key: error", pArg.intGE, {"t1", "x"}, 50, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.intGEEval()", pArg.intGEEval)
self:registerJob("pArg.intGEEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.intGEEval, 1, 100, 50)
		self:expectLuaReturn("expected behavior (eval false)", pArg.intGEEval, 1, false, 50)
		self:expectLuaError("bad type", pArg.intGEEval, 1, true, 50)
		self:expectLuaError("not an integer", pArg.intGEEval, 1, 5.5, 1)
		self:expectLuaError("under the minimum", pArg.intGEEval, 1, 5, 80)
		self:expectLuaError("NaN", pArg.intGEEval, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.intGEEval, nil, 5, 80)
		self:expectLuaError("argument 1: error", pArg.intGEEval, 1, 5, 80)
		self:expectLuaError("argument 100: error", pArg.intGEEval, 100, 5, 80)
		self:expectLuaError("arbitrary string: error", pArg.intGEEval, "foo", 5, 80)
		self:expectLuaError("table-key: error", pArg.intGEEval, {"t1", "x"}, 5, 80)
	end
	--]====]
end
)
--]===]

-- [===[
self:registerFunction("pArg.intRange()", pArg.intRange)
self:registerJob("pArg.intRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.intRange, 1, 100, 0, 100)
		self:expectLuaError("bad type", pArg.intRange, 1, false, 50, 55)
		self:expectLuaError("not an integer", pArg.intRange, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", pArg.intRange, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pArg.intRange, 1, 100, 80, 90)
		self:expectLuaError("NaN", pArg.intRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.intRange, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pArg.intRange, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pArg.intRange, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pArg.intRange, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pArg.intRange, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.intRangeEval()", pArg.intRangeEval)
self:registerJob("pArg.intRangeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.intRangeEval, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", pArg.intRangeEval, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", pArg.intRangeEval, 1, nil, 0, 100)
		self:expectLuaError("bad type", pArg.intRangeEval, 1, {}, 50, 55)
		self:expectLuaError("not an integer", pArg.intRangeEval, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", pArg.intRangeEval, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", pArg.intRangeEval, 1, 100, 80, 90)
		self:expectLuaError("NaN", pArg.intRangeEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.intRangeEval, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", pArg.intRangeEval, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", pArg.intRangeEval, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", pArg.intRangeEval, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", pArg.intRangeEval, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.numberNotNaN()", pArg.numberNotNaN)
self:registerJob("pArg.numberNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.numberNotNaN, 1, 5)
		self:expectLuaError("wrong type", pArg.numberNotNaN, 1, true)
		self:expectLuaError("reject NaN", pArg.numberNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.numberNotNaN, nil, true)
		self:expectLuaError("argument 1: error", pArg.numberNotNaN, 1, true)
		self:expectLuaError("argument 100: error", pArg.numberNotNaN, 100, true)
		self:expectLuaError("arbitrary string: error", pArg.numberNotNaN, "foo", true)
		self:expectLuaError("table-key: error", pArg.numberNotNaN, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.numberNotNaNEval()", pArg.numberNotNaNEval)
self:registerJob("pArg.numberNotNaNEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.numberNotNaNEval, 1, 5)
		self:expectLuaError("wrong type", pArg.numberNotNaNEval, 1, true)
		self:expectLuaError("reject NaN", pArg.numberNotNaNEval, 1, 0/0)
		self:expectLuaReturn("accept false", pArg.numberNotNaNEval, 1, false)
		self:expectLuaReturn("accept nil", pArg.numberNotNaNEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.numberNotNaNEval, nil, true)
		self:expectLuaError("argument 1: error", pArg.numberNotNaNEval, 1, true)
		self:expectLuaError("argument 100: error", pArg.numberNotNaNEval, 100, true)
		self:expectLuaError("arbitrary string: error", pArg.numberNotNaNEval, "foo", true)
		self:expectLuaError("table-key: error", pArg.numberNotNaNEval, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.enum()", pArg.enum)
self:registerJob("pArg.enum()", function(self)
	-- [====[
	do
		local enum = pTable.newEnum("FooEnum", {foo=true})
		self:expectLuaReturn("expected behavior", pArg.enum, 1, "foo", enum)
		self:expectLuaError("not in enum table", pArg.enum, 1, "bar", enum)
	end
	--]====]


	-- [====[
	do
		local enum = pTable.newEnum("FooEnum", {foo=true})
		self:expectLuaError("no argument: error", pArg.enum, nil, true, enum)
		self:expectLuaError("argument 1: error", pArg.enum, 1, true, enum)
		self:expectLuaError("argument 100: error", pArg.enum, 100, true, enum)
		self:expectLuaError("arbitrary string: error", pArg.enum, "foo", true, enum)
		self:expectLuaError("table-key: error", pArg.enum, {"t1", "x"}, true, enum)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.enumEval()", pArg.enumEval)
self:registerJob("pArg.enumEval()", function(self)
	-- [====[
	do
		local enum = pTable.newEnum("FooEnum", {foo=true})
		self:expectLuaReturn("expected behavior", pArg.enumEval, 1, "foo", enum)
		self:expectLuaError("not in enum table", pArg.enumEval, 1, "bar", enum)
		self:expectLuaReturn("accept false", pArg.enumEval, 1, false, enum)
		self:expectLuaReturn("accept nil", pArg.enumEval, 1, nil, enum)
	end
	--]====]


	-- [====[
	do
		local enum = pTable.newEnum("FooEnum", {foo=true})
		self:expectLuaError("no argument: error", pArg.enumEval, nil, true, enum)
		self:expectLuaError("argument 1: error", pArg.enumEval, 1, true, enum)
		self:expectLuaError("argument 100: error", pArg.enumEval, 100, true, enum)
		self:expectLuaError("arbitrary string: error", pArg.enumEval, "foo", true, enum)
		self:expectLuaError("table-key: error", pArg.enumEval, {"t1", "x"}, true, enum)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.oneOf()", pArg.oneOf)
self:registerJob("pArg.oneOf()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.oneOf, 1, "foo", "GoodList", "fwoop", "foop", "foo")
		self:expectLuaError("not in vararg list", pArg.oneOf, 1, "bar", "BadList", "fwoop", "foop", "foo")
		self:expectLuaReturn("accept false, if in list", pArg.oneOf, 1, false, "FalseList", true, false, nil, "yeah")
		self:expectLuaReturn("accept nil, if in list", pArg.oneOf, 1, nil, "NilList", true, false, nil, "yeah")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.oneOf, nil, true, "TestList", false)
		self:expectLuaError("argument 1: error", pArg.oneOf, 1, true, "TestList", false)
		self:expectLuaError("argument 100: error", pArg.oneOf, 100, true, "TestList", false)
		self:expectLuaError("arbitrary string: error", pArg.oneOf, "foo", true, "TestList", false)
		self:expectLuaError("table-key: error", pArg.oneOf, {"t1", "x"}, true, "TestList", false)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.notNil()", pArg.notNil)
self:registerJob("pArg.notNil()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.notNil, 1, "foo")
		self:expectLuaReturn("accept false", pArg.notNil, 1, false)
		self:expectLuaReturn("accept NaN", pArg.notNil, 1, 0/0)
		self:expectLuaError("reject nil", pArg.notNil, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.notNil, nil, nil)
		self:expectLuaError("argument 1: error", pArg.notNil, 1, nil)
		self:expectLuaError("argument 100: error", pArg.notNil, 100, nil)
		self:expectLuaError("arbitrary string: error", pArg.notNil, "foo", nil)
		self:expectLuaError("table-key: error", pArg.notNil, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.notNilNotNaN()", pArg.notNilNotNaN)
self:registerJob("pArg.notNilNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.notNilNotNaN, 1, "foo")
		self:expectLuaError("reject nil", pArg.notNilNotNaN, 1, nil)
		self:expectLuaReturn("accept false", pArg.notNilNotNaN, 1, false)
		self:expectLuaError("reject NaN", pArg.notNilNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.notNilNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", pArg.notNilNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", pArg.notNilNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", pArg.notNilNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", pArg.notNilNotNaN, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.notNilNotFalse()", pArg.notNilNotFalse)
self:registerJob("pArg.notNilNotFalse()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.notNilNotFalse, 1, "foo")
		self:expectLuaError("reject nil", pArg.notNilNotFalse, 1, nil)
		self:expectLuaError("reject false", pArg.notNilNotFalse, 1, false)
		self:expectLuaReturn("accept NaN", pArg.notNilNotFalse, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.notNilNotFalse, nil, nil)
		self:expectLuaError("argument 1: error", pArg.notNilNotFalse, 1, nil)
		self:expectLuaError("argument 100: error", pArg.notNilNotFalse, 100, nil)
		self:expectLuaError("arbitrary string: error", pArg.notNilNotFalse, "foo", nil)
		self:expectLuaError("table-key: error", pArg.notNilNotFalse, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.notNilNotFalseNotNaN()", pArg.notNilNotFalseNotNaN)
self:registerJob("pArg.notNilNotFalseNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.notNilNotFalseNotNaN, 1, "foo")
		self:expectLuaError("reject nil", pArg.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("reject false", pArg.notNilNotFalseNotNaN, 1, false)
		self:expectLuaError("reject NaN", pArg.notNilNotFalseNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.notNilNotFalseNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", pArg.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", pArg.notNilNotFalseNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", pArg.notNilNotFalseNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", pArg.notNilNotFalseNotNaN, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pArg.notNaN()", pArg.notNaN)
self:registerJob("pArg.notNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", pArg.notNaN, 1, "foo")
		self:expectLuaReturn("accept nil", pArg.notNaN, 1, nil)
		self:expectLuaReturn("accept false", pArg.notNaN, 1, false)
		self:expectLuaError("reject NaN", pArg.notNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", pArg.notNaN, nil, 0/0)
		self:expectLuaError("argument 1: error", pArg.notNaN, 1, 0/0)
		self:expectLuaError("argument 100: error", pArg.notNaN, 100, 0/0)
		self:expectLuaError("arbitrary string: error", pArg.notNaN, "foo", 0/0)
		self:expectLuaError("table-key: error", pArg.notNaN, {"t1", "x"}, 0/0)
	end
	--]====]
end
)
--]===]


self:runJobs()
