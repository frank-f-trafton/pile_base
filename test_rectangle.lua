-- Test: pile_rectangle.lua
-- v2.000


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")


--[[
This test will run with pRect's optional assertions enabled. To do that, we need
to load the source file as a string and ensure that the assertions aren't
commented out.
--]]
local pRect
do
	local f, err = io.open("pile_rectangle.lua", "r")
	if not f then
		error(err)
	end
	local source_str = f:read("*a")
	if not source_str then
		error("couldn't read source file 'pile_rectangle.lua'.")
	end
	f:close()

	source_str = source_str:gsub("%-%-%[%[ASSERT", "-- [[ASSERT")

	local _load = rawget(_G, "loadstring") or rawget(_G, "load")

	pRect = assert(_load(source_str, "(pRect source)"))(...)
end


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Rectangle", cli_verbosity)


self:registerFunction("pRect.set", pRect.set)


-- [===[
self:registerJob("pRect.set", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("set XYWH", pRect.set, r, 4, 6, 8, 10)
		self:isEqual(r.x, 4)
		self:isEqual(r.y, 6)
		self:isEqual(r.w, 8)
		self:isEqual(r.h, 10)
		--]]
	end
	--]====]

	-- [====[
	self:expectLuaError("Rectangle, bad type", pRect.set, false, 4, 6, 8, 10)
	self:expectLuaError("arg 2 bad type", pRect.set, {x=0, y=0, w=0, h=0}, false, 6, 8, 10)
	self:expectLuaError("arg 3 bad type", pRect.set, {x=0, y=0, w=0, h=0}, 4, false, 8, 10)
	self:expectLuaError("arg 4 bad type", pRect.set, {x=0, y=0, w=0, h=0}, 4, 6, false, 10)
	self:expectLuaError("arg 5 bad type", pRect.set, {x=0, y=0, w=0, h=0}, 4, 6, 8, false)
	--]====]
end
)
--]===]


self:registerFunction("pRect.setPosition", pRect.setPosition)


-- [===[
self:registerJob("pRect.setPosition", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=16, h=16}
		self:expectLuaReturn("set XY", pRect.setPosition, r, 4, 6)
		self:isEqual(r.x, 4)
		self:isEqual(r.y, 6)
		self:isEqual(r.w, 16)
		self:isEqual(r.h, 16)
		--]]
	end
	--]====]

	-- [====[
	self:expectLuaError("Rectangle, bad type", pRect.setPosition, false, 4, 6, 8, 10)
	self:expectLuaError("arg 2 bad type", pRect.setPosition, {x=0, y=0, w=0, h=0}, false, 6)
	self:expectLuaError("arg 3 bad type", pRect.setPosition, {x=0, y=0, w=0, h=0}, 4, false)
	--]====]
end
)
--]===]


self:registerFunction("pRect.setDimensions", pRect.setDimensions)


-- [===[
self:registerJob("pRect.setDimensions", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("set WH", pRect.setDimensions, r, 8, 10)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 8)
		self:isEqual(r.h, 10)
		--]]
	end
	--]====]

	-- [====[
	self:expectLuaError("Rectangle, bad type", pRect.setDimensions, false, 8, 10)
	self:expectLuaError("arg 2 bad type", pRect.setDimensions, {x=0, y=0, w=0, h=0}, false, 10)
	self:expectLuaError("arg 3 bad type", pRect.setDimensions, {x=0, y=0, w=0, h=0}, 4, false)
	--]====]
end
)
--]===]


self:registerFunction("pRect.copy", pRect.copy)


-- [===[
self:registerJob("pRect.copy()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=8, y=16, w=24, h=32}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("copy XYWH", pRect.copy, a, b)
		self:isEqual(b.x, 8)
		self:isEqual(b.y, 16)
		self:isEqual(b.w, 24)
		self:isEqual(b.h, 32)
		--]]
	end
	--]====]

	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.copy, false, {x=0, y=0, w=0, h=0})
		self:expectLuaError("arg 2 bad type", pRect.copy, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]

	-- Test the '_checkRectangle' assertion.
	-- [====[
	do
		local dummy = {x=0, y=0, w=0, h=0}
		self:expectLuaError("Rectangle, empty table", pRect.copy, {}, dummy)
		self:expectLuaError("Rectangle, bad 'x'", pRect.copy, {x=false, y=0, w=0, h=0}, dummy)
		self:expectLuaError("Rectangle, bad 'y'", pRect.copy, {x=0, y={}, w=0, h=0}, dummy)
		self:expectLuaError("Rectangle, bad 'w'", pRect.copy, {x=0, y=0, w=0/0, h=0}, dummy)
		self:expectLuaError("Rectangle, bad 'h'", pRect.copy, {x=0, y=0, w=0, h=function() end}, dummy)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expand", pRect.expand)


-- [===[
self:registerJob("pRect.expand()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left, top sides", pRect.expand, r, 2, 2, 0, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom, right sides", pRect.expand, r, 0, 0, 2, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge all sides", pRect.expand, r, 2, 2, 2, 2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink left, top sides", pRect.expand, r, -2, -2, 0, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink bottom, right sides", pRect.expand, r, 0, 0, -2, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink all sides", pRect.expand, r, -2, -2, -2, -2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expand, false, 0, 0, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.expand, {x=0, y=0, w=0, h=0}, false, 0, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.expand, {x=0, y=0, w=0, h=0}, 0, false, 0, 0)
		self:expectLuaError("arg 4 bad type", pRect.expand, {x=0, y=0, w=0, h=0}, 0, 0, false, 0)
		self:expectLuaError("arg 5 bad type", pRect.expand, {x=0, y=0, w=0, h=0}, 0, 0, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduce", pRect.reduce)


-- [===[
self:registerJob("pRect.reduce()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink left, top sides", pRect.reduce, r, 2, 2, 0, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink bottom, right sides", pRect.reduce, r, 0, 0, 2, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink all sides", pRect.reduce, r, 2, 2, 2, 2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left, top sides", pRect.reduce, r, -2, -2, 0, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom, right sides", pRect.reduce, r, 0, 0, -2, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge all sides", pRect.reduce, r, -2, -2, -2, -2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduce, false, 0, 0, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduce, {x=0, y=0, w=0, h=0}, false, 0, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.reduce, {x=0, y=0, w=0, h=0}, 0, false, 0, 0)
		self:expectLuaError("arg 4 bad type", pRect.reduce, {x=0, y=0, w=0, h=0}, 0, 0, false, 0)
		self:expectLuaError("arg 5 bad type", pRect.reduce, {x=0, y=0, w=0, h=0}, 0, 0, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandT", pRect.expandT)


-- [===[
self:registerJob("pRect.expandT()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=2, y1=2, x2=0, y2=0}
		self:expectLuaReturn("enlarge left, top sides", pRect.expandT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=0, y1=0, x2=2, y2=2}
		self:expectLuaReturn("enlarge bottom, right sides", pRect.expandT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=2, y1=2, x2=2, y2=2}
		self:expectLuaReturn("enlarge all sides", pRect.expandT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=-2, y1=-2, x2=0, y2=0}
		self:expectLuaReturn("shrink left, top sides", pRect.expandT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=0, y1=0, x2=-2, y2=-2}
		self:expectLuaReturn("shrink bottom, right sides", pRect.expandT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=-2, y1=-2, x2=-2, y2=-2}
		self:expectLuaReturn("shrink all sides", pRect.expandT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandT, {x=0, y=0, w=0, h=0}, false)
		self:expectLuaError("arg 2 bad SideDelta", pRect.expandT, false, {x1=0, y1=0, x2=0, y2=0})

		-- Test the '_checkSideDelta' assertion.
		self:expectLuaError("SideDelta bad x1", pRect.expandT, {x=0, y=0, w=0, h=0}, {x1=false, y1=0, x2=0, y2=0})
		self:expectLuaError("SideDelta bad y1", pRect.expandT, {x=0, y=0, w=0, h=0}, {x1=0, y1=false, x2=0, y2=0})
		self:expectLuaError("SideDelta bad x2", pRect.expandT, {x=0, y=0, w=0, h=0}, {x1=0, y1=0, x2=false, y2=0})
		self:expectLuaError("SideDelta bad y2", pRect.expandT, {x=0, y=0, w=0, h=0}, {x1=0, y1=0, x2=0, y2=false})
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceT", pRect.reduceT)


-- [===[
self:registerJob("pRect.reduceT()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=-2, y1=-2, x2=0, y2=0}
		self:expectLuaReturn("enlarge left, top sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=0, y1=0, x2=-2, y2=-2}
		self:expectLuaReturn("enlarge bottom, right sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=-2, y1=-2, x2=-2, y2=-2}
		self:expectLuaReturn("enlarge all sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=2, y1=2, x2=0, y2=0}
		self:expectLuaReturn("shrink left, top sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=0, y1=0, x2=2, y2=2}
		self:expectLuaReturn("shrink bottom, right sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		local cd = {x1=2, y1=2, x2=2, y2=2}
		self:expectLuaReturn("shrink all sides", pRect.reduceT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceT, {x=0, y=0, w=0, h=0}, false)
		self:expectLuaError("arg 2 bad SideDelta", pRect.reduceT, false, {x1=0, y1=0, x2=0, y2=0})
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandHorizontal", pRect.expandHorizontal)


-- [===[
self:registerJob("pRect.expandHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left side", pRect.expandHorizontal, r, 2, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge right side", pRect.expandHorizontal, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge both sides", pRect.expandHorizontal, r, 2, 2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce left side", pRect.expandHorizontal, r, -2, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce right side", pRect.expandHorizontal, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce both sides", pRect.expandHorizontal, r, -2, -2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandHorizontal, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandHorizontal, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.expandHorizontal, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceHorizontal", pRect.reduceHorizontal)


-- [===[
self:registerJob("pRect.reduceHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink left side", pRect.reduceHorizontal, r, 2, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink right side", pRect.reduceHorizontal, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink both sides", pRect.reduceHorizontal, r, 2, 2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 28)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left side", pRect.reduceHorizontal, r, -2, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge right side", pRect.reduceHorizontal, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge both sides", pRect.reduceHorizontal, r, -2, -2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 36)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceHorizontal, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceHorizontal, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.reduceHorizontal, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandVertical", pRect.expandVertical)


-- [===[
self:registerJob("pRect.expandVertical()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge top side", pRect.expandVertical, r, 2, 0)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom side", pRect.expandVertical, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge both sides", pRect.expandVertical, r, 2, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce top side", pRect.expandVertical, r, -2, 0)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce bottom side", pRect.expandVertical, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce both sides", pRect.expandVertical, r, -2, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandVertical, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandVertical, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.expandVertical, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceVertical", pRect.reduceVertical)


-- [===[
self:registerJob("pRect.reduceVertical()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink top side", pRect.reduceVertical, r, 2, 0)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink bottom side", pRect.reduceVertical, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink both sides", pRect.reduceVertical, r, 2, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge top side", pRect.reduceVertical, r, -2, 0)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom side", pRect.reduceVertical, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge both sides", pRect.reduceVertical, r, -2, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceVertical, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceVertical, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.reduceVertical, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandLeft", pRect.expandLeft)


-- [===[
self:registerJob("pRect.expandLeft()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left side", pRect.expandLeft, r, 2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce left side", pRect.expandLeft, r, -2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandLeft, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandLeft, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceLeft", pRect.reduceLeft)


-- [===[
self:registerJob("pRect.reduceLeft()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink left side", pRect.reduceLeft, r, 2)
		self:isEqual(r.x, 2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge left side", pRect.reduceLeft, r, -2)
		self:isEqual(r.x, -2)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceLeft, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceLeft, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandRight", pRect.expandRight)


-- [===[
self:registerJob("pRect.expandRight()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge right side", pRect.expandRight, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce right side", pRect.expandRight, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandRight, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandRight, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceRight", pRect.reduceRight)


-- [===[
self:registerJob("pRect.reduceRight()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink right side", pRect.reduceRight, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 30)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge right side", pRect.reduceRight, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 34)
		self:isEqual(r.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceRight, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceRight, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandTop", pRect.expandTop)


-- [===[
self:registerJob("pRect.expandTop()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge top side", pRect.expandTop, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce top side", pRect.expandTop, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandTop, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandTop, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceTop", pRect.reduceTop)


-- [===[
self:registerJob("pRect.reduceTop()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink top side", pRect.reduceTop, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge top side", pRect.reduceTop, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, -2)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceTop, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceTop, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.expandBottom", pRect.expandBottom)


-- [===[
self:registerJob("pRect.expandBottom()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom side", pRect.expandBottom, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("reduce bottom side", pRect.expandBottom, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.expandBottom, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.expandBottom, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.reduceBottom", pRect.reduceBottom)


-- [===[
self:registerJob("pRect.reduceBottom()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("shrink bottom side", pRect.reduceBottom, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, y=0, w=32, h=32}
		self:expectLuaReturn("enlarge bottom side", pRect.reduceBottom, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.y, 0)
		self:isEqual(r.w, 32)
		self:isEqual(r.h, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.reduceBottom, false, 0)
		self:expectLuaError("arg 2 bad type", pRect.reduceBottom, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.splitLeft", pRect.splitLeft)


-- [===[
self:registerJob("pRect.splitLeft()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, y=0, w=32, h=32}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split left", pRect.splitLeft, a, b, 8)

		self:isEqual(a.x, 8)
		self:isEqual(a.y, 0)
		self:isEqual(a.w, 24)
		self:isEqual(a.h, 32)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 8)
		self:isEqual(b.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.splitLeft, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.splitLeft, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.splitLeft, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.splitRight", pRect.splitRight)


-- [===[
self:registerJob("pRect.splitRight()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, y=0, w=32, h=32}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split right", pRect.splitRight, a, b, 8)

		self:isEqual(a.x, 0)
		self:isEqual(a.y, 0)
		self:isEqual(a.w, 24)
		self:isEqual(a.h, 32)

		self:isEqual(b.x, 24)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 8)
		self:isEqual(b.h, 32)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.splitRight, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.splitRight, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.splitRight, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.splitTop", pRect.splitTop)


-- [===[
self:registerJob("pRect.splitTop()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, y=0, w=32, h=32}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split top", pRect.splitTop, a, b, 8)

		self:isEqual(a.x, 0)
		self:isEqual(a.y, 8)
		self:isEqual(a.w, 32)
		self:isEqual(a.h, 24)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 32)
		self:isEqual(b.h, 8)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.splitTop, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.splitTop, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.splitTop, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.splitBottom", pRect.splitBottom)


-- [===[
self:registerJob("pRect.splitBottom()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, y=0, w=32, h=32}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split bottom", pRect.splitBottom, a, b, 8)

		self:isEqual(a.x, 0)
		self:isEqual(a.y, 0)
		self:isEqual(a.w, 32)
		self:isEqual(a.h, 24)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 24)
		self:isEqual(b.w, 32)
		self:isEqual(b.h, 8)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.splitBottom, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.splitBottom, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.splitBottom, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.split", pRect.split)


-- [===[
self:registerJob("pRect.split()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split left", pRect.split, a, b, "left", 4)

		self:isEqual(a.x, 14)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 16)
		self:isEqual(a.h, 20)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 4)
		self:isEqual(b.h, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split right", pRect.split, a, b, "right", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 16)
		self:isEqual(a.h, 20)

		self:isEqual(b.x, 26)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 4)
		self:isEqual(b.h, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split top", pRect.split, a, b, "top", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 14)
		self:isEqual(a.w, 20)
		self:isEqual(a.h, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 20)
		self:isEqual(b.h, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split bottom", pRect.split, a, b, "bottom", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 20)
		self:isEqual(a.h, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 26)
		self:isEqual(b.w, 20)
		self:isEqual(b.h, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.split, false, {x=0, y=0, w=0, h=0}, "left", 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.split, {x=0, y=0, w=0, h=0}, false, "left", 0)
		self:expectLuaError("arg 3 bad type/NamedMap key", pRect.split, {x=0, y=0, w=0, h=0}, "sideways", 0)
		self:expectLuaError("arg 4 bad type", pRect.split, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, "left", false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.splitOrOverlay", pRect.splitOrOverlay)


-- [===[
self:registerJob("pRect.splitOrOverlay()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split left", pRect.splitOrOverlay, a, b, "left", 4)

		self:isEqual(a.x, 14)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 16)
		self:isEqual(a.h, 20)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 4)
		self:isEqual(b.h, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split right", pRect.splitOrOverlay, a, b, "right", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 16)
		self:isEqual(a.h, 20)

		self:isEqual(b.x, 26)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 4)
		self:isEqual(b.h, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split top", pRect.splitOrOverlay, a, b, "top", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 14)
		self:isEqual(a.w, 20)
		self:isEqual(a.h, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 20)
		self:isEqual(b.h, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("split bottom", pRect.splitOrOverlay, a, b, "bottom", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 20)
		self:isEqual(a.h, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 26)
		self:isEqual(b.w, 20)
		self:isEqual(b.h, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, y=10, w=20, h=20}
		local b = {x=0, y=0, w=0, h=0}
		self:expectLuaReturn("overlay", pRect.splitOrOverlay, a, b, "overlay", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.y, 10)
		self:isEqual(a.w, 20)
		self:isEqual(a.h, 20)

		self:isEqual(b.x, 10)
		self:isEqual(b.y, 10)
		self:isEqual(b.w, 20)
		self:isEqual(b.h, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.splitOrOverlay, false, {x=0, y=0, w=0, h=0}, "left", 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.splitOrOverlay, {x=0, y=0, w=0, h=0}, false, "left", 0)
		self:expectLuaError("arg 3 bad type/NamedMap key", pRect.splitOrOverlay, {x=0, y=0, w=0, h=0}, "sideways", 0)
		self:expectLuaError("arg 4 bad type", pRect.splitOrOverlay, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, "left", false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeInner", pRect.placeInner)


-- [===[
self:registerJob("pRect.placeInner()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner, top-left", pRect.placeInner, a, b, 0.0, 0.0)

		self:isEqual(b.x, 100)
		self:isEqual(b.y, 100)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner, bottom-right", pRect.placeInner, a, b, 1.0, 1.0)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner, center", pRect.placeInner, a, b, 0.5, 0.5)

		self:isEqual(b.x, 125)
		self:isEqual(b.y, 125)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeInner, false, {x=0, y=0, w=0, h=0}, 0, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeInner, {x=0, y=0, w=0, h=0}, false, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeInner, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 4 bad type", pRect.placeInner, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeInnerHorizontal", pRect.placeInnerHorizontal)


-- [===[
self:registerJob("pRect.placeInnerHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-horizontal, left", pRect.placeInnerHorizontal, a, b, 0.0)

		self:isEqual(b.x, 100)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-horizontal, right", pRect.placeInnerHorizontal, a, b, 1.0)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-horizontal, center", pRect.placeInnerHorizontal, a, b, 0.5)

		self:isEqual(b.x, 125)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeInnerHorizontal, false, {x=0, y=0, w=0, h=0}, 0, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeInnerHorizontal, {x=0, y=0, w=0, h=0}, false, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeInnerHorizontal, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeInnerVertical", pRect.placeInnerVertical)


-- [===[
self:registerJob("pRect.placeInnerVertical()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-vertical, top", pRect.placeInnerVertical, a, b, 0.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 100)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-vertical, bottom", pRect.placeInnerVertical, a, b, 1.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner, center", pRect.placeInnerVertical, a, b, 0.5)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 125)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeInnerVertical, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeInnerVertical, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeInnerVertical, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeMidpoint", pRect.placeMidpoint)


-- [===[
self:registerJob("pRect.placeMidpoint()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point, top-left", pRect.placeMidpoint, a, b, 0.0, 0.0)

		self:isEqual(b.x, 75)
		self:isEqual(b.y, 75)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point, bottom-right", pRect.placeMidpoint, a, b, 1.0, 1.0)

		self:isEqual(b.x, 225)
		self:isEqual(b.y, 225)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner, center", pRect.placeMidpoint, a, b, 0.5, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeMidpoint, false, {x=0, y=0, w=0, h=0}, 0, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeMidpoint, {x=0, y=0, w=0, h=0}, false, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeMidpoint, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 4 bad type", pRect.placeMidpoint, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeMidpointHorizontal", pRect.placeMidpointHorizontal)


-- [===[
self:registerJob("pRect.placeMidpointHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point-horizontal, left", pRect.placeMidpointHorizontal, a, b, 0.0)

		self:isEqual(b.x, 75)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point-horizontal, right", pRect.placeMidpointHorizontal, a, b, 1.0)

		self:isEqual(b.x, 225)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-horizontal, center", pRect.placeMidpointHorizontal, a, b, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeMidpointHorizontal, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeMidpointHorizontal, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeMidpointHorizontal, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeMidpointVertical", pRect.placeMidpointVertical)


-- [===[
self:registerJob("pRect.placeMidpointVertical()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point-vertical, top", pRect.placeMidpointVertical, a, b, 0.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 75)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place point-vertical, bottom", pRect.placeMidpointVertical, a, b, 1.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 225)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place inner-vertical, center", pRect.placeMidpointVertical, a, b, 0.5)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeMidpointVertical, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeMidpointVertical, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeMidpointVertical, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeOuter", pRect.placeOuter)


-- [===[
self:registerJob("pRect.placeOuter()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer, top-left", pRect.placeOuter, a, b, 0.0, 0.0)

		self:isEqual(b.x, 50)
		self:isEqual(b.y, 50)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer, bottom-right", pRect.placeOuter, a, b, 1.0, 1.0)

		self:isEqual(b.x, 250)
		self:isEqual(b.y, 250)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer, center", pRect.placeOuter, a, b, 0.5, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeOuter, false, {x=0, y=0, w=0, h=0}, 0, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeOuter, {x=0, y=0, w=0, h=0}, false, 0, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeOuter, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 4 bad type", pRect.placeOuter, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeOuterHorizontal", pRect.placeOuterHorizontal)


-- [===[
self:registerJob("pRect.placeOuterHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-horizontal, left", pRect.placeOuterHorizontal, a, b, 0.0)

		self:isEqual(b.x, 50)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-horizontal, right", pRect.placeOuterHorizontal, a, b, 1.0)

		self:isEqual(b.x, 250)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-horizontal, center", pRect.placeOuterHorizontal, a, b, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeOuterHorizontal, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeOuterHorizontal, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeOuterHorizontal, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.placeOuterVertical", pRect.placeOuterVertical)


-- [===[
self:registerJob("pRect.placeOuterVertical()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-vertical, top", pRect.placeOuterVertical, a, b, 0.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 50)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-vertical, bottom", pRect.placeOuterVertical, a, b, 1.0)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 250)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("place outer-vertical, center", pRect.placeOuterVertical, a, b, 0.5)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 150)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.placeOuterVertical, false, {x=0, y=0, w=0, h=0}, 0)
		self:expectLuaError("arg 2 bad Rectangle", pRect.placeOuterVertical, {x=0, y=0, w=0, h=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pRect.placeOuterVertical, {x=0, y=0, w=0, h=0}, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.center", pRect.center)


-- [===[
self:registerJob("pRect.center()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("center", pRect.center, a, b)

		self:isEqual(b.x, 125)
		self:isEqual(b.y, 125)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.center, false, {x=0, y=0, w=0, h=0})
		self:expectLuaError("arg 2 bad Rectangle", pRect.center, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.centerHorizontal", pRect.centerHorizontal)


-- [===[
self:registerJob("pRect.centerHorizontal()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("centerHorizontal", pRect.centerHorizontal, a, b)

		self:isEqual(b.x, 125)
		self:isEqual(b.y, 0)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.centerHorizontal, false, {x=0, y=0, w=0, h=0})
		self:expectLuaError("arg 2 bad Rectangle", pRect.centerHorizontal, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pRect.centerVertical", pRect.centerVertical)


-- [===[
self:registerJob("pRect.centerVertical()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, y=100, w=100, h=100}
		local b = {x=0, y=0, w=50, h=50}
		self:expectLuaReturn("centerVertical", pRect.centerVertical, a, b)

		self:isEqual(b.x, 0)
		self:isEqual(b.y, 125)
		self:isEqual(b.w, 50)
		self:isEqual(b.h, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.centerVertical, false, {x=0, y=0, w=0, h=0})
		self:expectLuaError("arg 2 bad Rectangle", pRect.centerVertical, {x=0, y=0, w=0, h=0}, false)
	end
	--]====]
end
)
--]===]


--M.pointOverlap(r, x, y)
self:registerFunction("pRect.pointOverlap", pRect.pointOverlap)


-- [===[
self:registerJob("pRect.pointOverlap()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, y=0, w=5, h=5}
		local res1 = self:expectLuaReturn("point in rectangle", pRect.pointOverlap, a, 2, 2)
		self:isEqual(res1, true)

		local res2 = self:expectLuaReturn("point not in rectangle", pRect.pointOverlap, a, 2, 500)
		self:isEqual(res2, false)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad Rectangle", pRect.pointOverlap, false, 1, 1)
		self:expectLuaError("arg 2 bad type", pRect.pointOverlap, {x=0, y=0, w=5, h=5}, false, 1)
		self:expectLuaError("arg 3 bad type", pRect.pointOverlap, {x=0, y=0, w=5, h=5}, 1, false)
	end
	--]====]
end
)
--]===]


self:runJobs()
