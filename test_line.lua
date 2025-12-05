-- Test: pile_line.lua
-- v2.010


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")


--[[
This test will run with pLine's optional assertions enabled. To do that, we need
to load the source file as a string and ensure that the assertions aren't
commented out.
--]]
local pLine
do
	local f, err = io.open("pile_line.lua", "r")
	if not f then
		error(err)
	end
	local source_str = f:read("*a")
	if not source_str then
		error("couldn't read source file 'pile_line.lua'.")
	end
	f:close()

	source_str = source_str:gsub("%-%-%[%[ASSERT", "-- [[ASSERT")

	local _load = rawget(_G, "loadstring") or rawget(_G, "load")

	pLine = assert(_load(source_str, "(pLine source)"))(...)
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


local self = errTest.new("PILE Line", cli_verbosity)


self:registerFunction("pLine.set", pLine.set)


-- [===[
self:registerJob("pLine.set", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=0}
		self:expectLuaReturn("set XW", pLine.set, r, 4, 8)
		self:isEqual(r.x, 4)
		self:isEqual(r.w, 8)
		--]]
	end
	--]====]

	-- [====[
	self:expectLuaError("LineSegment, bad type", pLine.set, false, 4, 8)
	self:expectLuaError("arg 2 bad type", pLine.set, {x=0, w=0}, false, 8)
	self:expectLuaError("arg 3 bad type", pLine.set, {x=0, w=0}, 4, false)
	--]====]
end
)
--]===]


self:registerFunction("pLine.copy", pLine.copy)


-- [===[
self:registerJob("pLine.copy()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=8, w=24}
		local b = {x=0, w=0}
		self:expectLuaReturn("copy XYWH", pLine.copy, a, b)
		self:isEqual(b.x, 8)
		self:isEqual(b.w, 24)
		--]]
	end
	--]====]

	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.copy, false, {x=0, w=0})
		self:expectLuaError("arg 2 bad type", pLine.copy, {x=0, w=0}, false)
	end
	--]====]

	-- Test the '_checkLine' assertion.
	-- [====[
	do
		local dummy = {x=0, w=0}
		self:expectLuaError("LineSegment, empty table", pLine.copy, {}, dummy)
		self:expectLuaError("LineSegment, bad 'x'", pLine.copy, {x=false, w=0}, dummy)
		self:expectLuaError("LineSegment, bad 'w'", pLine.copy, {x=0, w=0/0}, dummy)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.expand", pLine.expand)


-- [===[
self:registerJob("pLine.expand()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge left side", pLine.expand, r, 2, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge right side", pLine.expand, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge both sides", pLine.expand, r, 2, 2)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink left side", pLine.expand, r, -2, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink right side", pLine.expand, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink both sides", pLine.expand, r, -2, -2)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.expand, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pLine.expand, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.expand, {x=0, w=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.reduce", pLine.reduce)


-- [===[
self:registerJob("pLine.reduce()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink left side", pLine.reduce, r, 2, 0)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink right side", pLine.reduce, r, 0, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink both sides", pLine.reduce, r, 2, 2)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge left side", pLine.reduce, r, -2, 0)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge right side", pLine.reduce, r, 0, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge both sides", pLine.reduce, r, -2, -2)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.reduce, false, 0, 0)
		self:expectLuaError("arg 2 bad type", pLine.reduce, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.reduce, {x=0, w=0}, 0, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.expandT", pLine.expandT)


-- [===[
self:registerJob("pLine.expandT()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=2, x2=0}
		self:expectLuaReturn("enlarge left side", pLine.expandT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=0, x2=2}
		self:expectLuaReturn("enlarge right side", pLine.expandT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=2, x2=2}
		self:expectLuaReturn("enlarge both sides", pLine.expandT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=-2, x2=0}
		self:expectLuaReturn("shrink left side", pLine.expandT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=0, x2=-2}
		self:expectLuaReturn("shrink bottom, right sides", pLine.expandT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=-2, x2=-2}
		self:expectLuaReturn("shrink all sides", pLine.expandT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.expandT, false, {x1=0, x2=0})
		self:expectLuaError("arg 2 bad SideDelta", pLine.expandT, {x=0, w=0}, false)

		-- Test the '_checkSideDelta' assertion.
		self:expectLuaError("SideDelta bad x1", pLine.expandT, {x=0, w=0}, {x1=false, x2=0})
		self:expectLuaError("SideDelta bad x2", pLine.expandT, {x=0, w=0}, {x1=0, x2=false})
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.reduceT", pLine.reduceT)


-- [===[
self:registerJob("pLine.reduceT()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=-2, x2=0}
		self:expectLuaReturn("enlarge left side", pLine.reduceT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=0, x2=-2}
		self:expectLuaReturn("enlarge right side", pLine.reduceT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=-2, x2=-2}
		self:expectLuaReturn("enlarge both sides", pLine.reduceT, r, cd)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 36)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=2, x2=0}
		self:expectLuaReturn("shrink left side", pLine.reduceT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=0, x2=2}
		self:expectLuaReturn("shrink right side", pLine.reduceT, r, cd)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		local cd = {x1=2, x2=2}
		self:expectLuaReturn("shrink both sides", pLine.reduceT, r, cd)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 28)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.reduceT, false, {x=0, w=0})
		self:expectLuaError("arg 2 bad SideDelta", pLine.reduceT, {x1=0, x2=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.expandLeft", pLine.expandLeft)


-- [===[
self:registerJob("pLine.expandLeft()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge left side", pLine.expandLeft, r, 2)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("reduce left side", pLine.expandLeft, r, -2)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.expandLeft, false, 0)
		self:expectLuaError("arg 2 bad type", pLine.expandLeft, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.reduceLeft", pLine.reduceLeft)


-- [===[
self:registerJob("pLine.reduceLeft()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink left side", pLine.reduceLeft, r, 2)
		self:isEqual(r.x, 2)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge left side", pLine.reduceLeft, r, -2)
		self:isEqual(r.x, -2)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.reduceLeft, false, 0)
		self:expectLuaError("arg 2 bad type", pLine.reduceLeft, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.expandRight", pLine.expandRight)


-- [===[
self:registerJob("pLine.expandRight()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge right side", pLine.expandRight, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("reduce right side", pLine.expandRight, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.expandRight, false, 0)
		self:expectLuaError("arg 2 bad type", pLine.expandRight, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.reduceRight", pLine.reduceRight)


-- [===[
self:registerJob("pLine.reduceRight()", function(self)
	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("shrink right side", pLine.reduceRight, r, 2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 30)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local r = {x=0, w=32}
		self:expectLuaReturn("enlarge right side", pLine.reduceRight, r, -2)
		self:isEqual(r.x, 0)
		self:isEqual(r.w, 34)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.reduceRight, false, 0)
		self:expectLuaError("arg 2 bad type", pLine.reduceRight, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.splitLeft", pLine.splitLeft)


-- [===[
self:registerJob("pLine.splitLeft()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, w=32}
		local b = {x=0, w=0}
		self:expectLuaReturn("split left", pLine.splitLeft, a, b, 8)

		self:isEqual(a.x, 8)
		self:isEqual(a.w, 24)

		self:isEqual(b.x, 0)
		self:isEqual(b.w, 8)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.splitLeft, false, {x=0, w=0}, 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.splitLeft, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.splitLeft, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.splitRight", pLine.splitRight)


-- [===[
self:registerJob("pLine.splitRight()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, w=32}
		local b = {x=0, w=0}
		self:expectLuaReturn("split right", pLine.splitRight, a, b, 8)

		self:isEqual(a.x, 0)
		self:isEqual(a.w, 24)

		self:isEqual(b.x, 24)
		self:isEqual(b.w, 8)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.splitRight, false, {x=0, w=0}, 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.splitRight, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.splitRight, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.split", pLine.split)


-- [===[
self:registerJob("pLine.split()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=10, w=20}
		local b = {x=0, w=0}
		self:expectLuaReturn("split left", pLine.split, a, b, "left", 4)

		self:isEqual(a.x, 14)
		self:isEqual(a.w, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.w, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, w=20}
		local b = {x=0, w=0}
		self:expectLuaReturn("split right", pLine.split, a, b, "right", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.w, 16)

		self:isEqual(b.x, 26)
		self:isEqual(b.w, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.split, false, {x=0, w=0}, "left", 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.split, {x=0, w=0}, false, "left", 0)
		self:expectLuaError("arg 3 bad type/NamedMap key", pLine.split, {x=0, w=0}, "roundfully", 0)
		self:expectLuaError("arg 4 bad type", pLine.split, {x=0, w=0}, {x=0, w=0}, "left", false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.splitOrOverlay", pLine.splitOrOverlay)


-- [===[
self:registerJob("pLine.splitOrOverlay()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=10, w=20}
		local b = {x=0, w=0}
		self:expectLuaReturn("split left", pLine.splitOrOverlay, a, b, "left", 4)

		self:isEqual(a.x, 14)
		self:isEqual(a.w, 16)

		self:isEqual(b.x, 10)
		self:isEqual(b.w, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, w=20}
		local b = {x=0, w=0}
		self:expectLuaReturn("split right", pLine.splitOrOverlay, a, b, "right", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.w, 16)

		self:isEqual(b.x, 26)
		self:isEqual(b.w, 4)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=10, w=20}
		local b = {x=0, w=0}
		self:expectLuaReturn("overlay", pLine.splitOrOverlay, a, b, "overlay", 4)

		self:isEqual(a.x, 10)
		self:isEqual(a.w, 20)

		self:isEqual(b.x, 10)
		self:isEqual(b.w, 20)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.splitOrOverlay, false, {x=0, w=0}, "left", 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.splitOrOverlay, {x=0, w=0}, false, "left", 0)
		self:expectLuaError("arg 3 bad type/NamedMap key", pLine.splitOrOverlay, {x=0, w=0}, "overneath", 0)
		self:expectLuaError("arg 4 bad type", pLine.splitOrOverlay, {x=0, w=0}, {x=0, w=0}, "left", false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.placeInner", pLine.placeInner)


-- [===[
self:registerJob("pLine.placeInner()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place inner, left", pLine.placeInner, a, b, 0.0)

		self:isEqual(b.x, 100)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place inner, right", pLine.placeInner, a, b, 1.0)

		self:isEqual(b.x, 150)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place inner, center", pLine.placeInner, a, b, 0.5)

		self:isEqual(b.x, 125)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.placeInner, false, {x=0, w=0}, 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.placeInner, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.placeInner, {x=0, w=0}, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.placeMidpoint", pLine.placeMidpoint)


-- [===[
self:registerJob("pLine.placeMidpoint()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place point, left", pLine.placeMidpoint, a, b, 0.0)

		self:isEqual(b.x, 75)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place point, right", pLine.placeMidpoint, a, b, 1.0)

		self:isEqual(b.x, 225)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place inner, center", pLine.placeMidpoint, a, b, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.placeMidpoint, false, {x=0, w=0}, 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.placeMidpoint, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.placeMidpoint, {x=0, w=0}, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.placeOuter", pLine.placeOuter)


-- [===[
self:registerJob("pLine.placeOuter()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place outer, left", pLine.placeOuter, a, b, 0.0)

		self:isEqual(b.x, 50)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place outer, right", pLine.placeOuter, a, b, 1.0)

		self:isEqual(b.x, 250)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("place outer, center", pLine.placeOuter, a, b, 0.5)

		self:isEqual(b.x, 150)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.placeOuter, false, {x=0, w=0}, 0)
		self:expectLuaError("arg 2 bad LineSegment", pLine.placeOuter, {x=0, w=0}, false, 0)
		self:expectLuaError("arg 3 bad type", pLine.placeOuter, {x=0, w=0}, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.center", pLine.center)


-- [===[
self:registerJob("pLine.center()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=0, w=50}
		self:expectLuaReturn("center", pLine.center, a, b)

		self:isEqual(b.x, 125)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.center, false, {x=0, w=0})
		self:expectLuaError("arg 2 bad LineSegment", pLine.center, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.flip", pLine.flip)


-- [===[
self:registerJob("pLine.flip()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=100, w=100}
		local b = {x=120, w=50}
		self:expectLuaReturn("flip", pLine.flip, a, b)

		self:isEqual(b.x, 130)
		self:isEqual(b.w, 50)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.flip, false, {x=0, w=0})
		self:expectLuaError("arg 2 bad LineSegment", pLine.flip, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.positionOverlap", pLine.positionOverlap)


-- [===[
self:registerJob("pLine.positionOverlap()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=0, w=5}
		local res1 = self:expectLuaReturn("position in LineSegment", pLine.positionOverlap, a, 2)
		self:isEqual(res1, true)

		local res2 = self:expectLuaReturn("position not in LineSegment", pLine.positionOverlap, a, 500)
		self:isEqual(res2, false)
		--]]
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.positionOverlap, false, 1)
		self:expectLuaError("arg 2 bad type", pLine.positionOverlap, {x=0, w=5}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.getBounds", pLine.getBounds)


-- [===[
self:registerJob("pLine.getBounds()", function(self)
	-- [====[
	do
		-- [[
		local a = {x=33, w=100}
		local b = {x=-100, w=50}
		local c = {x=200, w=5}
		local x1, x2 = self:expectLuaReturn("getBounds", pLine.getBounds, a, b, c)

		self:isEqual(x1, -100)
		self:isEqual(x2, 205)
		--]]
	end
	--]====]


	-- [====[
	do
		local x1, x2 = self:expectLuaReturn("accept no arguments", pLine.getBounds)
		self:isEqual(x1, 0)
		self:isEqual(x2, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad LineSegment", pLine.getBounds, false, {x=0, w=0})
		self:expectLuaError("arg 2 bad LineSegment", pLine.getBounds, {x=0, w=0}, false)
		self:expectLuaError("arg 3 (etc.)", pLine.getBounds, {x=0, w=0}, {x=0, w=0}, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pLine.getBoundsT", pLine.getBoundsT)


-- [===[
self:registerJob("pLine.getBoundsT()", function(self)
	-- [====[
	do
		-- [[
		local list = {
			{x=33, w=100},
			{x=-100, w=50},
			{x=200, w=5},
		}
		local x1, x2 = self:expectLuaReturn("getBoundsT", pLine.getBoundsT, list)

		self:isEqual(x1, -100)
		self:isEqual(x2, 205)
		--]]
	end
	--]====]


	-- [====[
	do
		local x1, x2 = self:expectLuaReturn("accept empty array", pLine.getBoundsT, {})
		self:isEqual(x1, 0)
		self:isEqual(x2, 0)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad type", pLine.getBoundsT, false)
		self:expectLuaError("arg 1 index 1 bad LineSegment", pLine.getBoundsT, {false})
		self:expectLuaError("arg 1 index 2 bad LineSegment (etc.)", pLine.getBoundsT, {{false}, {x=0, w=0}})
	end
	--]====]
end
)
--]===]


self:runJobs()
