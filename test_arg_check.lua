-- Test: pile_arg_check.lua
-- v1.1.8


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
		self:expectLuaReturn("nil is ignored", argCheck.typeEval, 1, false, "number", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", argCheck.typeEval, 1, false)
	end
	--]====]


	-- [====[
	do
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
		self:expectLuaReturn("nil is ignored", argCheck.typeEval1, 1, false, "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", argCheck.typeEval1, 1, false)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.typeEval1, 1, true, "number")
		self:expectLuaError("argument 100: error", argCheck.typeEval1, 100, true, "number")
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
		self:expectLuaReturn("Correct type, one option", argCheck.fieldType, 1, {foo=100}, "foo", "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.fieldType, 1, {foo=true}, "foo", "number", "boolean", "string")
		self:expectLuaError("will always fail when no options are provided", argCheck.fieldType, 1, {foo=true}, "foo")
		self:expectLuaReturn("numeric field ID", argCheck.fieldType, 1, {true}, 1, "boolean")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.fieldType, 1, {foo=true}, "foo", "number")
		self:expectLuaError("argument 100: error", argCheck.fieldType, 100, {foo=true}, "foo", "number")
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
		self:expectLuaReturn("Correct type, one option", argCheck.fieldTypeEval, 1, {foo=100}, "foo", "number")
		self:expectLuaReturn("Correct type, multiple options", argCheck.fieldTypeEval, 1, {foo=true}, "foo", "number", "boolean", "string")
		self:expectLuaReturn("false is ignored", argCheck.fieldTypeEval, 1, {foo=false}, "foo", "string")
		self:expectLuaReturn("nil is ignored", argCheck.fieldTypeEval, 1, {}, "foo", "string")
		self:expectLuaReturn("will permit false and nil when no options are provided", argCheck.fieldTypeEval, 1, {}, "foo")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.fieldTypeEval, 1, {foo=true}, "foo", "number")
		self:expectLuaError("argument 100: error", argCheck.fieldTypeEval, 100, {foo=true}, "foo", "number")
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
		self:expectLuaReturn("Correct type", argCheck.fieldType1, 1, {foo=100}, "foo", "number")
		self:expectLuaError("Will always fail when no option is provided", argCheck.fieldType1, 1, {foo=true}, "foo")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.fieldType1, 1, {foo=true}, "foo", "number")
		self:expectLuaError("argument 100: error", argCheck.fieldType1, 100, {foo=true}, "foo", "number")
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
		self:expectLuaReturn("Correct type", argCheck.fieldTypeEval1, 1, {foo=100}, "foo", "number")
		self:expectLuaReturn("false is ignored", argCheck.fieldTypeEval1, 1, {foo=false}, "foo", "string")
		self:expectLuaReturn("nil is ignored", argCheck.fieldTypeEval1, 1, {}, "foo", "number")
		self:expectLuaReturn("will permit false and nil when no expected type is provided", argCheck.fieldTypeEval1, 1, {foo=false}, "foo")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.fieldTypeEval1, 1, {foo=true}, "foo", "number")
		self:expectLuaError("argument 100: error", argCheck.fieldTypeEval1, 100, {foo=true}, "foo", "number")
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
		self:expectLuaError("NaN", argCheck.intRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
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
		self:expectLuaError("NaN", argCheck.intRangeEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
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
		self:expectLuaError("NaN", argCheck.intRangeStatic, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
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
		self:expectLuaError("NaN", argCheck.intRangeStaticEval, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
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
		self:expectLuaError("argument 1: error", argCheck.notNaN, 1, 0/0)
		self:expectLuaError("argument 100: error", argCheck.notNaN, 100, 0/0)
	end
	--]====]
end
)
--]===]


self:runJobs()
