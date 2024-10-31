-- Test: pile_arg_check.lua
-- v1.1.3


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local argCheck = require(PATH .. "pile_arg_check")


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
self:registerFunction("argCheck.evalIntGE()", argCheck.evalIntGE)
self:registerJob("argCheck.evalIntGE()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.evalIntGE, 1, 100, 50)
		self:expectLuaReturn("expected behavior (eval false)", argCheck.evalIntGE, 1, false, 50)
		self:expectLuaError("bad type", argCheck.evalIntGE, 1, true, 50)
		self:expectLuaError("not an integer", argCheck.evalIntGE, 1, 5.5, 1)
		self:expectLuaError("under the minimum", argCheck.evalIntGE, 1, 5, 80)
		self:expectLuaError("NaN", argCheck.evalIntGE, 1, 0/0, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.evalIntGE, 1, true, 0)
		self:expectLuaError("argument 100: error", argCheck.evalIntGE, 100, true, 0)
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
self:registerFunction("argCheck.evalIntRange()", argCheck.evalIntRange)
self:registerJob("argCheck.evalIntRange()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.evalIntRange, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", argCheck.evalIntRange, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", argCheck.evalIntRange, 1, nil, 0, 100)
		self:expectLuaError("bad type", argCheck.evalIntRange, 1, {}, 50, 55)
		self:expectLuaError("not an integer", argCheck.evalIntRange, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.evalIntRange, 1, 5, 80, 90)
		self:expectLuaError("NaN", argCheck.evalIntRange, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.evalIntRange, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.evalIntRange, 100, true, 0, 100)
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
self:registerFunction("argCheck.evalIntRangeStatic()", argCheck.evalIntRangeStatic)
self:registerJob("argCheck.evalIntRangeStatic()", function(self)
	-- [====[
	do
		self:expectLuaReturn("expected behavior", argCheck.evalIntRangeStatic, 1, 100, 0, 100)
		self:expectLuaReturn("accept false", argCheck.evalIntRangeStatic, 1, false, 0, 100)
		self:expectLuaReturn("accept nil", argCheck.evalIntRangeStatic, 1, nil, 0, 100)
		self:expectLuaError("bad type", argCheck.evalIntRangeStatic, 1, {}, 50, 55)
		self:expectLuaError("not an integer", argCheck.evalIntRangeStatic, 1, 5.5, 1, 8)
		self:expectLuaError("less than the minimum", argCheck.evalIntRangeStatic, 1, 5, 80, 90)
		self:expectLuaError("NaN", argCheck.evalIntRangeStatic, 1, 0/0, 0, 100)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: error", argCheck.evalIntRangeStatic, 1, true, 0, 100)
		self:expectLuaError("argument 100: error", argCheck.evalIntRangeStatic, 100, true, 0, 100)
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


self:runJobs()
