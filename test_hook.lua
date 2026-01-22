-- Test: pile_hook.lua
-- VERSION: 2.022


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pHook = require(PATH .. "pile_hook")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Hook", cli_verbosity)


-- Some hooks and a filter that are used in multiple jobs.
local function _filter(t, k)
	-- reject non-string keys
	return type(k) == "string"
end


local function _set1(t, k)
	t[k] = 1
end


local function _set2(t, k)
	t[k] = 2
end


self:registerFunction("pHook.newHookList", pHook.newHookList)


-- [===[
self:registerJob("pHook.newHookList()", function(self)
	-- [====[
	do
		local hooks = self:expectLuaReturn("newHookList()", pHook.newHookList)

		-- Not much to test here that isn't covered by other tests.
		-- Default order is tested later.
		self:isType(hooks, "table")
	end
	--]====]
end
)
--]===]


self:registerFunction("pHook.callHooks", pHook.callHooks)


-- [===[
self:registerJob("pHook.callHooks()", function(self)
	-- [====[
	do
		local hooks = pHook.newHookList()

		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}
		self:expectLuaReturn("callHooks() forward order", pHook.callHooks, hooks, t, "foo")
		self:isEqual(t.foo, 2)
	end
	--]====]


	-- [====[
	do
		local hooks = pHook.newHookList()

		hooks[0] = _filter
		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}

		self:expectLuaReturn("callHooks(): filter accepts string input", pHook.callHooks, hooks, t, "foo")
		self:isEqual(t.foo, 2)

		self:expectLuaReturn("callHooks(): filter rejects number input", pHook.callHooks, hooks, t, 9)
		self:isEqual(t[9], nil)
	end
	--]====]


	-- [====[
	do
		local hooks = pHook.newHookList()
		self:expectLuaError("callHooks arg #1 not callable", pHook.callHooks, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pHook.callHooksBack", pHook.callHooksBack)


-- [===[
self:registerJob("pHook.callHooksBack()", function(self)
	-- [====[
	do
		local hooks = pHook.newHookList()

		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}
		self:expectLuaReturn("callHooksBack() backward order", pHook.callHooksBack, hooks, t, "foo")
		self:isEqual(t.foo, 1)
	end
	--]====]


	-- [====[
	do
		local hooks = pHook.newHookList()

		hooks[0] = _filter
		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}

		self:expectLuaReturn("callHooksBack(): filter accepts string input", pHook.callHooksBack, hooks, t, "foo")
		self:isEqual(t.foo, 1)

		self:expectLuaReturn("callHooksBack(): filter rejects number input", pHook.callHooksBack, hooks, t, 9)
		self:isEqual(t[9], nil)
	end
	--]====]


	-- [====[
	do
		local hooks = pHook.newHookList()
		self:expectLuaError("callHooksBack arg #1 not callable", pHook.callHooksBack, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("HookList default iteration order", function(self)
	-- [====[
	do
		local hooks = self:expectLuaReturn("default (forward) iteration", pHook.newHookList)

		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}

		hooks(t, "foo")

		self:isEqual(t.foo, 2)
	end
	--]====]


	-- [====[
	do
		local hooks = self:expectLuaReturn("backward iteration", pHook.newHookList, true)

		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local t = {}

		hooks(t, "foo")

		self:isEqual(t.foo, 1)
	end
	--]====]
end
)
--]===]


--[[
function M.wrap(hl)
	pAssert.type(1, hl, "table")

	local fn = function(...)
		return hl(...)
	end

	return fn
end
--]]
self:registerFunction("pHook.wrap", pHook.wrap)


-- [===[
self:registerJob("pHook.wrap()", function(self)
	-- [====[
	do
		local hooks = pHook.newHookList()

		table.insert(hooks, _set1)
		table.insert(hooks, _set2)

		local rv = self:expectLuaReturn("wrap a HookList", pHook.wrap, hooks)

		local t = {}
		self:expectLuaReturn("call the wrapped HookList", rv, t, "foo")
		self:isEqual(t.foo, 2)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("wrap arg #1 bad type", pHook.wrap, true)
	end
	--]====]
end
)
--]===]



self:runJobs()
