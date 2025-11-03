-- Test: pile_schema.lua
-- v1.315


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")


local pAssert = require(PATH .. "pile_assert")
local pSchema = require(PATH .. "pile_schema")
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


-- Used in various tests as a stand-in for checking metatables.
local _dummy_mt = {}
local function _metatableStandIn(n, v)
	if v ~= _dummy_mt then
		error("wrong metatable")
	end
end


local self = errTest.new("PILE Schema", cli_verbosity)


-- [===[
self:registerFunction("pSchema.validate()", pSchema.validate)
self:registerJob("pSchema.validate", function(self)
	-- [====[
	do
		local tbl = {}
		local md = pSchema.newModel {}

		self:expectLuaReturn("validate (empty model, empty target)", pSchema.validate, md, tbl, "Test Validate")
	end
	--]====]


	-- [====[
	do
		local tbl = {foo="bar"}
		local md = pSchema.newModel {
			keys = {
				foo = {pAssert.type, "number"}
			}
		}

		self:expectLuaError("validate failure, with 'fatal' flag", pSchema.validate, md, tbl, "Test Validate (Fatal)", true)
	end
	--]====]


	-- [====[
	do
		self:expectLuaError("pSchema.validate() arg 1 bad type", pSchema.validate, function() end, {}, "Foo")
		self:expectLuaError("pSchema.validate() arg 2 bad type", pSchema.validate, pSchema.newModel {}, true, "Foo")
		self:expectLuaError("pSchema.validate() arg 3 bad type", pSchema.validate, pSchema.newModel {}, {}, true)
		-- don't test arg 4 (fatal)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pSchema.newModel()", pSchema.newModel)
self:registerJob("pSchema.newModel", function(self)
	-- [====[
	do
		local m1 = pSchema.newModel{
			keys = {
				foo = {pAssert.type, "string"}
			}
		}

		local t1 = {
			foo = "bar",
		}

		local ok, err
		ok, err = self:expectLuaReturn("newModel success", pSchema.validate, m1, t1, "Test")
		self:isEqual(ok, true)

		self:expectLuaError("arg 1 bad type", pSchema.newModel, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pSchema.newKeysX()", pSchema.newKeysX)
self:registerJob("pSchema.newKeysX", function(self)
	-- [====[
	do
		local m1 = pSchema.newKeysX {
			foo = {pAssert.type, "string"}
		}

		local t1 = {
			foo = "bar",
		}

		local ok, err
		ok, err = self:expectLuaReturn("'newKeysX' model success", pSchema.validate, m1, t1, "Test")
		self:isEqual(ok, true)

		self:expectLuaError("arg 1 bad type", pSchema.newKeysX, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pSchema.checkModel()", pSchema.checkModel)
self:registerJob("pSchema.checkModel", function(self)
	-- [====[
	do
		local base_md = pSchema.newModel {
			metatable = _metatableStandIn,

			keys = {
				foo = {pAssert.type, "string"}
			},

			array = {pAssert.type, "number"},

			remaining = {pAssert.type, "function"}
		}
		self:expectLuaReturn("success", pSchema.checkModel, base_md)

		local m2 = setmetatable(pTable.copy(base_md), getmetatable(base_md))
		m2.metatable = true
		self:expectLuaError("bad 'metatable' filter", pSchema.checkModel, m2)

		local m3 = setmetatable(pTable.copy(base_md), getmetatable(base_md))
		m3.keys = function() end
		self:expectLuaError("bad 'keys' filter", pSchema.checkModel, m3)

		local m4 = setmetatable(pTable.copy(base_md), getmetatable(base_md))
		m4.array = 1234
		self:expectLuaError("bad 'array' filter", pSchema.checkModel, m3)

		local m5 = setmetatable(pTable.copy(base_md), getmetatable(base_md))
		m5.remaining = true
		self:expectLuaError("bad 'remaining' filter", pSchema.checkModel, m3)


		-- model options
		local m6 = pSchema.newModel {}

		m6.reject_unhandled = 123
		self:expectLuaError("option: reject_unhandled, bad type", pSchema.checkModel, m6)
		m6.reject_unhandled = nil

		m6.array_len = true
		self:expectLuaError("option: array_len, bad type", pSchema.checkModel, m6)
		m6.array_len = nil

		m6.array_min = true
		self:expectLuaError("option: array_min, bad type", pSchema.checkModel, m6)
		m6.array_min = nil

		m6.array_max = true
		self:expectLuaError("option: array_max, bad type", pSchema.checkModel, m6)
		m6.array_max = nil


		self:expectLuaError("arg 1 bad type", pSchema.checkModel, true)
		self:expectLuaError("arg 1 incorrect metatable", pSchema.checkModel, {})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Sub-Model References", function(self)

	-- "long form" reference
	-- [====[
	do
		local md_aux = pSchema.newModel {
			keys = {
				doop = {pAssert.type, "string"}
			}
		}

		local md_main = pSchema.newModel {
			keys = {
				foo = {pAssert.type, "number"},
				bar = {"sub", md_aux}
			}
		}

		local t1 = {
			foo = 1,
			bar = {
				doop = "bar"
			}
		}

		local ok, err = self:expectLuaReturn("model reference (long): success", pSchema.validate, md_main, t1, "SubModelTest")
		if err then
			self:print(4, err)
		end
		self:isEqual(ok, true)

		-- failure
		md_main.keys.bar[2] = "not a model"
		self:expectLuaError("failure (not a model)", pSchema.validate, md_main, t1, "SubModelTest")
	end
	--]====]


	-- "short form" reference
	-- [====[
	do
		local md_aux = pSchema.newModel {
			keys = {
				doop = {pAssert.type, "string"}
			}
		}

		local md_main = pSchema.newModel {
			keys = {
				foo = {pAssert.type, "number"},
				bar = md_aux
			}
		}

		local t1 = {
			foo = 1,
			bar = {
				doop = "bar"
			}
		}

		local ok, err = self:expectLuaReturn("model Reference (short): success", pSchema.validate, md_main, t1, "SubModelTest")
		if err then
			self:print(4, err)
		end
		self:isEqual(ok, true)

		-- failure
		md_main.keys.bar = "not a model"
		self:expectLuaError("failure (not a model)", pSchema.validate, md_main, t1, "SubModelTest")
	end
	--]====]


	-- "eval" reference
	-- [====[
	do
		local md_aux = pSchema.newModel {
			keys = {
				doop = {pAssert.type, "string"}
			}
		}

		local md_main = pSchema.newModel {
			keys = {
				foo = {pAssert.type, "number"},
				bar = {"sub-eval", md_aux},
				baz = {"sub-eval", md_aux}
			}
		}

		local t1 = {
			foo = 1,
			bar = {
				doop = "bar"
			},
			baz = false,
		}

		local ok, err = self:expectLuaReturn("model reference (eval): success", pSchema.validate, md_main, t1, "SubModelTest")
		if err then
			self:print(4, err)
		end
		self:isEqual(ok, true)

		-- failure
		md_main.keys.bar[2] = "not a model"
		self:expectLuaError("failure (not a model)", pSchema.validate, md_main, t1, "SubModelTest")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("model and (some) handler tests", function(self)
	-- [====[
	do
		local m1 = pSchema.newModel {
			metatable = _metatableStandIn,

			keys = {
				foo = {pAssert.type, "string"}
			},

			array = {pAssert.type, "number"},

			remaining = {pAssert.type, "function"}
		}

		local t1 = setmetatable({
			foo = "bar",
			5, 7, 9, 3,
			[{}] = math.sin
		}, _dummy_mt)

		local ok, err
		ok, err = self:expectLuaReturn("model success", pSchema.validate, m1, t1, "Test")
		self:isEqual(ok, true)


		local t2 = {
			foo = "bar",
			5, 7, 9, 3,
			[{}] = math.sin
		}

		ok, err = self:expectLuaReturn("model failure (metatable)", pSchema.validate, m1, t2, "Test")
		self:isEqual(ok, false)
		self:print(4, err)


		local t3 = setmetatable({
			foo = "bar",
			false, true,
			[{}] = math.sin
		}, _dummy_mt)

		ok, err = self:expectLuaReturn("model failure (array)", pSchema.validate, m1, t3, "Test")
		self:isEqual(ok, false)
		self:print(4, err)


		local t4 = setmetatable({
			foo = "bar",
			5, 7, 9, 3,
			[{}] = false,
		}, _dummy_mt)

		ok, err = self:expectLuaReturn("model failure (remaining)", pSchema.validate, m1, t4, "Test")
		self:isEqual(ok, false)
		self:print(4, err)


		local m2 = pSchema.newModel {
			metatable = _metatableStandIn,

			keys = {
				foo = {pAssert.type, "string"}
			},

			array = {pAssert.type, "number"},
		}

		local t5 = setmetatable({
			foo = "bar",
			5, 7, 9, 3,
			[{}] = false,
		}, _dummy_mt)

		ok, err = self:expectLuaReturn("model success (ignore unhandled)", pSchema.validate, m2, t5, "Test")
		self:isEqual(ok, true)


		local m3 = pSchema.newModel {
			reject_unhandled = true,

			metatable = _metatableStandIn,

			keys = {
				foo = {pAssert.type, "string"}
			},

			array = {pAssert.type, "number"},
		}

		local t6 = setmetatable({
			foo = "bar",
			5, 7, 9, 3,
			[{}] = false,
		}, _dummy_mt)

		ok, err = self:expectLuaReturn("model failure (reject unhandled)", pSchema.validate, m3, t6, "Test")
		self:isEqual(ok, false)
		self:print(4, err)


		local m4 = pSchema.newModel {
			-- will adjust 'array_*' options below
			array = {pAssert.type, "number"},
		}

		local t7 = {1, 2, 3, 4, 5}

		m4.array_len = 3
		ok, err = self:expectLuaReturn("model failure (incorrect array length)", pSchema.validate, m4, t7, "Test")
		self:isEqual(ok, false)
		self:print(4, err)
		m4.array_len = nil

		m4.array_min = 30
		ok, err = self:expectLuaReturn("model failure (array is below the minimum)", pSchema.validate, m4, t7, "Test")
		self:isEqual(ok, false)
		self:print(4, err)
		m4.array_min = nil

		m4.array_max = 2
		ok, err = self:expectLuaReturn("model failure (array is above the maximum)", pSchema.validate, m4, t7, "Test")
		self:isEqual(ok, false)
		self:print(4, err)
		m4.array_max = nil


		local m5 = pSchema.newModel {
			keys = {
				[1] = {pAssert.type, "string"},
				[3] = {pAssert.type, "string"},
				[5] = {pAssert.type, "string"},
			},

			array = {pAssert.type, "number"},
		}

		local t8 = {"foo", 2, "bar", 4, "bop", 6}

		ok, err = self:expectLuaReturn("model success (key filter overrides array filter", pSchema.validate, m5, t8, "Test")
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pSchema.setMaxMessages()", pSchema.setMaxMessages)
self:registerFunction("pSchema.getMaxMessages()", pSchema.getMaxMessages)
self:registerJob("pSchema.setMaxMessages(), pSchema.getMaxMessages()", function(self)

	-- [====[
	do
		local tbl = {}
		for i = 1, 10 do
			tbl[i] = "foo"
		end

		local md = pSchema.newModel {
			array = {pAssert.type, "number"}
		}

		local ok, err

		pSchema.setMaxMessages(5)
		ok, err = self:expectLuaReturn("Exhaust max messages", pSchema.validate, md, tbl, "Test Max Messages")
		self:isEqual(ok, false)
		self:print(4, err)

		local msg_max = pSchema.lang.msg_max -- "(maximum message size reached)"
		self:isEqual(err:sub(-#msg_max), msg_max)
		pSchema.setMaxMessages()
	end
	--]====]


	-- [====[
	do
		pSchema.setMaxMessages(23)
		local n = self:expectLuaReturn("getMaxMessages", pSchema.getMaxMessages)
		self:isEqual(n, 23)
		pSchema.setMaxMessages()
	end
	--]====]

	-- [====[
	do
		self:expectLuaError("pSchema.setMaxMessages() arg 1 bad type", pSchema.setMaxMessages, true)
		self:expectLuaError("pSchema.setMaxMessages() arg 1 too low", pSchema.setMaxMessages, 0)
	end
	--]====]
end
)
--]===]


self:runJobs()
