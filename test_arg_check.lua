-- Test: pile_arg_check.lua
-- v1.1.0


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
		self:expectLuaError("argument 1: bad type", argCheck.type, 1, true, "number")
		self:expectLuaError("argument 100: bad type", argCheck.type, 100, true, "number")
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
		self:expectLuaError("argument 1: bad type", argCheck.typeEval, 1, true, "number")
		self:expectLuaError("argument 100: bad type", argCheck.typeEval, 100, true, "number")
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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: bad type", argCheck.int, 1, true)
		self:expectLuaError("argument 100: bad type", argCheck.int, 100, true)
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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: bad type", argCheck.intGE, 1, true, 0)
		self:expectLuaError("argument 100: bad type", argCheck.intGE, 100, true, 0)
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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: bad type", argCheck.intGE, 1, true, 0)
		self:expectLuaError("argument 100: bad type", argCheck.intGE, 100, true, 0)
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
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("argument 1: bad type", argCheck.intRange, 1, true, 0, 100)
		self:expectLuaError("argument 100: bad type", argCheck.intRange, 100, true, 0, 100)
	end
	--]====]
end
)
--]===]


self:runJobs()
