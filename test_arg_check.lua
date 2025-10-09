-- Test: pile_arg_check.lua
-- v1.202


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local argCheck = require(PATH .. "pile_arg_check")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("argCheck", cli_verbosity)


--[[
argCheck's functions do minimal (if any) checking of their own arguments.
--]]


-- [===[
self:registerFunction("argCheck.type()", argCheck.type)
self:registerJob("argCheck.type()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", argCheck.type, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.type, 1, true, "number", "boolean", "string")
		self:expectLuaError("will always fail when no options are provided", argCheck.type, 1, true)
		self:expectLuaError("bad type, multiple options", argCheck.type, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.type, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.type, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.type, 100, true, "number")
		self:expectLuaError("arbitrary string: error", argCheck.type, "foo", true, "number")
		self:expectLuaError("table-key: error", argCheck.type, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.typeEval()", argCheck.typeEval)
self:registerJob("argCheck.typeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", argCheck.typeEval, 1, 100, "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.typeEval, 1, true, "number", "boolean", "string")
		self:expectLuaReturn("false is ignored", argCheck.typeEval, 1, false, "number", "string")
		self:expectLuaReturn("nil is ignored", argCheck.typeEval, 1, nil, "number", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", argCheck.typeEval, 1, false)
		self:expectLuaError("bad type, multiple options", argCheck.typeEval, 1, function() end, "number", "boolean", "string")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.typeEval, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.typeEval, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.typeEval, 100, true, "number")
		self:expectLuaError("arbitrary string: error", argCheck.typeEval, "foo", true, "number")
		self:expectLuaError("table-key: error", argCheck.typeEval, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.type1()", argCheck.type1)
self:registerJob("argCheck.type1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", argCheck.type1, 1, 100, "number")
		self:expectLuaError("Will always fail when no option is provided", argCheck.type1, 1, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.type1, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.type1, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.type1, 100, true, "number")
		self:expectLuaError("arbitrary string: error", argCheck.type1, "foo", true, "number")
		self:expectLuaError("table-key: error", argCheck.type1, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.typeEval1()", argCheck.typeEval1)
self:registerJob("argCheck.typeEval1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", argCheck.typeEval1, 1, 100, "number")
		self:expectLuaReturn("false is ignored", argCheck.typeEval1, 1, false, "string")
		self:expectLuaReturn("nil is ignored", argCheck.typeEval1, 1, nil, "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", argCheck.typeEval1, 1, false)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.typeEval1, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.typeEval1, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.typeEval1, 100, true, "number")
		self:expectLuaError("arbitrary string: error", argCheck.typeEval1, "foo", true, "number")
		self:expectLuaError("table-key: error", argCheck.typeEval1, {"t1", "x"}, true, "number")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.int()", argCheck.int)
self:registerJob("argCheck.int()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.int, 1, 100)
		self:expectLuaError("bad type", argCheck.int, 1, false)
		self:expectLuaError("not an integer", argCheck.int, 1, 5.5)
		self:expectLuaError("NaN", argCheck.int, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.int, nil, true)
		self:expectLuaError("argument 1: error", argCheck.int, 1, true)
		self:expectLuaError("argument 100: error", argCheck.int, 100, true)
		self:expectLuaError("arbitrary string: error", argCheck.int, "foo", true)
		self:expectLuaError("table-key: error", argCheck.int, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.intEval()", argCheck.intEval)
self:registerJob("argCheck.intEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intEval, 1, 100)
		self:expectLuaError("bad type", argCheck.intEval, 1, true)
		self:expectLuaError("not an integer", argCheck.intEval, 1, 5.5)
		self:expectLuaError("NaN", argCheck.intEval, 1, 0/0)
		self:expectLuaReturn("accept false", argCheck.intEval, 1, false)
		self:expectLuaReturn("accept nil", argCheck.intEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intEval, nil, true)
		self:expectLuaError("argument 1: error", argCheck.intEval, 1, true)
		self:expectLuaError("argument 100: error", argCheck.intEval, 100, true)
		self:expectLuaError("arbitrary string: error", argCheck.intEval, "foo", true)
		self:expectLuaError("table-key: error", argCheck.intEval, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.intGE()", argCheck.intGE)
self:registerJob("argCheck.intGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intGE, 1, 100, 50)
		self:expectLuaError("bad type", argCheck.intGE, 1, false, 50)
		self:expectLuaError("not an integer", argCheck.intGE, 1, 5.5, 1)
		self:expectLuaError("under the minimum", argCheck.intGE, 1, 5, 80)
		self:expectLuaError("NaN", argCheck.intGE, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intGE, nil, 50, 100)
		self:expectLuaError("argument 1: error", argCheck.intGE, 1, 50, 100)
		self:expectLuaError("argument 100: error", argCheck.intGE, 100, 50, 100)
		self:expectLuaError("arbitrary string: error", argCheck.intGE, "foo", 50, 100)
		self:expectLuaError("table-key: error", argCheck.intGE, {"t1", "x"}, 50, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.intGEEval()", argCheck.intGEEval)
self:registerJob("argCheck.intGEEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intGEEval, 1, 100, 50)
		self:expectLuaReturn("expected behavior (eval false)", argCheck.intGEEval, 1, false, 50)
		self:expectLuaError("bad type", argCheck.intGEEval, 1, true, 50)
		self:expectLuaError("not an integer", argCheck.intGEEval, 1, 5.5, 1)
		self:expectLuaError("under the minimum", argCheck.intGEEval, 1, 5, 80)
		self:expectLuaError("NaN", argCheck.intGEEval, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intGEEval, nil, 5, 80)
		self:expectLuaError("argument 1: error", argCheck.intGEEval, 1, 5, 80)
		self:expectLuaError("argument 100: error", argCheck.intGEEval, 100, 5, 80)
		self:expectLuaError("arbitrary string: error", argCheck.intGEEval, "foo", 5, 80)
		self:expectLuaError("table-key: error", argCheck.intGEEval, {"t1", "x"}, 5, 80)
	end
	--]====]
end
)
--]===]

-- [===[
self:registerFunction("argCheck.intRange()", argCheck.intRange)
self:registerJob("argCheck.intRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intRange, 1, 100, 0, 100)
		self:expectLuaError("bad type", argCheck.intRange, 1, false, 50, 55)
		self:expectLuaError("not an integer", argCheck.intRange, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.intRange, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", argCheck.intRange, 1, 100, 80, 90)
		self:expectLuaError("NaN", argCheck.intRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intRange, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", argCheck.intRange, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", argCheck.intRange, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", argCheck.intRange, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", argCheck.intRange, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.intRangeEval()", argCheck.intRangeEval)
self:registerJob("argCheck.intRangeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intRangeEval, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", argCheck.intRangeEval, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", argCheck.intRangeEval, 1, nil, 0, 100)
		self:expectLuaError("bad type", argCheck.intRangeEval, 1, {}, 50, 55)
		self:expectLuaError("not an integer", argCheck.intRangeEval, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.intRangeEval, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", argCheck.intRangeEval, 1, 100, 80, 90)
		self:expectLuaError("NaN", argCheck.intRangeEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intRangeEval, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", argCheck.intRangeEval, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", argCheck.intRangeEval, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", argCheck.intRangeEval, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", argCheck.intRangeEval, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- The 'static' variations of intRange are functionally identical. They just include the range
-- in error messages.
-- [===[
self:registerFunction("argCheck.intRangeStatic()", argCheck.intRangeStatic)
self:registerJob("argCheck.intRangeStatic()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intRangeStatic, 1, 100, 0, 100)
		self:expectLuaError("bad type", argCheck.intRangeStatic, 1, false, 50, 55)
		self:expectLuaError("not an integer", argCheck.intRangeStatic, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.intRangeStatic, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", argCheck.intRangeStatic, 1, 100, 80, 90)
		self:expectLuaError("NaN", argCheck.intRangeStatic, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intRangeStatic, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", argCheck.intRangeStatic, 1, 5, 80, 90)
		self:expectLuaError("argument 100: error", argCheck.intRangeStatic, 100, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", argCheck.intRangeStatic, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", argCheck.intRangeStatic, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.intRangeStaticEval()", argCheck.intRangeStaticEval)
self:registerJob("argCheck.intRangeStaticEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.intRangeStaticEval, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", argCheck.intRangeStaticEval, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", argCheck.intRangeStaticEval, 1, nil, 0, 100)
		self:expectLuaError("bad type", argCheck.intRangeStaticEval, 1, {}, 50, 55)
		self:expectLuaError("not an integer", argCheck.intRangeStaticEval, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.intRangeStaticEval, 1, 5, 80, 90)
		self:expectLuaError("more than the maximum", argCheck.intRangeStaticEval, 1, 100, 80, 90)
		self:expectLuaError("NaN", argCheck.intRangeStaticEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.intRangeStaticEval, nil, 5, 80, 90)
		self:expectLuaError("argument 1: error", argCheck.intRangeStaticEval, 1, true, 5, 80, 90)
		self:expectLuaError("argument 100: error", argCheck.intRangeStaticEval, 100, true, 5, 80, 90)
		self:expectLuaError("arbitrary string: error", argCheck.intRangeStaticEval, "foo", 5, 80, 90)
		self:expectLuaError("table-key: error", argCheck.intRangeStaticEval, {"t1", "x"}, 5, 80, 90)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.numberNotNaN()", argCheck.numberNotNaN)
self:registerJob("argCheck.numberNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.numberNotNaN, 1, 5)
		self:expectLuaError("wrong type", argCheck.numberNotNaN, 1, true)
		self:expectLuaError("reject NaN", argCheck.numberNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.numberNotNaN, nil, true)
		self:expectLuaError("argument 1: error", argCheck.numberNotNaN, 1, true)
		self:expectLuaError("argument 100: error", argCheck.numberNotNaN, 100, true)
		self:expectLuaError("arbitrary string: error", argCheck.numberNotNaN, "foo", true)
		self:expectLuaError("table-key: error", argCheck.numberNotNaN, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.numberNotNaNEval()", argCheck.numberNotNaNEval)
self:registerJob("argCheck.numberNotNaNEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.numberNotNaNEval, 1, 5)
		self:expectLuaError("wrong type", argCheck.numberNotNaNEval, 1, true)
		self:expectLuaError("reject NaN", argCheck.numberNotNaNEval, 1, 0/0)
		self:expectLuaReturn("accept false", argCheck.numberNotNaNEval, 1, false)
		self:expectLuaReturn("accept nil", argCheck.numberNotNaNEval, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.numberNotNaNEval, nil, true)
		self:expectLuaError("argument 1: error", argCheck.numberNotNaNEval, 1, true)
		self:expectLuaError("argument 100: error", argCheck.numberNotNaNEval, 100, true)
		self:expectLuaError("arbitrary string: error", argCheck.numberNotNaNEval, "foo", true)
		self:expectLuaError("table-key: error", argCheck.numberNotNaNEval, {"t1", "x"}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.enum()", argCheck.enum)
self:registerJob("argCheck.enum()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.enum, 1, "foo", "enum", {foo=true})
		self:expectLuaError("not in enum table", argCheck.enum, 1, "bar", "enum", {foo=true})
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.enum, nil, true, "enum", {})
		self:expectLuaError("argument 1: error", argCheck.enum, 1, true, "enum", {})
		self:expectLuaError("argument 100: error", argCheck.enum, 100, true, "enum", {})
		self:expectLuaError("arbitrary string: error", argCheck.enum, "foo", true, "enum", {})
		self:expectLuaError("table-key: error", argCheck.enum, {"t1", "x"}, true, "enum", {})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.enumEval()", argCheck.enumEval)
self:registerJob("argCheck.enumEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.enumEval, 1, "foo", "enum", {foo=true})
		self:expectLuaError("not in enum table", argCheck.enumEval, 1, "bar", "enum", {foo=true})
		self:expectLuaReturn("accept false", argCheck.enumEval, 1, false, "enum", {})
		self:expectLuaReturn("accept nil", argCheck.enumEval, 1, nil, "enum", {})
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.enumEval, nil, true, "enum", {})
		self:expectLuaError("argument 1: error", argCheck.enumEval, 1, true, "enum", {})
		self:expectLuaError("argument 100: error", argCheck.enumEval, 100, true, "enum", {})
		self:expectLuaError("arbitrary string: error", argCheck.enumEval, "foo", true, "enum", {})
		self:expectLuaError("table-key: error", argCheck.enumEval, {"t1", "x"}, true, "enum", {})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.notNil()", argCheck.notNil)
self:registerJob("argCheck.notNil()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.notNil, 1, "foo")
		self:expectLuaReturn("accept false", argCheck.notNil, 1, false)
		self:expectLuaReturn("accept NaN", argCheck.notNil, 1, 0/0)
		self:expectLuaError("reject nil", argCheck.notNil, 1, nil)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.notNil, nil, nil)
		self:expectLuaError("argument 1: error", argCheck.notNil, 1, nil)
		self:expectLuaError("argument 100: error", argCheck.notNil, 100, nil)
		self:expectLuaError("arbitrary string: error", argCheck.notNil, "foo", nil)
		self:expectLuaError("table-key: error", argCheck.notNil, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.notNilNotNaN()", argCheck.notNilNotNaN)
self:registerJob("argCheck.notNilNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.notNilNotNaN, 1, "foo")
		self:expectLuaError("reject nil", argCheck.notNilNotNaN, 1, nil)
		self:expectLuaReturn("accept false", argCheck.notNilNotNaN, 1, false)
		self:expectLuaError("reject NaN", argCheck.notNilNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.notNilNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", argCheck.notNilNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", argCheck.notNilNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", argCheck.notNilNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", argCheck.notNilNotNaN, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.notNilNotFalse()", argCheck.notNilNotFalse)
self:registerJob("argCheck.notNilNotFalse()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.notNilNotFalse, 1, "foo")
		self:expectLuaError("reject nil", argCheck.notNilNotFalse, 1, nil)
		self:expectLuaError("reject false", argCheck.notNilNotFalse, 1, false)
		self:expectLuaReturn("accept NaN", argCheck.notNilNotFalse, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.notNilNotFalse, nil, nil)
		self:expectLuaError("argument 1: error", argCheck.notNilNotFalse, 1, nil)
		self:expectLuaError("argument 100: error", argCheck.notNilNotFalse, 100, nil)
		self:expectLuaError("arbitrary string: error", argCheck.notNilNotFalse, "foo", nil)
		self:expectLuaError("table-key: error", argCheck.notNilNotFalse, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.notNilNotFalseNotNaN()", argCheck.notNilNotFalseNotNaN)
self:registerJob("argCheck.notNilNotFalseNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.notNilNotFalseNotNaN, 1, "foo")
		self:expectLuaError("reject nil", argCheck.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("reject false", argCheck.notNilNotFalseNotNaN, 1, false)
		self:expectLuaError("reject NaN", argCheck.notNilNotFalseNotNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.notNilNotFalseNotNaN, nil, nil)
		self:expectLuaError("argument 1: error", argCheck.notNilNotFalseNotNaN, 1, nil)
		self:expectLuaError("argument 100: error", argCheck.notNilNotFalseNotNaN, 100, nil)
		self:expectLuaError("arbitrary string: error", argCheck.notNilNotFalseNotNaN, "foo", nil)
		self:expectLuaError("table-key: error", argCheck.notNilNotFalseNotNaN, {"t1", "x"}, nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.notNaN()", argCheck.notNaN)
self:registerJob("argCheck.notNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.notNaN, 1, "foo")
		self:expectLuaReturn("accept nil", argCheck.notNaN, 1, nil)
		self:expectLuaReturn("accept false", argCheck.notNaN, 1, false)
		self:expectLuaError("reject NaN", argCheck.notNaN, 1, 0/0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.notNaN, nil, 0/0)
		self:expectLuaError("argument 1: error", argCheck.notNaN, 1, 0/0)
		self:expectLuaError("argument 100: error", argCheck.notNaN, 100, 0/0)
		self:expectLuaError("arbitrary string: error", argCheck.notNaN, "foo", 0/0)
		self:expectLuaError("table-key: error", argCheck.notNaN, {"t1", "x"}, 0/0)
	end
	--]====]
end
)
--]===]


self:runJobs()
