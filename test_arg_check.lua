-- Test: pile_arg_check.lua
-- v1.201


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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.type, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.type, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.type, 100, true, "number")
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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("no argument: error", argCheck.typeEval, nil, true, "number")
		self:expectLuaError("argument 1: error", argCheck.typeEval, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.typeEval, 100, true, "number")
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
		self:expectLuaError("no argument: error", argCheck.intGE, nil, true, 0)
		self:expectLuaError("argument 1: error", argCheck.intGE, 1, true, 0)
		self:expectLuaError("argument 100: error", argCheck.intGE, 100, true, 0)
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
		self:expectLuaError("no argument: error", argCheck.intGEEval, nil, true, 0)
		self:expectLuaError("argument 1: error", argCheck.intGEEval, 1, true, 0)
		self:expectLuaError("argument 100: error", argCheck.intGEEval, 100, true, 0)
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
		self:expectLuaError("no argument: error", argCheck.intRange, nil, true, 0, 100)
		self:expectLuaError("argument 1: error", argCheck.intRange, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.intRange, 100, true, 0, 100)
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
		self:expectLuaError("no argument: error", argCheck.intRangeEval, nil, true, 0, 100)
		self:expectLuaError("argument 1: error", argCheck.intRangeEval, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.intRangeEval, 100, true, 0, 100)
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
		self:expectLuaError("no argument: error", argCheck.intRangeStatic, nil, true, 0, 100)
		self:expectLuaError("argument 1: error", argCheck.intRangeStatic, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.intRangeStatic, 100, true, 0, 100)
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
		self:expectLuaError("no argument: error", argCheck.intRangeStaticEval, nil, true, 0, 100)
		self:expectLuaError("argument 1: error", argCheck.intRangeStaticEval, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.intRangeStaticEval, 100, true, 0, 100)
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
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldType()", argCheck.fieldType)
self:registerJob("argCheck.fieldType()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", argCheck.fieldType, {foo=100}, "t1", "foo", "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.fieldType, {foo=true}, "t2", "foo", "number", "boolean", "string")
		self:expectLuaError("will always fail when no options are provided", argCheck.fieldType, {foo=true}, "t3", "foo")
		self:expectLuaReturn("numeric field ID", argCheck.fieldType, {true}, "t4", 1, "boolean")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldTypeEval()", argCheck.fieldTypeEval)
self:registerJob("argCheck.fieldTypeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type, one option", argCheck.fieldTypeEval, {foo=100}, "t1", "foo", "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.fieldTypeEval, {foo=true}, "t2", "foo", "number", "boolean", "string")
		self:expectLuaReturn("false is ignored", argCheck.fieldTypeEval, {foo=false}, "t3", "foo", "string")
		self:expectLuaReturn("nil is ignored", argCheck.fieldTypeEval, {}, "t4", "foo", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", argCheck.fieldTypeEval, {}, "t5", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldType1()", argCheck.fieldType1)
self:registerJob("argCheck.fieldType1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", argCheck.fieldType1, {foo=100}, "t1", "foo", "number")
		self:expectLuaError("Will always fail when no option is provided", argCheck.fieldType1, {foo=true}, "t2", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldTypeEval1()", argCheck.fieldTypeEval1)
self:registerJob("argCheck.fieldTypeEval1()", function(self)
	-- [====[
	do
		self:expectLuaReturn("Correct type", argCheck.fieldTypeEval1, {foo=100}, "t1", "foo", "number")
		self:expectLuaReturn("false is ignored", argCheck.fieldTypeEval1, {foo=false}, "t2", "foo", "string")
		self:expectLuaReturn("nil is ignored", argCheck.fieldTypeEval1, {}, "t3", "foo", "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", argCheck.fieldTypeEval1, {foo=false}, "t4", "foo", "boolean")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldInt()", argCheck.fieldInt)
self:registerJob("argCheck.fieldInt()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldInt, {foo=100}, "t1", "foo")
		self:expectLuaError("bad type", argCheck.fieldInt, {foo=false}, "t2", "foo")
		self:expectLuaError("not an integer", argCheck.fieldInt, {foo=5.5}, "t3", "foo")
		self:expectLuaError("NaN", argCheck.fieldInt, {foo=0/0}, "t4", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntEval()", argCheck.fieldIntEval)
self:registerJob("argCheck.fieldIntEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntEval, {foo=100}, "t1", "foo")
		self:expectLuaError("bad type", argCheck.fieldIntEval, {foo=true}, "t2", "foo")
		self:expectLuaError("not an integer", argCheck.fieldIntEval, {foo=5.5}, "t3", "foo")
		self:expectLuaError("NaN", argCheck.fieldIntEval, {foo=0/0}, "t4", "foo")
		self:expectLuaReturn("accept false", argCheck.fieldIntEval, {foo=false}, "t5", "foo")
		self:expectLuaReturn("accept nil", argCheck.fieldIntEval, {foo=nil}, "t6", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntGE()", argCheck.fieldIntGE)
self:registerJob("argCheck.fieldIntGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntGE, {foo=100}, "t1", "foo", 50)
		self:expectLuaError("bad type", argCheck.fieldIntGE, {foo=false}, "t2", "foo", 50)
		self:expectLuaError("not an integer", argCheck.fieldIntGE, {foo=5.5}, "t3", "foo", 1)
		self:expectLuaError("under the minimum", argCheck.fieldIntGE, {foo=5}, "t4", "foo", 80)
		self:expectLuaError("NaN", argCheck.fieldIntGE, {foo=0/0}, "t5", "foo", 0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntGEEval()", argCheck.fieldIntGEEval)
self:registerJob("argCheck.fieldIntGEEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntGEEval, {foo=100}, "t1", "foo", 50)
		self:expectLuaReturn("expected behavior (eval false)", argCheck.fieldIntGEEval, {foo=false}, "t2", "foo", 50)
		self:expectLuaError("bad type", argCheck.fieldIntGEEval, {foo=true}, "t3", "foo", 50)
		self:expectLuaError("not an integer", argCheck.fieldIntGEEval, {foo=5.5}, "t4", "foo", 1)
		self:expectLuaError("under the minimum", argCheck.fieldIntGEEval, {foo=5}, "t5", "foo", 80)
		self:expectLuaError("NaN", argCheck.fieldIntGEEval, {foo=0/0}, "t6", "foo", 0)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntRange()", argCheck.fieldIntRange)
self:registerJob("argCheck.fieldIntRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntRange, {foo=100}, "t1", "foo", 0, 100)
		self:expectLuaError("bad type", argCheck.fieldIntRange, {foo=false}, "t2", "foo", 50, 55)
		self:expectLuaError("not an integer", argCheck.fieldIntRange, {foo=5.5}, "t3", "foo", 5.5)
		self:expectLuaError("less than the minimum", argCheck.fieldIntRange, {foo=5}, "t4", "foo", 80, 90)
		self:expectLuaError("more than the maximum", argCheck.fieldIntRange, {foo=100}, "t5", "foo", 80, 90)
		self:expectLuaError("NaN", argCheck.fieldIntRange, {foo=0/0}, "t6", "foo", 0, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntRangeEval()", argCheck.fieldIntRangeEval)
self:registerJob("argCheck.fieldIntRangeEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntRangeEval, {foo=100}, "t1", "foo", 0, 100)
		self:expectLuaReturn("accept false", argCheck.fieldIntRangeEval, {foo=false}, "t2", "foo", 0, 100)
		self:expectLuaReturn("accept nil", argCheck.fieldIntRangeEval, {foo=nil}, "t3", "foo", 0, 100)
		self:expectLuaError("bad type", argCheck.fieldIntRangeEval, {foo={}}, "t4", "foo", 50, 55)
		self:expectLuaError("not an integer", argCheck.fieldIntRangeEval, {foo=5.5}, "t5", "foo", 1, 8)
		self:expectLuaError("less than the minimum", argCheck.fieldIntRangeEval, {foo=5}, "t6", "foo", 80, 90)
		self:expectLuaError("more than the maximum", argCheck.fieldIntRangeEval, {foo=100}, "t7", "foo", 80, 90)
		self:expectLuaError("NaN", argCheck.fieldIntRangeEval, {foo=0/0}, "t7", "foo", 0, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntRangeStatic()", argCheck.fieldIntRangeStatic)
self:registerJob("argCheck.fieldIntRangeStatic()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntRangeStatic, {foo=100}, "t1", "foo", 0, 100)
		self:expectLuaError("bad type", argCheck.fieldIntRangeStatic, {foo=false}, "t2", "foo", 50, 55)
		self:expectLuaError("not an integer", argCheck.fieldIntRangeStatic, {foo=5.5}, "t3", "foo", 1, 8)
		self:expectLuaError("less than the minimum", argCheck.fieldIntRangeStatic, {foo=5}, "t4", "foo", 80, 90)
		self:expectLuaError("more than the maximum", argCheck.fieldIntRangeStatic, {foo=100}, "t5", "foo", 80, 90)
		self:expectLuaError("NaN", argCheck.fieldIntRangeStatic, {foo=0/0}, "t6", "foo", 0, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldIntRangeStaticEval()", argCheck.fieldIntRangeStaticEval)
self:registerJob("argCheck.fieldIntRangeStaticEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldIntRangeStaticEval, {foo=100}, "t1", "foo", 0, 100)
		self:expectLuaReturn("accept false", argCheck.fieldIntRangeStaticEval, {foo=false}, "t2", "foo", 0, 100)
		self:expectLuaReturn("accept nil", argCheck.fieldIntRangeStaticEval, {foo=nil}, "t3", "foo", 0, 100)
		self:expectLuaError("bad type", argCheck.fieldIntRangeStaticEval, {foo={}}, "t4", "foo", 50, 55)
		self:expectLuaError("not an integer", argCheck.fieldIntRangeStaticEval, {foo=5.5}, "t5", "foo", 1, 8)
		self:expectLuaError("less than the minimum", argCheck.fieldIntRangeStaticEval, {foo=5}, "t6", "foo", 80, 90)
		self:expectLuaError("more than the maximum", argCheck.fieldIntRangeStaticEval, {foo=100}, "t7", "foo", 80, 90)
		self:expectLuaError("NaN", argCheck.fieldIntRangeStaticEval, {foo=0/0}, "t8", "foo", 0, 100)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNumberNotNaN()", argCheck.fieldNumberNotNaN)
self:registerJob("argCheck.fieldNumberNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNumberNotNaN, {foo=5}, "t1", "foo")
		self:expectLuaError("wrong type", argCheck.fieldNumberNotNaN, {foo=true}, "t2", "foo")
		self:expectLuaError("reject NaN", argCheck.fieldNumberNotNaN, {foo=0/0}, "t3", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNumberNotNaNEval()", argCheck.fieldNumberNotNaNEval)
self:registerJob("argCheck.fieldNumberNotNaNEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNumberNotNaNEval, {foo=5}, "t1", "foo")
		self:expectLuaError("wrong type", argCheck.fieldNumberNotNaNEval, {foo=true}, "t2", "foo")
		self:expectLuaError("reject NaN", argCheck.fieldNumberNotNaNEval, {foo=0/0}, "t3", "foo")
		self:expectLuaReturn("accept false", argCheck.fieldNumberNotNaNEval, {foo=false}, "t4", "foo")
		self:expectLuaReturn("accept nil", argCheck.fieldNumberNotNaNEval, {foo=nil}, "t5", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldEnum()", argCheck.fieldEnum)
self:registerJob("argCheck.fieldEnum()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldEnum, {foo="bar"}, "t1", "foo", "enum", {bar=true})
		self:expectLuaError("not in enum table", argCheck.fieldEnum, {foo="bar"}, "t2", "zop", "enum", {bar=true})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldEnumEval()", argCheck.fieldEnumEval)
self:registerJob("argCheck.fieldEnumEval()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldEnumEval, {foo="bar"}, "t1", "foo", "enum", {bar=true})
		self:expectLuaError("not in enum table", argCheck.fieldEnumEval, {foo="bar"}, "t2", "foo", "enum", {zop=true})
		self:expectLuaReturn("accept false", argCheck.fieldEnumEval, {foo=false}, "t3", "foo", "enum", {bar=true})
		self:expectLuaReturn("accept nil", argCheck.fieldEnumEval, {foo=nil}, "t4", "foo", "enum", {bar=true})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNotNil()", argCheck.fieldNotNil)
self:registerJob("argCheck.fieldNotNil()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNotNil, {foo="bar"}, "t1", "foo")
		self:expectLuaReturn("accept false", argCheck.fieldNotNil, {foo=false}, "t2", "foo")
		self:expectLuaReturn("accept NaN", argCheck.fieldNotNil, {foo=0/0}, "t3", "foo")
		self:expectLuaError("reject nil", argCheck.fieldNotNil, {foo=nil}, "t4", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNotNilNotNaN()", argCheck.fieldNotNilNotNaN)
self:registerJob("argCheck.fieldNotNilNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNotNilNotNaN, {foo="bar"}, "t1", "foo")
		self:expectLuaError("reject nil", argCheck.fieldNotNilNotNaN, {foo=nil}, "t2", "foo")
		self:expectLuaReturn("accept false", argCheck.fieldNotNilNotNaN, {foo=false}, "t3", "foo")
		self:expectLuaError("reject NaN", argCheck.fieldNotNilNotNaN, {foo=0/0}, "t4", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNotNilNotFalse()", argCheck.fieldNotNilNotFalse)
self:registerJob("argCheck.fieldNotNilNotFalse()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNotNilNotFalse, {foo="bar"}, "t1", "foo")
		self:expectLuaError("reject nil", argCheck.fieldNotNilNotFalse, {foo=nil}, "t2", "foo")
		self:expectLuaError("reject false", argCheck.fieldNotNilNotFalse, {foo=false}, "t3", "foo")
		self:expectLuaReturn("accept NaN", argCheck.fieldNotNilNotFalse, {foo=0/0}, "t4", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNotNilNotFalseNotNaN()", argCheck.fieldNotNilNotFalseNotNaN)
self:registerJob("argCheck.fieldNotNilNotFalseNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNotNilNotFalseNotNaN, {foo="bar"}, "t1", "foo")
		self:expectLuaError("reject nil", argCheck.fieldNotNilNotFalseNotNaN, {foo=nil}, "t2", "foo")
		self:expectLuaError("reject false", argCheck.fieldNotNilNotFalseNotNaN, {foo=false}, "t3", "foo")
		self:expectLuaError("reject NaN", argCheck.fieldNotNilNotFalseNotNaN, {foo=0/0}, "t4", "foo")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("argCheck.fieldNotNaN()", argCheck.fieldNotNaN)
self:registerJob("argCheck.fieldNotNaN()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.fieldNotNaN, {foo="bar"}, "t1", "foo")
		self:expectLuaReturn("accept nil", argCheck.fieldNotNaN, {foo=nil}, "t2", "foo")
		self:expectLuaReturn("accept false", argCheck.fieldNotNaN, {foo=false}, "t3", "foo")
		self:expectLuaError("reject NaN", argCheck.fieldNotNaN, {foo=0/0}, "t4", "foo")
	end
	--]====]
end
)
--]===]


self:runJobs()
