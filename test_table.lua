-- Test: pile_table.lua
-- v1.1.6


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
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


self:registerFunction("pTable.clear()", pTable.clear)


-- [===[
self:registerJob("pTable.clear()", function(self)
	-- [====[
	do
		local t = {a="foo", b="bar", c="baz", 4, 5, 6}
		self:isNotNil(next(t))
		self:expectLuaReturn("clear table", pTable.clear, t)
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


self:registerFunction("pTable.makeLUT()", pTable.makeLUT)


-- [===[
self:registerJob("pTable.makeLUT()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.makeLUT, 123)

	-- [====[
	do
		local output = self:expectLuaReturn("empty table", pTable.makeLUT, {})
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", pTable.makeLUT, {1, 2, "a", "Z"})
		self:isEqual(output[1], true)
		self:isEqual(output[2], true)
		self:isEqual(output.a, true)
		self:isEqual(output.Z, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("pTable.makeLUTV()", pTable.makeLUTV)


-- [===[
self:registerJob("pTable.makeLUTV()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.makeLUTV, nil)

	-- [====[
	do
		local output = self:expectLuaReturn("empty vararg", pTable.makeLUTV)
		self:isEqual(next(output), nil)
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("create lookup table", pTable.makeLUTV, 1, 2, "a", "Z")
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


-- [===[
self:registerJob("pTable.resolve()", function(self)
	self:expectLuaError("arg #1 bad type", pTable.resolve, 123, "foo/bar")

	self:expectLuaError("arg #2 bad type", pTable.resolve, {}, nil)
	self:expectLuaError("arg #2 cannot resolve an empty string", pTable.resolve, {}, "")
	self:expectLuaError("arg #2 empty fields are not allowed (start)", pTable.resolve, {}, "//bar")
	self:expectLuaError("arg #2 empty fields are not allowed (middle)", pTable.resolve, {foo={[""]={bar=true}}}, "/foo//bar")
	self:expectLuaError("arg #2 empty fields are not allowed (last)", pTable.resolve, {foo={bar={[""]=true}}}, "/foo/bar/")

	-- [====[
	do
		local t = {
			foo = {
				bar = "zoop"
			}
		}
		self:print(4, "OK lookup")
		local v, c = pTable.resolve(t, "/foo/bar")
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
		local v, c = pTable.resolve(t, "/foo/bar/zyp")
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
		local v, c = pTable.resolve(t, "/foo/dip")
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
		local v, c = pTable.resolve(t, "/foo/dip", true)
		self:isEqual(v, nil)
		self:isEqual(c, 2)
		self:lf(1)
	end
	--]====]
end
)
--]===]


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
		local v, c = pTable.assertResolve(t, "/foo/bar")
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
		self:expectLuaError("Failed, fatal lookup", pTable.assertResolve, t, "/foo/bar/zyp")
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
		local v, c = pTable.assertResolve(t, "/foo/dip")
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
		self:expectLuaError("Failed, fatal lookup, ignoring metatables", pTable.assertResolve, t, "/foo/dip", true)
	end
	--]====]
end
)
--]===]


self:runJobs()
