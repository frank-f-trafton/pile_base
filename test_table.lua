-- Test: pile_table.lua
-- v2.011


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pName = require(PATH .. "pile_name")
local pTable = require(PATH .. "pile_table")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pTable", cli_verbosity)


self:registerFunction("pTable.clearAll()", pTable.clearAll)


-- [===[
self:registerJob("pTable.clearAll()", function(self)
	-- [====[
	do
		local t = {a="foo", b="bar", c="baz", 4, 5, 6}
		self:isNotNil(next(t))
		self:expectLuaReturn("clear table", pTable.clearAll, t)
		self:isEqual(next(t), nil)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.clearArray()", pTable.clearArray)


-- [===[
self:registerJob("pTable.clearArray()", function(self)
	-- [====[
	do
		local t = {"x", "y", "z"}
		self:isNotEqual(#t, 0)
		self:expectLuaReturn("clear array contents of table", pTable.clearArray, t)
		self:isEqual(#t, 0)
	end
	--]====]


	-- [====[
	do
		local t = {"x", "y", "z", a="foo", b="bar", c="baz"}
		self:expectLuaReturn("do not interfere with hash keys", pTable.clearArray, t)
		self:isEqual(#t, 0)
		self:isEqual(t.a, "foo")
		self:isEqual(t.b, "bar")
		self:isEqual(t.c, "baz")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.copy()", pTable.copy)


-- [===[
self:registerJob("pTable.copy()", function(self)
	-- [====[
	do
		local t_ref = {}
		local t = {a=t_ref, b="foo", c=t_ref}
		local t2 = self:expectLuaReturn("shallow-copy table", pTable.copy, t)
		self:isEqual(t2.a, t_ref)
		self:isEqual(t2.b, "foo")
		self:isEqual(t2.c, t_ref)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.copyArray()", pTable.copyArray)


-- [===[
self:registerJob("pTable.copyArray()", function(self)
	-- [====[
	do
		local t = {9, 8, 7, 6, 5, a=true, b="foo", c=false}
		local t2 = self:expectLuaReturn("copy array", pTable.copyArray, t)
		self:isEqual(t2[1], 9)
		self:isEqual(t2[2], 8)
		self:isEqual(t2[3], 7)
		self:isEqual(t2[4], 6)
		self:isEqual(t2[5], 5)
		self:isEqual(t2.a, nil)
		self:isEqual(t2.b, nil)
		self:isEqual(t2.c, nil)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.deepCopy()", pTable.deepCopy)


-- [===[
self:registerJob("pTable.deepCopy()", function(self)
	-- [====[
	do
		local t = {
			1, 2, 3,
			a = true,
			b = function() end,
			c = {
				[4] = 4,
				[5] = 5,
				[6] = {
					x = true,
					y = false,
					z = "@",
				},
			},
		}
		local t2 = self:expectLuaReturn("deepcopy", pTable.deepCopy, t)
		self:isEqual(t2[1], 1)
		self:isEqual(t2[2], 2)
		self:isEqual(t2[3], 3)
		self:isEqual(t2.a, true)
		self:isEqual(type(t2.b), "function")
		self:isEqual(type(t2.c), "table")
		self:isEqual(t2.c[4], 4)
		self:isEqual(t2.c[5], 5)
		self:isEqual(type(t2.c[6]), "table")
		self:isEqual(t2.c[6].x, true)
		self:isEqual(t2.c[6].y, false)
		self:isEqual(t2.c[6].z, "@")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("deepcopy: can't copy tables as keys", pTable.deepCopy, { [{}] = {} } )
	end
	--]====]


	-- [====[
	do
		local a, b = {}, {}
		a.b = b
		b.a = a
		self:expectLuaError("deepcopy: can't copy cycles (stack overflow)", pTable.deepCopy, a)
	end
	--]====]


	-- [====[
	do
		local a, b = {}, {}
		a.x = b
		a.y = b
		a.z = b
		self:isEqual(a.x, a.y)
		self:isEqual(a.x, a.z)
		self:isEqual(a.y, a.z)
		local t2 = self:expectLuaReturn("deepcopy: same-ref tables in source become unique in dest", pTable.deepCopy, a)
		self:isNotEqual(t2.x, t2.y)
		self:isNotEqual(t2.x, t2.z)
		self:isNotEqual(t2.y, t2.z)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.patch()", pTable.patch)


-- [===[
self:registerJob("pTable.patch()", function(self)
	-- [====[
	do
		self:expectLuaError("arg #1 bad type", pTable.patch, 123, {})
		self:expectLuaError("arg #2 bad type", pTable.patch, {}, 123)
		-- Don't type-check 'overwrite'.
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {}, {}
		local count = self:expectLuaReturn("empty tables", pTable.patch, t1, t2)
		self:isNil(next(t1))
		self:isEqual(count, 0)
	end
	--]====]


	-- [====[
	do
		local tk = {true}
		local t1, t2 = {}, { [tk] = "foo"}
		local count = self:expectLuaReturn("supports tables as keys (which are just copied by reference)", pTable.patch, t1, t2)
		self:isEqual(next(t1), tk)
		self:isEqual(count, 0)
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {a="z", b="x", c="c", d="v"}, {a="q", b="w", c="e", d="r"}
		local count = self:expectLuaReturn("patch existing values", pTable.patch, t1, t2, true)
		self:isEqual(t1.a, "q")
		self:isEqual(t1.b, "w")
		self:isEqual(t1.c, "e")
		self:isEqual(t1.d, "r")
		self:isEqual(count, 4)
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {a="z", b="x", c="c", d="v"}, {a="q", b="w", c="e", d="r"}
		local count = self:expectLuaReturn("do not overwrite existing fields", pTable.patch, t1, t2, false)
		self:isEqual(t1.a, "z")
		self:isEqual(t1.b, "x")
		self:isEqual(t1.c, "c")
		self:isEqual(t1.d, "v")
		self:isEqual(count, 4)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.deepPatch()", pTable.deepPatch)


-- [===[
self:registerJob("pTable.deepPatch()", function(self)
	-- [====[
	do
		self:expectLuaError("arg #1 bad type", pTable.deepPatch, 123, {})
		self:expectLuaError("arg #2 bad type", pTable.deepPatch, {}, 123)
		-- Don't type-check 'overwrite'.
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {}, { [{true}] = "foo"}
		self:expectLuaError("doesn't support tables as keys", pTable.deepPatch, t1, t2)
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {}, {}
		self:expectLuaReturn("empty tables", pTable.deepPatch, t1, t2)
		self:isNil(next(t1))
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {}, {a={b={c={d="foo", dd="bar", ddd=123, dddd=false}}}}
		self:expectLuaReturn("create new sub-tables", pTable.deepPatch, t1, t2)
		self:isEvalTrue(t1.a)
		self:isEvalTrue(t1.a.b)
		self:isEvalTrue(t1.a.b.c)
		self:isEqual(t1.a.b.c.d, "foo")
		self:isEqual(t1.a.b.c.dd, "bar")
		self:isEqual(t1.a.b.c.ddd, 123)
		self:isEqual(t1.a.b.c.dddd, false)
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {a={b={c={d="bar"}}}}, {a={b={c={d="zoop"}}}}
		self:expectLuaReturn("patch existing sub-tables", pTable.deepPatch, t1, t2, true)
		self:isEvalTrue(t1.a)
		self:isEvalTrue(t1.a.b)
		self:isEvalTrue(t1.a.b.c)
		self:isEqual(t1.a.b.c.d, "zoop")
	end
	--]====]


	-- [====[
	do
		local t1, t2 = {a={b={c={d="bar", dd="boop", ddd="zoop"}}}}, {a={b={c={d="we", dd="wee", ddd="weee"}}}}
		self:expectLuaReturn("do not overwrite existing fields", pTable.deepPatch, t1, t2, false)
		self:isEvalTrue(t1.a)
		self:isEvalTrue(t1.a.b)
		self:isEvalTrue(t1.a.b.c)
		self:isEqual(t1.a.b.c.d, "bar")
		self:isEqual(t1.a.b.c.dd, "boop")
		self:isEqual(t1.a.b.c.ddd, "zoop")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.hasAnyDuplicateTables()", pTable.hasAnyDuplicateTables)


-- [===[
self:registerJob("pTable.hasAnyDuplicateTables()", function(self)

	-- [====[
	do
		self:expectLuaError("no arguments passed", pTable.hasAnyDuplicateTables)
		self:expectLuaError("arg #1 bad type", pTable.hasAnyDuplicateTables, false)
		self:expectLuaError("arg #2 bad type", pTable.hasAnyDuplicateTables, {}, false)
		-- etc.

	end
	--]====]


	-- [====[
	do
		local rv = self:expectLuaReturn("no duplicates", pTable.hasAnyDuplicateTables, {})
		self:isNil(rv)
	end
	--]====]


	-- [====[
	do
		local t = {}
		local rv = self:expectLuaReturn("duplicates in passed arguments", pTable.hasAnyDuplicateTables, t, t)
		self:isEqual(t, rv)
	end
	--]====]


	-- [====[
	do
		local t = {}
		local a1, a2 = {x=t}, {y=t}
		local rv = self:expectLuaReturn("duplicates within tables", pTable.hasAnyDuplicateTables, a1, a2)
		self:isEqual(t, rv)
	end
	--]====]


	-- [====[
	do
		local a1, a2 = {}, {}
		a2.z = a1
		local rv = self:expectLuaReturn("one arg appears as a value in another arg", pTable.hasAnyDuplicateTables, a1, a2)
		self:isEqual(a1, rv)
	end
	--]====]


	-- [====[
	do
		local t = {}
		local a1, a2 = {{{{x=t}}}}, {{{{y=t}}}}
		local rv = self:expectLuaReturn("duplicates within tables (more deeply nested)", pTable.hasAnyDuplicateTables, a1, a2)
		self:isEqual(t, rv)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.isArray()", pTable.isArray)


-- [===[
self:registerJob("pTable.isArray()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.isArray, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table", pTable.isArray, {})
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array", pTable.isArray, {"foo", "bar", "baz"})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array (plus non-numeric indices)", pTable.isArray, {"foo", "bar", "baz", a=1})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array (plus index 0 is populated)", pTable.isArray, {[0]=0, 1, 2, 3})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not an array (sparse)", pTable.isArray, {1, 2, nil, 4, 5})
		self:isEvalFalse(ret)
	end
	--]====]
end
)


self:registerFunction("pTable.isArrayOnly()", pTable.isArrayOnly)


-- [===[
self:registerJob("pTable.isArrayOnly()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.isArrayOnly, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table", pTable.isArrayOnly, {})
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array", pTable.isArrayOnly, {"foo", "bar", "baz"})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not just an array (non-numeric indices)", pTable.isArrayOnly, {"foo", "bar", "baz", a=1})
		self:isEvalFalse(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not just an array (index 0 is populated)", pTable.isArrayOnly, {[0]=0, 1, 2, 3})
		self:isEvalFalse(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not an array (sparse)", pTable.isArrayOnly, {1, 2, nil, 4, 5})
		self:isEvalFalse(ret)
	end
	--]====]
end
)


self:registerFunction("pTable.isArrayOnlyZero()", pTable.isArrayOnlyZero)


-- [===[
self:registerJob("pTable.isArrayOnlyZero()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.isArrayOnlyZero, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table", pTable.isArrayOnlyZero, {})
		self:isEqual(ret, true)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("array", pTable.isArrayOnlyZero, {"foo", "bar", "baz"})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not just an array (non-numeric indices)", pTable.isArrayOnlyZero, {"foo", "bar", "baz", a=1})
		self:isEvalFalse(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("An array with index 0 populated)", pTable.isArrayOnlyZero, {[0]=0, 1, 2, 3})
		self:isEvalTrue(ret)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("not an array (sparse)", pTable.isArrayOnlyZero, {[0]=0, 1, 2, nil, 4, 5})
		self:isEvalFalse(ret)
	end
	--]====]
end
)


self:registerFunction("pTable.arrayHasDuplicateValues()", pTable.arrayHasDuplicateValues)


-- [===[
self:registerJob("pTable.arrayHasDuplicateValues()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.arrayHasDuplicateValues, 123)

	-- [====[
	do
		local ret = self:expectLuaReturn("empty table (do nothing)", pTable.arrayHasDuplicateValues, {})
		self:isEqual(ret, nil)
	end
	--]====]


	-- [====[
	do
		local ret = self:expectLuaReturn("no duplicates", pTable.arrayHasDuplicateValues, {1, 2, 3, 4, 5})
		self:isEqual(ret, nil)
	end
	--]====]


	-- [====[
	do
		local r1, r2 = self:expectLuaReturn("has duplicates", pTable.arrayHasDuplicateValues, {1, 2, 3, 4, 1})
		self:isEqual(r1, 1)
		self:isEqual(r2, 5)
	end
	--]====]
end
)


self:registerFunction("pTable.newLUT()", pTable.newLUT)


-- [===[
self:registerJob("pTable.newLUT()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.newLUT, 123)

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.newLUT, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", pTable.newLUT, {1, 2, "a", "Z"})
		self:isEqual(output[1], true)
		self:isEqual(output[2], true)
		self:isEqual(output.a, true)
		self:isEqual(output.Z, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.newLUTV()", pTable.newLUTV)


-- [===[
self:registerJob("pTable.newLUTV()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.newLUTV, nil)

	-- [====[
	do
		local output = self:expectLuaReturn("empty vararg", pTable.newLUTV)
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", pTable.newLUTV, 1, 2, "a", "Z")
		self:isEqual(output[1], true)
		self:isEqual(output[2], true)
		self:isEqual(output.a, true)
		self:isEqual(output.Z, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.invertLUT()", pTable.invertLUT)


-- [===[
self:registerJob("pTable.invertLUT()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.invertLUT, 123)
	self:expectLuaError("duplicate values", pTable.invertLUT, {a=1, b=1})

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.invertLUT, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("make inverted lookup table", pTable.invertLUT, {a=1, b=2, c=3})
		self:isEqual(output[1], "a")
		self:isEqual(output[2], "b")
		self:isEqual(output[3], "c")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.arrayOfHashKeys()", pTable.arrayOfHashKeys)


-- [===[
self:registerJob("pTable.arrayOfHashKeys()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.arrayOfHashKeys, 123)

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.arrayOfHashKeys, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local hash = {a=1, b=2, c=3}
		local output = self:expectLuaReturn("make array of hash table", pTable.arrayOfHashKeys, hash)

		self:print(4, "NOTE: The results are unordered. We will delete from the source hash table as values are confirmed.")
		for i, v in ipairs(output) do
			if hash[v] then
				hash[v] = nil
			end
		end
		self:isEqual(next(hash), nil)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.moveElement()", pTable.moveElement)


-- [===[
self:registerJob("pTable.moveElement()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.moveElement, 123)
	self:expectLuaError("arg #2 bad type", pTable.moveElement, {1, 2, 3}, "foo", 3)
	self:expectLuaError("arg #3 bad type", pTable.moveElement, {1, 2, 3}, 1, "bar")
	self:expectLuaError("first index is unpopulated", pTable.moveElement, {1, 2, 3}, 90, 1)
	self:expectLuaError("second index is unpopulated", pTable.moveElement, {1, 2, 3}, 1, 240)


	-- [====[
	do
		local t = {"a", "b", "c"}
		self:expectLuaReturn("swap self (ie do nothing)", pTable.moveElement, t, 2, 2)
		self:isEqual(t[2], "b")
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c"}
		self:expectLuaReturn("Move first value to the end", pTable.moveElement, t, 1, 3)
		self:isEqual(t[1], "b")
		self:isEqual(t[2], "c")
		self:isEqual(t[3], "a")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.swapElements()", pTable.swapElements)


-- [===[
self:registerJob("pTable.swapElements()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.swapElements, 123)
	self:expectLuaError("arg #2 bad type", pTable.swapElements, {1, 2, 3}, "foo", 3)
	self:expectLuaError("arg #3 bad type", pTable.swapElements, {1, 2, 3}, 1, "bar")
	self:expectLuaError("first index is unpopulated", pTable.swapElements, {1, 2, 3}, 90, 1)
	self:expectLuaError("second index is unpopulated", pTable.swapElements, {1, 2, 3}, 1, 240)


	-- [====[
	do
		local t = {"a", "b", "c"}
		self:expectLuaReturn("swap self (ie do nothing)", pTable.swapElements, t, 2, 2)
		self:isEqual(t[2], "b")
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c"}
		self:expectLuaReturn("Swap first and last values", pTable.swapElements, t, 1, 3)
		self:isEqual(t[1], "c")
		self:isEqual(t[2], "b")
		self:isEqual(t[3], "a")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.reverseArray()", pTable.reverseArray)


-- [===[
self:registerJob("pTable.reverseArray()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.reverseArray, 123)

	-- [====[
	do
		local t = {"a"}
		self:expectLuaReturn("reverse array with < 2 items (ie do nothing)", pTable.reverseArray, t)
		self:isEqual(t[1], "a")
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c"}
		self:expectLuaReturn("reverse array with odd # of indices", pTable.reverseArray, t)
		self:isEqual(t[1], "c")
		self:isEqual(t[2], "b")
		self:isEqual(t[3], "a")
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", "d"}
		self:expectLuaReturn("reverse array with even # of indices", pTable.reverseArray, t)
		self:isEqual(t[1], "d")
		self:isEqual(t[2], "c")
		self:isEqual(t[3], "b")
		self:isEqual(t[4], "a")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.removeElement()", pTable.removeElement)


-- [===[
self:registerJob("pTable.removeElement()", function(self)
	-- [====[
	do
		self:expectLuaError("Argument #1 bad type", pTable.removeElement, false, true, 5)
		-- Don't bother type checking arg #2
		self:expectLuaError("Argument #3 bad type", pTable.removeElement, false, true, {})
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", "d", "e"}
		self:print(4, "Remove one element")
		local c = pTable.removeElement(t, "c")
		self:isEqual(t[1], "a")
		self:isEqual(t[2], "b")
		self:isEqual(t[3], "d")
		self:isEqual(t[4], "e")
		self:isEqual(c, 1)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", "b", "e"}
		self:print(4, "Remove multiple elements")
		local c = pTable.removeElement(t, "b")
		self:isEqual(t[1], "a")
		self:isEqual(t[2], "c")
		self:isEqual(t[3], "e")
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local t = {"b", "a", "b", "c", "b", "e", "b"}
		self:print(4, "Remove multiple elements across multiple calls")
		local c = pTable.removeElement(t, "b", 2)
		self:isEqual(t[1], "b")
		self:isEqual(t[2], "a")
		self:isEqual(t[3], "b")
		self:isEqual(t[4], "c")
		self:isEqual(t[5], "e")
		self:isEqual(c, 2)
		self:lf(1)

		c = pTable.removeElement(t, "b", 2)
		self:isEqual(t[1], "a")
		self:isEqual(t[2], "c")
		self:isEqual(t[3], "e")
		self:isEqual(c, 2)
		self:lf(1)

		c = pTable.removeElement(t, "b", 2)
		self:isEqual(t[1], "a")
		self:isEqual(t[2], "c")
		self:isEqual(t[3], "e")
		self:isEqual(c, 0)
		self:lf(1)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.valueInArray()", pTable.valueInArray)


-- [===[
self:registerJob("pTable.valueInArray()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.valueInArray, 123)
	-- Don't check arg 2

	-- [====[
	do
		local t = {"a", "b", "c", "d", "e", "f", "g"}
		local ret = self:expectLuaReturn("find the index for 'c'", pTable.valueInArray, t, "c")
		self:isEqual(ret, 3)
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", "d", "e", "f", "g"}
		local ret = self:expectLuaReturn("look unsuccessfully for 'x'", pTable.valueInArray, t, "x")
		self:isEqual(ret, nil)
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", "c", "b", "a"}
		self:print(4, "find all indices with values of 'b'")
		local indices = {}
		local i = 1
		while i do
			i = pTable.valueInArray(t, "b", i)
			if i then
				table.insert(indices, i)
				i = i + 1
			end
		end

		self:isEqual(indices[1], 2)
		self:isEqual(indices[2], 5)
		self:isEqual(indices[3], nil)
	end
	--]====]


	-- [====[
	do
		local t = {"a", "b", "c", nil}
		local ret = self:expectLuaReturn("looking for nil always returns nil", pTable.valueInArray, t, nil)
		self:isEqual(ret, nil)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.assignIfNil()", pTable.assignIfNil)


-- [===[
self:registerJob("pTable.assignIfNil()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.assignIfNil, 123)
	self:expectLuaError("arg #2 bad type", pTable.assignIfNil, {}, nil)

	-- [====[
	do
		local t = {}
		self:print(4, "assign nothing")
		pTable.assignIfNil(t, "foo")
		self:isEqual(t.foo, nil)
	end
	--]====]


	-- [====[
	do
		local t = {}
		self:print(4, "assign vararg 1")
		pTable.assignIfNil(t, "foo", "bar", "baz")
		self:isEqual(t.foo, "bar")
	end
	--]====]


	-- [====[
	do
		local t = {}
		self:print(4, "assign vararg 2")
		pTable.assignIfNil(t, "foo", nil, "baz")
		self:isEqual(t.foo, "baz")
	end
	--]====]


	-- [====[
	do
		local t = {foo=true}
		self:print(4, "key is already assigned")
		pTable.assignIfNil(t, "foo", "bar", "baz")
		self:isEqual(t.foo, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.assignIfNilOrFalse()", pTable.assignIfNilOrFalse)


-- [===[
self:registerJob("pTable.assignIfNilOrFalse()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.assignIfNilOrFalse, 123)
	self:expectLuaError("arg #2 bad type", pTable.assignIfNilOrFalse, {}, nil)

	-- [====[
	do
		local t = {}
		self:print(4, "assign nothing")
		pTable.assignIfNilOrFalse(t, "foo")
		self:isEqual(t.foo, nil)
	end
	--]====]


	-- [====[
	do
		local t = {}
		self:print(4, "assign vararg 1")
		pTable.assignIfNilOrFalse(t, "foo", "bar", "baz")
		self:isEqual(t.foo, "bar")
	end
	--]====]


	-- [====[
	do
		local t = {foo=false}
		self:print(4, "assign vararg 2")
		pTable.assignIfNilOrFalse(t, "foo", nil, "baz")
		self:isEqual(t.foo, "baz")
	end
	--]====]


	-- [====[
	do
		local t = {foo=true}
		self:print(4, "key is already assigned")
		pTable.assignIfNilOrFalse(t, "foo", "bar", "baz")
		self:isEqual(t.foo, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.resolve()", pTable.resolve)


-- [===[
self:registerJob("pTable.resolve()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.resolve, 123, "foo/bar")

	self:expectLuaError("arg #2 bad type", pTable.resolve, {}, nil)
	self:expectLuaError("arg #2 cannot resolve an empty string", pTable.resolve, {}, "")
	self:expectLuaError("arg #2 empty fields are not allowed (start)", pTable.resolve, {}, "/bar")
	self:expectLuaError("arg #2 empty fields are not allowed (middle)", pTable.resolve, {foo={[""]={bar=true}}}, "foo//bar")
	self:expectLuaError("arg #2 empty fields are not allowed (last)", pTable.resolve, {foo={bar={[""]=true}}}, "foo/bar/")

	-- [====[
	do
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		self:print(4, "OK lookup")
		local v, c = pTable.resolve(t, "foo/bar")
		self:isEqual(v, "zoop")
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		self:print(4, "Failed (but non-fatal) lookup")
		local v, c = pTable.resolve(t, "foo/bar/zyp")
		self:isEqual(v, nil)
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local mt = {dip = "flip"}
		mt.__index = mt
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		setmetatable(t.foo, mt)
		self:print(4, "OK lookup with metatables")
		local v, c = pTable.resolve(t, "foo/dip")
		self:isEqual(v, "flip")
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local mt = {dip = "flip"}
		mt.__index = mt
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		setmetatable(t.foo, mt)
		self:print(4, "Failed (but non-fatal) lookup, ignoring metatables")
		local v, c = pTable.resolve(t, "foo/dip", true)
		self:isEqual(v, nil)
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.assertResolve()", pTable.assertResolve)


-- [===[
self:registerJob("pTable.assertResolve()", function(self)
	-- [====[
	do
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		self:print(4, "OK lookup")
		local v, c = pTable.assertResolve(t, "foo/bar")
		self:isEqual(v, "zoop")
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		self:expectLuaError("Failed, fatal lookup", pTable.assertResolve, t, "foo/bar/zyp")
	end
	--]====]


	-- [====[
	do
		local mt = {dip = "flip"}
		mt.__index = mt
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		setmetatable(t.foo, mt)
		self:print(4, "OK lookup with metatables")
		local v, c = pTable.assertResolve(t, "foo/dip")
		self:isEqual(v, "flip")
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]


	-- [====[
	do
		local mt = {dip = "flip"}
		mt.__index = mt
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		setmetatable(t.foo, mt)
		self:expectLuaError("Failed, fatal lookup, ignoring metatables", pTable.assertResolve, t, "foo/dip", true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.wrap1Array()", pTable.wrap1Array)


-- [===[
self:registerJob("pTable.wrap1Array()", function(self)

	-- [====[
	do
		local t = {"one", "two", "three"}
		local rv = self:expectLuaReturn("index 2", pTable.wrap1Array, t, 2)
		self:isEqual(rv, "two")
	end
	--]====]


	-- [====[
	do
		local t = {"one", "two", "three"}
		local rv = self:expectLuaReturn("index 4", pTable.wrap1Array, t, 4)
		self:isEqual(rv, "one")
	end
	--]====]


	-- [====[
	do
		local t = {"one", "two", "three"}
		local rv = self:expectLuaReturn("index 0", pTable.wrap1Array, t, 0)
		self:isEqual(rv, "three")
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.safeTableConcat()", pTable.safeTableConcat)


-- [===[
self:registerJob("pTable.safeTableConcat()", function(self)
	-- M.safeTableConcat(t, sep, i, j)

	-- [====[
	do
		local rv
		rv = self:expectLuaReturn("success", pTable.safeTableConcat, {"F", "O", 0, "B", true, "R"}, "*")
		self:isEqual(rv, "F*O*0*B*true*R")

		rv = self:expectLuaReturn("test partial concatenation", pTable.safeTableConcat, {1, 2, 3, 4, 5, 6, 7, 8}, ":", 3, 6)
		self:isEqual(rv, "3:4:5:6")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad type", pTable.safeTableConcat, true, "!", 1, 4)
		self:expectLuaError("arg 2 bad type", pTable.safeTableConcat, {}, true, 1, 4)
		self:expectLuaError("arg 3 bad type", pTable.safeTableConcat, {}, "!", true, 4)
		self:expectLuaError("arg 4 bad type", pTable.safeTableConcat, {}, "!", 3, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.newNamedMap()", pTable.newNamedMap)


-- [===[
self:registerJob("pTable.newNamedMap()", function(self)

	-- [====[
	do
		local t = {left=0.0, center=0.5, right=1.0}
		local rv = self:expectLuaReturn("success", pTable.newNamedMap, "ObjectSide", t)
		self:isEqual(t, rv)
		self:isEqual(pName.get(rv), "ObjectSide")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad type", pTable.newNamedMap, true, {})
		self:expectLuaError("arg 2 bad type", pTable.newNamedMap, "Foobar", true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.newNamedMapV()", pTable.newNamedMapV)


-- [===[
self:registerJob("pTable.newNamedMapV()", function(self)

	-- [====[
	do
		local rv = self:expectLuaReturn("success", pTable.newNamedMapV, "ObjectSide", "left", "center", "right")
		self:isEqual(rv.left, true)
		self:isEqual(rv.center, true)
		self:isEqual(rv.right, true)
		self:isEqual(pName.get(rv), "ObjectSide")
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("arg 1 bad type", pTable.newNamedMapV, true, 1, 2, 3)
		self:expectLuaError("vararg cannot be explicit nil", pTable.newNamedMapV, "Foobar", nil)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("pTable.mt_restrict", function(self)

	local mt = pTable.mt_restrict

	-- [====[
	do
		local t = {foo=false}
		setmetatable(t, mt)
		local function testIt()
			local t2 = {}
			t2.x = t.foo
			return t2
		end
		local rv = self:expectLuaReturn("expected behavior (read)", testIt)
		self:isEqual(rv.x, false)
	end
	--]====]


	-- [====[
	do
		local t = {foo="bar"}
		setmetatable(t, mt)
		local function testIt()
			t.foo = "bop"
			return true
		end
		self:expectLuaReturn("expected behavior (write)", testIt)
		self:isEqual(t.foo, "bop")
	end
	--]====]


	-- [====[
	do
		local t = {}
		setmetatable(t, mt)
		local function testIt()
			return rawget(t, "nothin'")
		end
		local rv = self:expectLuaReturn("can't stop rawget", testIt)
		self:isEqual(rv, nil)
	end
	--]====]


	-- [====[
	do
		local t = {}
		setmetatable(t, mt)
		local function testIt()
			return rawset(t, "somethin'", true)
		end
		self:expectLuaReturn("can't stop rawset", testIt)
		self:isEqual(t["somethin'"], true)
	end
	--]====]


	-- [====[
	do
		local t = {}
		setmetatable(t, mt)
		local function testIt()
			table.insert(t, "zoop")
			return t[1]
		end

		--[[
		In Lua 5.3, the table library was changed to respect metamethods.
		https://www.lua.org/manual/5.3/manual.html#8.2
		--]]

		if _VERSION == "Lua 5.1" or _VERSION == "Lua 5.2" then
			local rv = self:expectLuaReturn("Lua 5.1, 5.2: can't stop table.insert()", testIt)
			self:isEqual(t[1], rv)

		elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4" then
			self:expectLuaError("Lua 5.3, 5.4: stop table.insert()", testIt)

		else
			error("unsupported Lua version: " .. tostring(_VERSION))
		end
	end
	--]====]


	-- [====[
	do
		local t = {"fwoowf"}
		setmetatable(t, mt)
		local function testIt()
			return table.remove(t)
		end
		local rv = self:expectLuaReturn("can't stop table.remove()", testIt)
		self:isEqual(rv, "fwoowf")
	end
	--]====]


	-- [====[
	do
		local t = {}
		setmetatable(t, mt)
		local function testIt()
			local t2 = {}
			t2.x = t.foo
			return t2
		end
		local rv = self:expectLuaError("field read blocked", testIt)
	end
	--]====]


	-- [====[
	do
		local t = {}
		setmetatable(t, mt)
		local function testIt()
			t.foo = "bop"
			return true
		end
		self:expectLuaError("field write blocked", testIt)
	end
	--]====]
end
)
--]===]


self:runJobs()
