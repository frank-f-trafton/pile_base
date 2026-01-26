-- Test: pile_math.lua
-- VERSION: 2.023


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pMath = require(PATH .. "pile_math")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Math", cli_verbosity)


self:registerFunction("pMath.clamp", pMath.clamp)


-- [===[
self:registerJob("pMath.clamp", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Clamp minimum", pMath.clamp, 1, 10, 100)
		self:isEqual(output, 10)
		--]]

		-- [[
		local output = self:expectLuaReturn("Clamp maximum", pMath.clamp, 1000, 10, 100)
		self:isEqual(output, 100)
		--]]

		-- [[
		local output = self:expectLuaReturn("Input is within range", pMath.clamp, 50, 10, 100)
		self:isEqual(output, 50)
		--]]

		-- [[
		local output = self:expectLuaReturn("Min is greater than max: return min", pMath.clamp, 5, 100, 10)
		self:isEqual(output, 100)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.dist", pMath.dist)


-- [===[
self:registerJob("pMath.dist", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("zero distance", pMath.dist, 0, 0, 0, 0)
		self:isEqual(output, 0)
		--]]

		-- [[
		local output = self:expectLuaReturn("100 horizontal", pMath.dist, 0, 0, 100, 0)
		self:isEqual(output, 100)
		--]]

		-- [[
		local output = self:expectLuaReturn("-100 horizontal", pMath.dist, 0, 0, -100, 0)
		self:isEqual(output, 100)
		--]]

		-- [[
		local output = self:expectLuaReturn("100 vertical", pMath.dist, 0, 0, 0, 100)
		self:isEqual(output, 100)
		--]]

		-- [[
		local output = self:expectLuaReturn("-100 vertical", pMath.dist, 0, 0, 0, -100)
		self:isEqual(output, 100)
		--]]

		-- [[
		local output = self:expectLuaReturn("3 horizontal, 8 vertical (approximate, to 5 decimal points)", pMath.dist, 0, 0, 3, 8)
		self:isEqual(string.format("%.5f", output), "8.54400") -- 8.5440037453175
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.distSq", pMath.distSq)


-- [===[
self:registerJob("pMath.distSq", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("zero distance", pMath.distSq, 0, 0, 0, 0)
		self:isEqual(output, 0)
		--]]

		-- [[
		local output = self:expectLuaReturn("100 horizontal", pMath.distSq, 0, 0, 100, 0)
		self:isEqual(output, 100*100)
		--]]

		-- [[
		local output = self:expectLuaReturn("-100 horizontal", pMath.distSq, 0, 0, -100, 0)
		self:isEqual(output, 100*100)
		--]]

		-- [[
		local output = self:expectLuaReturn("100 vertical", pMath.distSq, 0, 0, 0, 100)
		self:isEqual(output, 100*100)
		--]]

		-- [[
		local output = self:expectLuaReturn("-100 vertical", pMath.distSq, 0, 0, 0, -100)
		self:isEqual(output, 100*100)
		--]]

		-- [[
		local dist1 = pMath.distSq(10,10, 90,90)
		local dist2 = pMath.distSq(9.999,10, 90,90)
		self:print(4, "compare two distances")
		self:isEqual(dist1 < dist2, true)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.lerp", pMath.lerp)


-- [===[
self:registerJob("pMath.lerp", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Lerp 0%", pMath.lerp, 0, 10, 0.0)
		self:isEqual(output, 0)
		--]]

		-- [[
		local output = self:expectLuaReturn("Lerp 50%", pMath.lerp, 0, 10, 0.5)
		self:isEqual(output, 5)
		--]]

		-- [[
		local output = self:expectLuaReturn("Lerp 100%", pMath.lerp, 0, 10, 1.0)
		self:isEqual(output, 10)
		--]]

		-- [[
		local output = self:expectLuaReturn("This lerp function does not clamp the input", pMath.lerp, 0, 10, 2.0)
		self:isEqual(output, 20)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.roundInf", pMath.roundInf)


-- [===[
self:registerJob("pMath.roundInf", function(self)
	-- [====[
	do
		local output

		-- [[
		output = self:expectLuaReturn("round up, positive", pMath.roundInf, 0.5)
		self:isEqual(output, 1.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, positive", pMath.roundInf, 0.4)
		self:isEqual(output, 0.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, negative", pMath.roundInf, -0.5)
		self:isEqual(output, -1.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round up, negative", pMath.roundInf, -0.4)
		self:isEqual(output, 0.0)
		--]]
	end
	--]====]
end
)
--]===]




self:registerFunction("pMath.roundInfIncrement", pMath.roundInfIncrement)


-- [===[
self:registerJob("pMath.roundInfIncrement", function(self)
	-- [====[
	do
		local output

		-- [[
		output = self:expectLuaReturn("round up, positive (incr 1)", pMath.roundInfIncrement, 0.5, 1.0)
		self:isEqual(output, 1.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, positive (incr 1)", pMath.roundInfIncrement, 0.4, 1.0)
		self:isEqual(output, 0.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, negative (incr 1)", pMath.roundInfIncrement, -0.5, 1.0)
		self:isEqual(output, -1.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round up, negative (incr 1)", pMath.roundInfIncrement, -0.4, 1.0)
		self:isEqual(output, 0.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round up, positive (incr 4)", pMath.roundInfIncrement, 2.5, 4.0)
		self:isEqual(output, 4.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, positive (incr 4)", pMath.roundInfIncrement, 1.4, 4.0)
		self:isEqual(output, 0.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round down, negative (incr 4)", pMath.roundInfIncrement, -3.5, 4.0)
		self:isEqual(output, -4.0)
		--]]

		-- [[
		output = self:expectLuaReturn("round up, negative (incr 4)", pMath.roundInfIncrement, -1.5, 4.0)
		self:isEqual(output, 0.0)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.sign", pMath.sign)


-- [===[
self:registerJob("pMath.sign", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Negative sign", pMath.sign, -100)
		self:isEqual(output, -1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Zero", pMath.sign, 0)
		self:isEqual(output, 0)
		--]]

		-- [[
		local output = self:expectLuaReturn("Positive sign", pMath.sign, 100)
		self:isEqual(output, 1)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.signN", pMath.signN)


-- [===[
self:registerJob("pMath.signN", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Negative sign", pMath.signN, -100)
		self:isEqual(output, -1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Zero (treat as negative)", pMath.signN, 0)
		self:isEqual(output, -1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Positive sign", pMath.signN, 100)
		self:isEqual(output, 1)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.signN", pMath.signN)


-- [===[
self:registerJob("pMath.signP", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Negative sign", pMath.signP, -100)
		self:isEqual(output, -1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Zero (treat as positive)", pMath.signP, 0)
		self:isEqual(output, 1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Positive sign", pMath.signP, 100)
		self:isEqual(output, 1)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pMath.signN", pMath.signN)


-- [===[
self:registerJob("pMath.wrap1", function(self)
	-- [====[
	do
		-- [[
		local output = self:expectLuaReturn("Overflow", pMath.wrap1, 6, 5)
		self:isEqual(output, 1)
		--]]

		-- [[
		local output = self:expectLuaReturn("Underflow", pMath.wrap1, 0, 5)
		self:isEqual(output, 5)
		--]]

		-- [[
		local output = self:expectLuaReturn("Within range", pMath.wrap1, 3, 5)
		self:isEqual(output, 3)
		--]]
	end
	--]====]
end
)
--]===]


self:runJobs()
