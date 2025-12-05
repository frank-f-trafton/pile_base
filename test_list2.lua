-- Test: pile_list2.lua
-- v2.011


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pList2 = require(PATH .. "pile_list2")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE List2", cli_verbosity)


self:registerFunction("pList2.nodeNew", pList2.nodeNew)


-- [===[
self:registerJob("pList2.nodeNew()", function(self)
	-- [====[
	do
		local node = self:expectLuaReturn("nodeNew()", pList2.nodeNew)

		self:isType(node, "table")
		self:isEqual(node["next"], false)
		self:isEqual(node["prev"], false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeLink", pList2.nodeLink)


-- [===[
self:registerJob("pList2.nodeLink()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()

		self:expectLuaReturn("link()", pList2.nodeLink, a, b)

		self:isEqual(a["next"], b)
		self:isEqual(a["prev"], false)

		self:isEqual(b["next"], false)
		self:isEqual(b["prev"], a)
	end
	--]====]


	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()

		self:expectLuaError("arg #1 invalid", pList2.nodeLink, false, b)
		self:expectLuaError("arg #2 invalid", pList2.nodeLink, a, false)
		self:expectLuaError("circular link to self", pList2.nodeLink, a, a)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeUnlink", pList2.nodeUnlink)


-- [===[
self:registerJob("pList2.nodeUnlink()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		self:expectLuaReturn("unlink()", pList2.nodeUnlink, b)

		self:isEqual(a["next"], c)
		self:isEqual(a["prev"], false)

		self:isEqual(b["next"], false)
		self:isEqual(b["prev"], false)

		self:isEqual(c["next"], d)
		self:isEqual(c["prev"], a)

		self:isEqual(d["next"], false)
		self:isEqual(d["prev"], c)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeUnlink, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeUnlinkNext", pList2.nodeUnlinkNext)


-- [===[
self:registerJob("pList2.nodeUnlinkNext()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		self:expectLuaReturn("unlinkNext()", pList2.nodeUnlinkNext, b)

		self:isEqual(a["next"], b)
		self:isEqual(a["prev"], false)

		self:isEqual(b["next"], false)
		self:isEqual(b["prev"], a)

		self:isEqual(c["next"], d)
		self:isEqual(c["prev"], false)

		self:isEqual(d["next"], false)
		self:isEqual(d["prev"], c)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeUnlinkNext, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeUnlinkPrevious", pList2.nodeUnlinkPrevious)


-- [===[
self:registerJob("pList2.nodeUnlinkPrevious()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		self:expectLuaReturn("unlinkPrevious()", pList2.nodeUnlinkPrevious, b)

		self:isEqual(a["next"], false)
		self:isEqual(a["prev"], false)

		self:isEqual(b["next"], c)
		self:isEqual(b["prev"], false)

		self:isEqual(c["next"], d)
		self:isEqual(c["prev"], b)

		self:isEqual(d["next"], false)
		self:isEqual(d["prev"], c)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeUnlinkPrevious, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeAssertNoCycles", pList2.nodeAssertNoCycles)


-- [===[
self:registerJob("pList2.nodeAssertNoCycles()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		self:expectLuaReturn("assertNoCycles()", pList2.nodeAssertNoCycles, a)
	end
	--]====]


	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)
		pList2.nodeLink(d, a) -- circular reference

		self:expectLuaError("find cycle (circular reference)", pList2.nodeAssertNoCycles, a)
	end
	--]====]


	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)
		c["prev"] = d -- invalid previous connection

		self:expectLuaError("find cycle (invalid previous connection)", pList2.nodeAssertNoCycles, a)
	end
	--]====]


	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)
		c["next"] = c -- invalid next connection

		self:expectLuaError("find cycle (invalid next connection)", pList2.nodeAssertNoCycles, a)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeAssertNoCycles, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeGetHead", pList2.nodeGetHead)


-- [===[
self:registerJob("pList2.nodeGetHead()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		local head = self:expectLuaReturn("getHead()", pList2.nodeGetHead, d)
		self:isEqual(a, head)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeGetHead, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeGetTail", pList2.nodeGetTail)


-- [===[
self:registerJob("pList2.nodeGetTail()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()
		local d = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)
		pList2.nodeLink(c, d)

		local tail = self:expectLuaReturn("getTail()", pList2.nodeGetTail, a)
		self:isEqual(d, tail)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeGetTail, false)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeGetNext", pList2.nodeGetNext)


-- [===[
self:registerJob("pList2.nodeGetNext()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local node

		node = self:expectLuaReturn("getNext()", pList2.nodeGetNext, a)
		self:isEqual(node, b)

		node = self:expectLuaReturn("getNext()", pList2.nodeGetNext, b)
		self:isEqual(node, c)

		node = self:expectLuaReturn("getNext()", pList2.nodeGetNext, c)
		self:isNil(node)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeGetNext, true)
		self:expectLuaError("arg #2 invalid", pList2.nodeGetNext, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeGetPrevious", pList2.nodeGetPrevious)


-- [===[
self:registerJob("pList2.nodeGetPrevious()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local node

		node = self:expectLuaReturn("getPrevious()", pList2.nodeGetPrevious, c)
		self:isEqual(node, b)

		node = self:expectLuaReturn("getPrevious()", pList2.nodeGetPrevious, b)
		self:isEqual(node, a)

		node = self:expectLuaReturn("getPrevious()", pList2.nodeGetPrevious, a)
		self:isNil(node)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeGetPrevious, true)
		self:expectLuaError("arg #2 invalid", pList2.nodeGetPrevious, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeIterateNext", pList2.nodeIterateNext)


-- [===[
self:registerJob("pList2.nodeIterateNext()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local function iterateNextWrapper(start)
			local expected = {a, b, c}
			local i = 1
			for node in pList2.nodeIterateNext(start) do
				if i > #expected then
					error("index out of bounds!")
				end
				self:isEqual(node, expected[i])
				i = i + 1
			end
		end

		self:expectLuaReturn("iterateNext()", iterateNextWrapper, a)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeIterateNext, true)
	end
	--]====]
end
)
--]===]


--iteratePrevious
self:registerFunction("pList2.nodeIteratePrevious", pList2.nodeIteratePrevious)


-- [===[
self:registerJob("pList2.nodeIteratePrevious()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local function iteratePreviousWrapper(start)
			local expected = {c, b, a}
			local i = 1
			for node in pList2.nodeIteratePrevious(start) do
				if i > #expected then
					error("index out of bounds!")
				end
				self:isEqual(node, expected[i])
				i = i + 1
			end
		end

		self:expectLuaReturn("iteratePrevious()", iteratePreviousWrapper, c)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeIteratePrevious, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeInListForward", pList2.nodeInListForward)


-- [===[
self:registerJob("pList2.nodeInListForward()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local ret

		ret = self:expectLuaReturn("inListForward()", pList2.nodeInListForward, a, b)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inListForward() - search is inclusive", pList2.nodeInListForward, a, a)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inListForward() not in list", pList2.nodeInListForward, a, pList2.nodeNew())
		self:isEqual(ret, false)

		ret = self:expectLuaReturn("inListForward() in list, but other direction", pList2.nodeInListForward, c, a)
		self:isEqual(ret, false)

		ret = self:expectLuaReturn("inListForward() - run the full breadth of the list", pList2.nodeInListForward, a, c)
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeInListForward, true, pList2.nodeNew())
		self:expectLuaError("arg #2 invalid", pList2.nodeInListForward, pList2.nodeNew(), true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeInListBackward", pList2.nodeInListBackward)


-- [===[
self:registerJob("pList2.nodeInListBackward()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local ret

		ret = self:expectLuaReturn("inListBackward()", pList2.nodeInListBackward, c, b)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inListBackward() - search is inclusive", pList2.nodeInListBackward, c, c)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inListBackward() not in list", pList2.nodeInListBackward, c, pList2.nodeNew())
		self:isEqual(ret, false)

		ret = self:expectLuaReturn("inListBackward() in list, but other direction", pList2.nodeInListBackward, a, c)
		self:isEqual(ret, false)

		ret = self:expectLuaReturn("inListBackward() - run the full breadth of the list", pList2.nodeInListBackward, c, a)
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeInListBackward, true, pList2.nodeNew())
		self:expectLuaError("arg #2 invalid", pList2.nodeInListBackward, pList2.nodeNew(), true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pList2.nodeInList", pList2.nodeInList)


-- [===[
self:registerJob("pList2.nodeInList()", function(self)
	-- [====[
	do
		local a = pList2.nodeNew()
		local b = pList2.nodeNew()
		local c = pList2.nodeNew()

		pList2.nodeLink(a, b)
		pList2.nodeLink(b, c)

		local ret

		ret = self:expectLuaReturn("inList()", pList2.nodeInList, a, b)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inList() - search is inclusive", pList2.nodeInList, a, a)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inList() not in list", pList2.nodeInList, a, pList2.nodeNew())
		self:isEqual(ret, false)

		ret = self:expectLuaReturn("inList() in list, full back direction", pList2.nodeInList, c, a)
		self:isEqual(ret, true)

		ret = self:expectLuaReturn("inList() in list, full forward direction", pList2.nodeInList, a, c)
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg #1 invalid", pList2.nodeInList, true, pList2.nodeNew())
		self:expectLuaError("arg #2 invalid", pList2.nodeInList, pList2.nodeNew(), true)
		-- don't check arg 3
	end
	--]====]
end
)
--]===]


self:runJobs()
