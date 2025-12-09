-- Test: pile_tree.lua
-- VERSION: 2.012

local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pTree = require(PATH .. "pile_tree")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE Tree", cli_verbosity)


self:registerFunction("pTree.nodeNew", pTree.nodeNew)


-- [===[
self:registerJob("pTree.nodeNew", function(self)
	-- There's not much to test here.

	-- [====[
	do
		-- [[
		local root = self:expectLuaReturn("new()", pTree.nodeNew)
		self:isType(root["nodes"], "table")
		self:isEqual(root["parent"], false)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeAdd", pTree.nodeAdd)


-- [===[
self:registerJob("pTree.nodeAdd", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local child_g1 = self:expectLuaReturn("add()", pTree.nodeAdd, root)

		self:isType(root, "table")
		self:isType(child_g1, "table")
		self:isEqual(child_g1["parent"], root)
		--]]

		-- [[
		local child_g1_b = self:expectLuaReturn("add() (insert pos 1)", pTree.nodeAdd, root, 1)

		self:isType(child_g1_b, "table")
		self:isEqual(child_g1, root["nodes"][2])
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeAttach", pTree.nodeAttach)


-- [===[
self:registerJob("pTree.nodeAttach", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()

		local node = {["parent"] = false, ["nodes"] = {}}

		local child_g1 = self:expectLuaReturn("attach()", pTree.nodeAttach, root, node)

		self:isType(root, "table")
		self:isEqual(child_g1, node)
		self:isEqual(child_g1["parent"], root)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local root2 = pTree.nodeNew()

		local node = {["parent"] = false, ["nodes"] = {}}

		pTree.nodeAttach(root, node)
		self:expectLuaError("attach node that is already parented", pTree.nodeAttach, root2, node)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		self:expectLuaError("attach a root to itself", pTree.nodeAttach, root, root)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeRemove", pTree.nodeRemove)


-- [===[
self:registerJob("pTree.nodeRemove", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		c1.id = "one"
		local c2 = pTree.nodeAdd(root)
		c2.id = "two"
		local c3 = pTree.nodeAdd(root)
		c3.id = "three"

		self:expectLuaReturn("remove(c2)", pTree.nodeRemove, c2)

		self:isEqual(root["nodes"][1].id, "one")
		self:isEqual(root["nodes"][2].id, "three")
		self:isNil(root["nodes"][3])

		self:isEvalFalse(c2["parent"])
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		self:expectLuaError("can't call with root", pTree.nodeRemove, root)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local root2 = pTree.nodeNew()
		local node = pTree.nodeAdd(root)
		node.parent = root2
		self:expectLuaError("incorrect parent reference", pTree.nodeRemove, node)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeGetIndex", pTree.nodeGetIndex)


-- [===[
self:registerJob("pTree.nodeGetIndex", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		c1.id = "one"
		local c2 = pTree.nodeAdd(root)
		c2.id = "two"

		local i1 = self:expectLuaReturn("getIndex(c1)", pTree.nodeGetIndex, c1)
		local i2 = self:expectLuaReturn("getIndex(c2)", pTree.nodeGetIndex, c2)

		self:isEqual(i1, 1)
		self:isEqual(i2, 2)

		pTree.nodeRemove(c1)
		-- 'i1' and 'i2' are now stale info...

		self:isEqual(pTree.nodeGetIndex(c2), 1)
		--]]
	end
	--]====]

	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		self:expectLuaError("can't call with root", pTree.nodeGetIndex, root)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local root2 = pTree.nodeNew()
		local node = pTree.nodeAdd(root)
		node.parent = root2
		self:expectLuaError("incorrect parent reference", pTree.nodeGetIndex, node)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeAssertIndex", pTree.nodeAssertIndex)


-- [===[
self:registerJob("pTree.nodeAssertIndex", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		c1.id = "one"
		local c2 = pTree.nodeAdd(root)
		c2.id = "two"

		local siblings = root["nodes"]

		local i1 = self:expectLuaReturn("getIndex(c1)", pTree.nodeAssertIndex, c1, siblings)
		local i2 = self:expectLuaReturn("getIndex(c2)", pTree.nodeAssertIndex, c2, siblings)

		self:isEqual(i1, 1)
		self:isEqual(i2, 2)

		pTree.nodeRemove(c1)
		-- 'i1' and 'i2' are now stale info...

		self:isEqual(pTree.nodeAssertIndex(c2, siblings), 1)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		c1.id = "one"
		local c2 = pTree.nodeAdd(root)
		c2.id = "two"

		local siblings = {}

		self:expectLuaError("wrong 'siblings' table", pTree.nodeAssertIndex, c1, siblings)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		c1.id = "one"
		local c2 = pTree.nodeAdd(root)
		c2.id = "two"

		local siblings = root["nodes"]

		self:expectLuaError("arg 1 bad type (leads to search failure)", pTree.nodeAssertIndex, true, siblings)
		self:expectLuaError("arg 2 bad type (fails on length operator)", pTree.nodeAssertIndex, c1, true)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeGetDepth", pTree.nodeGetDepth)


-- [===[
self:registerJob("pTree.nodeGetDepth", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c111 = pTree.nodeAdd(c11)

		local d1 = self:expectLuaReturn("root depth (1)", pTree.nodeGetDepth, root)
		local d2 = self:expectLuaReturn("gen-1 depth (2)", pTree.nodeGetDepth, c1)
		local d3 = self:expectLuaReturn("gen-2 depth (3)", pTree.nodeGetDepth, c11)
		local d4 = self:expectLuaReturn("gen-3 depth (4)", pTree.nodeGetDepth, c111)

		self:isEqual(d1, 1)
		self:isEqual(d2, 2)
		self:isEqual(d3, 3)
		self:isEqual(d4, 4)
		--]]
	end
	--]====]
end
)
--]===]


self:registerFunction("pTree.nodeAssertNoCycles", pTree.nodeAssertNoCycles)


-- [===[
self:registerJob("pTree.nodeAssertNoCycles", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)

		self:expectLuaReturn("the tree is cycle-free", pTree.nodeAssertNoCycles, root)
		--]]
	end
	--]====]


	-- [[
	do
		local root = pTree.nodeNew()
		root["parent"] = root
		root["nodes"][1] = root
		self:expectLuaError("the tree has cycles", pTree.nodeAssertNoCycles, root)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetNext", pTree.nodeGetNext)


-- [===[
self:registerJob("pTree.nodeGetNext", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)

		local res1 = self:expectLuaReturn("from root to first child", pTree.nodeGetNext, root)
		self:isEqual(res1, c1)

		local res2 = self:expectLuaReturn("from first child to next sibling", pTree.nodeGetNext, c1)
		self:isEqual(res2, c2)

		local res3 = self:expectLuaReturn("from second child to grandchild", pTree.nodeGetNext, c2)
		self:isEqual(res3, c21)

		local res4 = self:expectLuaReturn("end of the line", pTree.nodeGetNext, c21)
		self:isNil(res4)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetNext, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetPrevious", pTree.nodeGetPrevious)


-- [===[
self:registerJob("pTree.nodeGetPrevious", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)

		local res1 = self:expectLuaReturn("from child to parent", pTree.nodeGetPrevious, c21)
		self:isEqual(res1, c2)

		local res2 = self:expectLuaReturn("from parent to parent's sibling", pTree.nodeGetPrevious, c2)
		self:isEqual(res2, c1)

		local res3 = self:expectLuaReturn("from parent's sibling to grandparent", pTree.nodeGetPrevious, c1)
		self:isEqual(res3, root)

		local res4 = self:expectLuaReturn("start of the line", pTree.nodeGetPrevious, root)
		self:isNil(res4)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetPrevious, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetNextSibling", pTree.nodeGetNextSibling)


-- [===[
self:registerJob("pTree.nodeGetNextSibling", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c3 = pTree.nodeAdd(root)

		local res1 = self:expectLuaReturn("[1] -> [2]", pTree.nodeGetNextSibling, c1)
		self:isEqual(res1, c2)

		local res2 = self:expectLuaReturn("[2] -> [3]", pTree.nodeGetNextSibling, c2)
		self:isEqual(res2, c3)

		local res3 = self:expectLuaReturn("[3] -> nil", pTree.nodeGetNextSibling, c3)
		self:isNil(res3)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetNextSibling, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetPreviousSibling", pTree.nodeGetPreviousSibling)


-- [===[
self:registerJob("pTree.nodeGetPreviousSibling", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c3 = pTree.nodeAdd(root)

		local res1 = self:expectLuaReturn("[3] -> [2]", pTree.nodeGetPreviousSibling, c3)
		self:isEqual(res1, c2)

		local res2 = self:expectLuaReturn("[2] -> [1]", pTree.nodeGetPreviousSibling, c2)
		self:isEqual(res2, c1)

		local res3 = self:expectLuaReturn("[1] -> nil", pTree.nodeGetPreviousSibling, c1)
		self:isNil(res3)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetPreviousSibling, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetChild", pTree.nodeGetChild)


-- [===[
self:registerJob("pTree.nodeGetChild", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c3 = pTree.nodeAdd(root)

		local res1 = self:expectLuaReturn("root -> [1]", pTree.nodeGetChild, root, 1)
		self:isEqual(res1, c1)

		local res2 = self:expectLuaReturn("root -> [2]", pTree.nodeGetChild, root, 2)
		self:isEqual(res2, c2)

		local res3 = self:expectLuaReturn("root -> [3]", pTree.nodeGetChild, root, 3)
		self:isEqual(res3, c3)

		local res4 = self:expectLuaReturn("root -> [4] (nil)", pTree.nodeGetChild, root, 4)
		self:isNil(res4)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetChild, true, 1)
		self:expectLuaError("arg #2 bad type", pTree.nodeGetChild, true, "foo")
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetChildren", pTree.nodeGetChildren)


-- [===[
self:registerJob("pTree.nodeGetChildren", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()

		local res1 = self:expectLuaReturn("getChildren()", pTree.nodeGetChildren, root)
		self:isEqual(res1, root["nodes"])
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetChildren, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetParent", pTree.nodeGetParent)


-- [===[
self:registerJob("pTree.nodeGetParent", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)

		local res1 = self:expectLuaReturn("getParent() (root has no parent)", pTree.nodeGetParent, root)
		self:isEvalFalse(res1)

		local res2 = self:expectLuaReturn("getParent()", pTree.nodeGetParent, c1)
		self:isEqual(res2, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetParent, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetRoot", pTree.nodeGetRoot)


-- [===[
self:registerJob("pTree.nodeGetRoot", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c111 = pTree.nodeAdd(c11)

		local res1 = self:expectLuaReturn("getRoot() from root", pTree.nodeGetRoot, root)
		self:isEqual(res1, root)

		local res2 = self:expectLuaReturn("getRoot() from child", pTree.nodeGetRoot, c1)
		self:isEqual(res2, root)

		local res3 = self:expectLuaReturn("getRoot() from deepest descendant", pTree.nodeGetRoot, c111)
		self:isEqual(res3, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetRoot, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeGetVeryLast", pTree.nodeGetVeryLast)


-- [===[
self:registerJob("pTree.nodeGetVeryLast", function(self)
	-- [====[
	do
		--[[
		╭─────╮
		│root │
		╰──┬──╯
		   ├───────────────────────────┐
		 ╭─┴─╮                       ╭─┴─╮
		 │c1 │                       │c2 │
		 ╰─┬─╯                       ╰─┬─╯
		   ├────────────┐              ├────────────┐
		 ╭─┴─╮        ╭─┴─╮          ╭─┴─╮        ╭─┴─╮
		 │c11│        │c12│          │c21│        │c22│
		 ╰─┬─╯        ╰─┬─╯          ╰─┬─╯        ╰─┬─╯
		   ├─────┐      ├─────┐        ├─────┐      ├─────┐
		 ╭─┴──╮╭─┴──╮ ╭─┴──╮╭─┴──╮   ╭─┴──╮╭─┴──╮ ╭─┴──╮╭─┴──╮
		 │c111││c112│ │c121││c122│   │c211││c212│ │c221││c222│
		 ╰────╯╰────╯ ╰────╯╰────╯   ╰────╯╰────╯ ╰────╯╰────╯
		--]]


		-- [[
		local root = pTree.nodeNew()

		local c1 = pTree.nodeAdd(root)

		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)

		local c111 = pTree.nodeAdd(c11)
		local c112 = pTree.nodeAdd(c11)

		local c121 = pTree.nodeAdd(c12)
		local c122 = pTree.nodeAdd(c12)

		local c2 = pTree.nodeAdd(root)

		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local c211 = pTree.nodeAdd(c21)
		local c212 = pTree.nodeAdd(c21)

		local c221 = pTree.nodeAdd(c22)
		local c222 = pTree.nodeAdd(c22)

		local res1 = self:expectLuaReturn("getVeryLast() from root", pTree.nodeGetVeryLast, root)
		self:isEqual(res1, c222)

		local res2 = self:expectLuaReturn("getVeryLast() from c21", pTree.nodeGetVeryLast, c21)
		self:isEqual(res2, c212)

		local res3 = self:expectLuaReturn("getVeryLast() from very last", pTree.nodeGetVeryLast, c222)
		self:isEqual(res3, c222)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeGetVeryLast, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeIterate", pTree.nodeIterate)


-- [===[
self:registerJob("pTree.nodeIterate", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {root, c1, c11, c12, c2, c21, c22}
		local expect_i = 1
		local function iterateWrapper(start)
			for node in pTree.nodeIterate(start) do
				if expect_i > #expected then
					error("index out of bounds!")
				end

				self:isEqual(node, expected[expect_i])

				expect_i = expect_i + 1
			end

			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("iterate() from root", iterateWrapper, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeIterate, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeIterateBack", pTree.nodeIterateBack)


-- [===[
self:registerJob("pTree.nodeIterateBack", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {c22, c21, c2, c12, c11, c1, root}
		local expect_i = 1
		local function iterateBackWrapper(start)
			for node in pTree.nodeIterateBack(start) do
				if expect_i > #expected then
					error("index out of bounds!")
				end

				self:isEqual(node, expected[expect_i])

				expect_i = expect_i + 1
			end
			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("iterateBack() from root", iterateBackWrapper, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeIterateBack, true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeForEach", pTree.nodeForEach)


-- [===[
self:registerJob("pTree.nodeForEach", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {root, c1, c11, c12, c2, c21, c22}
		local expect_i = 1

		local function visitCallback(node)
			if expect_i > #expected then
					error("index out of bounds!")
			end

			self:isEqual(node, expected[expect_i])

			expect_i = expect_i + 1
		end

		local function visitWrapper(start)
			pTree.nodeForEach(start, true, visitCallback)

			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("visit() from root (inclusive)", visitWrapper, root)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {c1, c11, c12, c2, c21, c22}
		local expect_i = 1

		local function visitCallback(node)
			if expect_i > #expected then
					error("index out of bounds!")
			end

			self:isEqual(node, expected[expect_i])

			expect_i = expect_i + 1
		end

		local function visitWrapper(start)
			pTree.nodeForEach(start, false, visitCallback)

			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("visit() from root (exclusive)", visitWrapper, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeForEach, true)
		-- don't check arg #2
		self:expectLuaError("arg #3 not callable", pTree.nodeForEach, pTree.nodeNew(), true, 500)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeForEachBack", pTree.nodeForEachBack)


-- [===[
self:registerJob("pTree.nodeForEachBack", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {c22, c21, c2, c12, c11, c1, root}
		local expect_i = 1

		local function visitBackCallback(node)
			if expect_i > #expected then
					error("index out of bounds!")
			end

			self:isEqual(node, expected[expect_i])

			expect_i = expect_i + 1
		end

		local function visitBackWrapper(start)
			pTree.nodeForEachBack(start, true, visitBackCallback)

			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("visitBack() from root (inclusive)", visitBackWrapper, root)
		--]]
	end
	--]====]


	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local expected = {c22, c21, c2, c12, c11, c1}
		local expect_i = 1

		local function visitBackCallback(node)
			if expect_i > #expected then
					error("index out of bounds!")
			end

			self:isEqual(node, expected[expect_i])

			expect_i = expect_i + 1
		end

		local function visitBackWrapper(start)
			pTree.nodeForEachBack(start, false, visitBackCallback)

			if expect_i < #expected then
				error("test didn't run to completion")
			end
		end

		self:expectLuaReturn("visitBack() from root (exclusive)", visitBackWrapper, root)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeForEachBack, true)
		-- don't check arg #2
		self:expectLuaError("arg #3 not callable", pTree.nodeForEachBack, pTree.nodeNew(), true, 500)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeHasThisAncestor", pTree.nodeHasThisAncestor)


-- [===[
self:registerJob("pTree.nodeHasThisAncestor", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local rv
		rv = self:expectLuaReturn("hasThisAncestor(): yes", pTree.nodeHasThisAncestor, c22, root)
		self:isEqual(rv, true)

		rv = self:expectLuaReturn("hasThisAncestor(): no", pTree.nodeHasThisAncestor, c22, c1)
		self:isEqual(rv, false)

		rv = self:expectLuaReturn("hasThisAncestor(): is always exclusive", pTree.nodeHasThisAncestor, root, root)
		self:isEqual(rv, false)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeHasThisAncestor, true, pTree.nodeNew())
		self:expectLuaError("arg #2 bad type", pTree.nodeHasThisAncestor, pTree.nodeNew(), true)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeIsInLineage", pTree.nodeIsInLineage)


-- [===[
self:registerJob("pTree.nodeIsInLineage", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c12 = pTree.nodeAdd(c1)
		local c2 = pTree.nodeAdd(root)
		local c21 = pTree.nodeAdd(c2)
		local c22 = pTree.nodeAdd(c2)

		local rv
		rv = self:expectLuaReturn("isInLineage(): yes", pTree.nodeIsInLineage, c22, root)
		self:isEqual(rv, true)

		rv = self:expectLuaReturn("isInLineage(): no", pTree.nodeIsInLineage, c22, c1)
		self:isEqual(rv, false)

		rv = self:expectLuaReturn("isInLineage(): is always inclusive", pTree.nodeIsInLineage, root, root)
		self:isEqual(rv, true)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeIsInLineage, true, pTree.nodeNew())
		self:expectLuaError("arg #2 bad type", pTree.nodeIsInLineage, pTree.nodeNew(), true)
	end
	--]]
end
)
--]===]

print("pTree.nodeFindKeyInChildren", pTree.nodeFindKeyInChildren)
self:registerFunction("pTree.nodeFindKeyInChildren", pTree.nodeFindKeyInChildren)


-- [===[
self:registerJob("pTree.nodeFindKeyInChildren", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()

		local c1 = pTree.nodeAdd(root)
		local c2 = pTree.nodeAdd(root)
		local c3 = pTree.nodeAdd(root)

		c1.light = "red"
		c1.awake = true
		c1.zonk = nil

		c2.light = "green"
		c2.awake = true
		c2.zonk = nil

		c3.light = "mauve"
		c3.awake = false
		c3.zonk = "bonk"

		local r1, r2, r3
		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): success (specific, match first node)", pTree.nodeFindKeyInChildren, root, 1, "light", "red")
		self:isEqual(r1, c1)
		self:isEqual(r2, "red")
		self:isEqual(r3, 1)

		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): success (specific, after initial node)", pTree.nodeFindKeyInChildren, root, 1, "light", "mauve")
		self:isEqual(r1, c3)
		self:isEqual(r2, "mauve")
		self:isEqual(r3, 3)

		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): failure (specific)", pTree.nodeFindKeyInChildren, root, 1, "zob", "nope")
		self:isNil(r1)
		self:isNil(r2)
		self:isNil(r3)

		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): success (non-specific, match initial node)", pTree.nodeFindKeyInChildren, root, 1, "awake")
		self:isEqual(r1, c1)
		self:isEqual(r2, true)
		self:isEqual(r3, 1)

		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): success (non-specific, after initial node)", pTree.nodeFindKeyInChildren, root, 1, "zonk")
		self:isEqual(r1, c3)
		self:isEqual(r2, "bonk")
		self:isEqual(r3, 3)

		r1, r2, r3 = self:expectLuaReturn("findKeyInChildren(): failure (non-specific)", pTree.nodeFindKeyInChildren, root, 1, "no-key-here")
		self:isNil(r1)
		self:isNil(r2)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeFindKeyInChildren, true, 1, "foo")
		self:expectLuaError("arg #2 not an integer", pTree.nodeFindKeyInChildren, pTree.nodeNew(), 1.1, "foo")
		self:expectLuaError("arg #3 cannot be nil", pTree.nodeFindKeyInChildren, pTree.nodeNew(), 1, nil)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeFindKeyDescending", pTree.nodeFindKeyDescending)


-- [===[
self:registerJob("pTree.nodeFindKeyDescending", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c111 = pTree.nodeAdd(c11)

		root.foo = true
		root.zob = "woop"
		root.wee = true

		c1.bar = 1

		c11.baz = false
		c11.wee = "woo"
		c11.wah = "woh"

		c111.zob = "box"

		local r1, r2
		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (exclusive, specific)", pTree.nodeFindKeyDescending, root, false, "zob", "box")
		self:isEqual(r1, c111)
		self:isEqual(r2, "box")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): failure (exclusive, specific)", pTree.nodeFindKeyDescending, root, false, "zob", "nope")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (exclusive, non-specific)", pTree.nodeFindKeyDescending, root, false, "zob")
		self:isEqual(r1, c111)
		self:isEqual(r2, "box")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): failure (exclusive, non-specific)", pTree.nodeFindKeyDescending, root, false, "no-key-here")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (inclusive, specific, look past initial node)", pTree.nodeFindKeyDescending, root, true, "zob", "box")
		self:isEqual(r1, c111)
		self:isEqual(r2, "box")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (inclusive, specific, find in initial node)", pTree.nodeFindKeyDescending, root, true, "zob", "woop")
		self:isEqual(r1, root)
		self:isEqual(r2, "woop")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): failure (inclusive, specific)", pTree.nodeFindKeyDescending, root, true, "zob", "nope")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (inclusive, non-specific, find in initial node)", pTree.nodeFindKeyDescending, root, true, "zob")
		self:isEqual(r1, root)
		self:isEqual(r2, "woop")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): success (inclusive, non-specific, look past initial node)", pTree.nodeFindKeyDescending, root, true, "wah")
		self:isEqual(r1, c11)
		self:isEqual(r2, "woh")

		r1, r2 = self:expectLuaReturn("findKeyDescending(): failure (inclusive, non-specific)", pTree.nodeFindKeyDescending, root, true, "no-key-here")
		self:isNil(r1)
		self:isNil(r2)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeFindKeyDescending, true, pTree.nodeNew(), true, "foo")
		-- don't check arg #2
		self:expectLuaError("arg #3 cannot be nil", pTree.nodeFindKeyDescending, pTree.nodeNew(), true, nil)
	end
	--]]
end
)
--]===]


self:registerFunction("pTree.nodeFindKeyAscending", pTree.nodeFindKeyAscending)


-- [===[
self:registerJob("pTree.nodeFindKeyAscending", function(self)
	-- [====[
	do
		-- [[
		local root = pTree.nodeNew()
		local c1 = pTree.nodeAdd(root)
		local c11 = pTree.nodeAdd(c1)
		local c111 = pTree.nodeAdd(c11)

		root.foo = true
		root.zob = "woop"
		root.wee = true

		c1.bar = 1

		c11.baz = false
		c11.wee = "woo"
		c11.wah = "woh"

		c111.zob = "box"

		local r1, r2
		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (exclusive, specific)", pTree.nodeFindKeyAscending, c111, false, "foo", true)
		self:isEqual(r1, root)
		self:isEqual(r2, true)

		r1, r2 = self:expectLuaReturn("findKeyAscending(): failure (exclusive, specific)", pTree.nodeFindKeyAscending, c111, false, "zob", "no-value-here")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (exclusive, non-specific)", pTree.nodeFindKeyAscending, c111, false, "wee")
		print("r1", r1, "r2", r2)
		self:isEqual(r1, c11)
		self:isEqual(r2, "woo")

		r1, r2 = self:expectLuaReturn("findKeyAscending(): failure (exclusive, non-specific)", pTree.nodeFindKeyAscending, c111, false, "no-key-here")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (inclusive, specific, look past initial node)", pTree.nodeFindKeyAscending, c111, true, "zob", "woop")
		self:isEqual(r1, root)
		self:isEqual(r2, "woop")

		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (inclusive, specific, find in initial node)", pTree.nodeFindKeyAscending, c111, true, "zob", "box")
		self:isEqual(r1, c111)
		self:isEqual(r2, "box")

		r1, r2 = self:expectLuaReturn("findKeyAscending(): failure (inclusive, specific)", pTree.nodeFindKeyAscending, root, true, "zob", "no-such-value")
		self:isNil(r1)
		self:isNil(r2)

		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (inclusive, non-specific, find in initial node)", pTree.nodeFindKeyAscending, c111, true, "zob")
		self:isEqual(r1, c111)
		self:isEqual(r2, "box")

		r1, r2 = self:expectLuaReturn("findKeyAscending(): success (inclusive, non-specific, look past initial node)", pTree.nodeFindKeyAscending, c111, true, "wah")
		self:isEqual(r1, c11)
		self:isEqual(r2, "woh")

		r1, r2 = self:expectLuaReturn("findKeyAscending(): failure (inclusive, non-specific)", pTree.nodeFindKeyAscending, root, true, "no-key-here")
		self:isNil(r1)
		self:isNil(r2)
		--]]
	end
	--]====]


	-- [[
	do
		self:expectLuaError("arg #1 bad type", pTree.nodeFindKeyAscending, true, pTree.nodeNew(), true, "foo")
		-- don't check arg #2
		self:expectLuaError("arg #3 cannot be nil", pTree.nodeFindKeyAscending, pTree.nodeNew(), true, nil)
	end
	--]]
end
)
--]===]


self:runJobs()
