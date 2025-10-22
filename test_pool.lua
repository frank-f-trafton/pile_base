-- Test: pile_pool.lua
-- v1.310


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pPool = require(PATH .. "pile_pool")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pPool", cli_verbosity)


self:registerFunction("pPool.new()", pPool.new)


-- [===[
self:registerJob("pPool.new()", function(self)
	-- [====[
	do
		local p = self:expectLuaReturn("bare minimum new pool stack", pPool.new)
		self:isEqual(getmetatable(p), pPool._mt_pool)
	end
	--]====]

	-- [====[
	do
		local function dummy() end
		local p = self:expectLuaReturn("new pool stack", pPool.new, dummy, dummy, 5)
		self:isEqual(getmetatable(p), pPool._mt_pool)
	end
	--]====]

	-- [====[
	do
		local function dummy() end
		self:expectLuaError("arg #1 bad type", pPool.new, {}, dummy, 5)
		self:expectLuaError("arg #2 bad type", pPool.new, dummy, {}, 5)
		self:expectLuaError("arg #3 bad type", pPool.new, dummy, dummy, {})
		self:expectLuaError("arg #3 reject NaN", pPool.new, dummy, dummy, 0/0)
	end
	--]====]
end
)
--]===]


self:registerFunction("Pool:pop()", pPool._mt_pool.pop)


-- [===[
self:registerJob("Pool:pop()", function(self)

	-- [====[
	do
		local p = pPool.new(nil, nil, 5)
		local r = self:expectLuaReturn("no 'popping' method: returns nothing", p.pop, p)
		self:isNil(r)
	end
	--]====]

	-- [====[
	do
		local function popping(r)
			if not r then r = {"foo"} end
			return r
		end
		local p = pPool.new(popping, nil, 5)
		local r = self:expectLuaReturn("with 'popping' method: return a default resource", p.pop, p)
		self:isEqual(r[1], "foo")
	end
	--]====]
end
)
--]===]


self:registerFunction("Pool:push()", pPool._mt_pool.push)


-- [===[
self:registerJob("Pool:push()", function(self)
	-- [====[
	do
		local p = pPool.new(nil, nil, 5)
		self:expectLuaReturn("no 'pushing' method: anything goes", p.push, p, "foobar")
		self:isEqual(p.stack[1], "foobar")
	end
	--]====]

	-- [====[
	do
		local p = pPool.new(nil, nil, 2)
		self:expectLuaReturn("push up to threshold 1/2", p.push, p, 1)
		self:expectLuaReturn("push up to threshold 2/2", p.push, p, 2)
		self:expectLuaReturn("push up to threshold 3/2", p.push, p, 3)
		self:isEqual(p.stack[1], 1)
		self:isEqual(p.stack[2], 2)
		self:isEqual(p.stack[3], nil)
	end
	--]====]

	-- [====[
	do
		local function pushing(r)
			if #r > 5 then return nil end
			return r
		end
		local p = pPool.new(nil, pushing, 100)
		self:expectLuaReturn("use 'pushing' to reject too-big arrays", p.push, p, {1, 2, 3, 4, 5, 6})
		self:isEqual(p.stack[1], nil)
	end
	--]====]

	-- [====[
	do
		local function pushing(r)
			if type(r) ~= "table" then error("expected table") end
			return r
		end
		local p = pPool.new(nil, pushing, 100)
		self:expectLuaReturn("use 'pushing' to check input 1/2", p.push, p, {})
		self:expectLuaError("use 'pushing' to check input 2/2", p.push, p, function() end)
	end
	--]====]
end
)
--]===]


self:registerFunction("Pool:setThreshold()", pPool._mt_pool.setThreshold)


-- [===[
self:registerJob("Pool:setThreshold()", function(self)

	-- [====[
	do
		local p = pPool.new()
		self:expectLuaReturn("normal behavior", p.setThreshold, p, 10)
		self:isEqual(p.threshold, 10)
	end
	--]====]


	-- [====[
	do
		local p = pPool.new()
		self:expectLuaError("arg 1 bad input", p.setThreshold, p, {})
		self:expectLuaError("arg 1 reject NaN", p.setThreshold, p, 0/0)
	end
	--]====]
end
)
--]===]


self:registerFunction("Pool:getThreshold()", pPool._mt_pool.getThreshold)


-- [===[
self:registerJob("Pool:getThreshold()", function(self)
	-- [====[
	do
		local p = pPool.new(nil, nil, 56789)
		local threshold = self:expectLuaReturn("normal behavior", p.getThreshold, p, 10)
		self:isEqual(threshold, 56789)
	end
	--]====]
end
)
--]===]


self:registerFunction("Pool:reduceStack()", pPool._mt_pool.reduceStack)


-- [===[
self:registerJob("Pool:reduceStack()", function(self)
	-- [====[
	do
		local p = pPool.new(nil, nil, 500)
		p:push(1)
		p:push(2)
		p:push(3)
		p:push(4)
		p:push(5)
		p:push(6)
		p:push(7)
		p:push(8)

		self:expectLuaReturn("do nothing if 'n' exceeds the stack size", p.reduceStack, p, 99999)
		self:isEqual(p.stack[8], 8)

		self:expectLuaReturn("normal behavior", p.reduceStack, p, 5)
		self:isEqual(p.stack[1], 1)
		self:isEqual(p.stack[2], 2)
		self:isEqual(p.stack[3], 3)
		self:isEqual(p.stack[4], 4)
		self:isEqual(p.stack[5], 5)
		self:isEqual(p.stack[6], nil)
		self:isEqual(p.stack[7], nil)
		self:isEqual(p.stack[8], nil)

		self:expectLuaReturn("default to clearing the whole stack", p.reduceStack, p, nil)
		self:isEqual(p.stack[1], nil)
		self:isEqual(p.stack[2], nil)
		self:isEqual(p.stack[3], nil)
		self:isEqual(p.stack[4], nil)
		self:isEqual(p.stack[5], nil)
		self:isEqual(p.stack[6], nil)
		self:isEqual(p.stack[7], nil)
		self:isEqual(p.stack[8], nil)

		self:expectLuaReturn("don't choke on negative 'n'", p.reduceStack, p, -10000)
	end
	--]====]

	-- [====[
	do
		local p = pPool.new(nil, nil, 500)
		self:expectLuaError("arg #1 bad type", p.reduceStack, p, {})
		self:expectLuaError("arg #1 reject NaN", p.reduceStack, p, 0/0)
	end
	--]====]
end
)
--]===]


self:runJobs()
