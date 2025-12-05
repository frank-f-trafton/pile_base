-- Test: pile_name.lua
-- v2.011


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pName = require(PATH .. "pile_name")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pName", cli_verbosity)


-- [===[
self:registerFunction("pName.set()", pName.set)
self:registerJob("pName.set()", function(self)
	-- [====[
	do
		local v = {}
		local rv = self:expectLuaReturn("expected behavior", pName.set, v, "MyTable")
		self:isEqual(pName.names[v], "MyTable")
		self:isEqual(rv, v)

		self:expectLuaReturn("erase name", pName.set, v, false)
		self:isEqual(pName.names[v], nil)

		self:expectLuaError("arg #1 bad type", pName.set, 123, "MyTable")
		self:expectLuaError("arg #2 bad type", pName.set, {}, function() end)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pName.get()", pName.get)
self:registerJob("pName.get()", function(self)
	-- [====[
	do
		local rv
		local v = {}
		pName.set(v, "¡Oye!")
		rv = self:expectLuaReturn("expected behavior", pName.get, v)
		self:isEqual(rv, "¡Oye!")

		pName.set(v, nil)
		rv = self:expectLuaReturn("unnamed", pName.get, v)
		self:isEqual(rv, nil)

		self:expectLuaError("arg #1 bad type", pName.get, 123)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pName.safeGet()", pName.safeGet)
self:registerJob("pName.safeGet()", function(self)
	-- [====[
	do
		local rv
		local v = {}
		pName.set(v, "Goose")
		rv = self:expectLuaReturn("expected behavior", pName.safeGet, v)
		self:isEqual(rv, "Goose")

		pName.set(v, nil)
		rv = self:expectLuaReturn("Unnamed, rely on caller-provided fallback", pName.safeGet, v, "Faller-Backer")
		self:isEqual(rv, "Faller-Backer")

		rv = self:expectLuaReturn("Unnamed, rely on default fallback", pName.safeGet, v, nil)
		self:isEqual(rv, "Unknown")

		self:expectLuaError("arg #1 bad type", pName.safeGet, 123)

		rv = self:expectLuaReturn("Convert any eval-to-true value for 'fallback' to a string", pName.safeGet, v, function() end)
		self:isEqual(rv:match("^(function:)"), "function:")
	end
	--]====]
end
)
--]===]


self:runJobs()
