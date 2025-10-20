-- Test: pile_schema.lua
-- v1.300


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")


local pSchema = require(PATH .. "pile_schema")


-- Grab a copy of the Validator metatable.
local _mt_val
do
	local v = pSchema.newValidator()
	_mt_val = getmetatable(v)
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


-- Used in various tests as a stand-in for checking metatables.
local _dummy_mt = {}
local function _metatableStandIn(k, v)
	if v == _dummy_mt then
		return true
	else
		return false, "wrong metatable"
	end
end


local self = errTest.new("PILE Schema", cli_verbosity)


self:registerFunction("pSchema.newValidator", pSchema.newValidator)


-- [===[
self:registerJob("pSchema.newValidator", function(self)
	-- [====[
	do
		local v = self:expectLuaReturn("factory default new Validator", pSchema.newValidator)
		self:isEqual(next(v.models), nil)
		self:isEqual(v.name, "Unnamed")
		self:isEqual(v.user, false)
	end
	--]====]

	-- [====[
	do
		local v = self:expectLuaReturn("new Validator with name", pSchema.newValidator, "FooBar")
		self:isEqual(v.name, "FooBar")
		self:isEqual(v.user, false)
	end
	--]====]

	-- [====[
	do
		local models = {}
		local v = self:expectLuaReturn("new Validator with name and table of Models", pSchema.newValidator, "FooBar", models)
		self:isEqual(v.name, "FooBar")
		self:isEqual(v.user, false)
		self:isEqual(v.models, models)
	end
	--]====]

	-- [====[
	do
		self:expectLuaError("arg 1 bad type", pSchema.newValidator, true, {})
		self:expectLuaError("arg 2 bad type", pSchema.newValidator, "Foo", true)
	end
	--]====]
end
)
--]===]


self:registerFunction("Validator:setName", _mt_val.setName)
self:registerFunction("Validator:getName", _mt_val.getName)


-- [===[
self:registerJob("Validator:setName, Validator:getName", function(self)
	-- [====[
	do
		local v = pSchema.newValidator()
		self:expectLuaReturn("setName", _mt_val.setName, v, "Newwmann")
		local my_name = self:expectLuaReturn("setName", _mt_val.getName, v)
		self:isEqual(my_name, "Newwmann")
	end
	--]====]

	-- [====[
	do
		local v = pSchema.newValidator()
		self:expectLuaError("arg 1 bad type", _mt_val.setName, v, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("Validator:setModel", _mt_val.setModel)
self:registerFunction("Validator:getModel", _mt_val.getModel)


-- [===[
self:registerJob("Validator:setModel, Validator:getModel", function(self)
	-- [====[
	do
		local models = pSchema.models
		local model = models.keys {}
		local v = pSchema.newValidator()
		self:expectLuaReturn("setModel", _mt_val.setModel, v, "main", model)
		local get_model = self:expectLuaReturn("getModel", _mt_val.getModel, v, "main")
		self:isEqual(get_model, model)
		self:expectLuaReturn("remove Model", _mt_val.setModel, v, "main", false)
		local get_model2 = self:expectLuaReturn("getModel", _mt_val.getModel, v, "main")
		self:isEqual(get_model2, nil)
	end
	--]====]

	-- [====[
	do
		local v = pSchema.newValidator()
		self:expectLuaError("setModel() arg 1 bad type", _mt_val.setModel, v, true, {})
		self:expectLuaError("setModel() arg 2 bad type", _mt_val.setModel, v, "main", true)

		self:expectLuaError("getModel() arg 1 bad type", _mt_val.setModel, v, true)
	end
	--]====]
end
)
--]===]


self:registerFunction("Validator:setUserTable", _mt_val.setUserTable)
self:registerFunction("Validator:getUserTable", _mt_val.getUserTable)


-- [===[
self:registerJob("Validator:setUserTable, Validator:getUserTable", function(self)
	-- [====[
	do
		local user = {}
		local v = pSchema.newValidator()
		self:expectLuaReturn("setUserTable", _mt_val.setUserTable, v, user)
		local get_user = self:expectLuaReturn("getUserTable", _mt_val.getUserTable, v)
		self:isEqual(get_user, user)
		self:expectLuaReturn("remove User table", _mt_val.setUserTable, v, nil)
		local get_user2 = self:expectLuaReturn("getUserTable", _mt_val.getUserTable, v)
		self:isEqual(get_user2, false)
	end
	--]====]

	-- [====[
	do
		local v = pSchema.newValidator()
		self:expectLuaError("arg 1 bad type", _mt_val.setUserTable, v, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Validator:validate", function(self)
	-- [====[
	do
		local models = pSchema.models
		local tbl = {}
		local v = pSchema.newValidator("empty", {
			main = models.keys {}
		})

		self:expectLuaReturn("validate (empty model, empty target)", _mt_val.validate, v, tbl)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local tbl = {foo="bar"}
		local v = pSchema.newValidator("empty", {
			main = models.all {
				ref = handlers.fail
			}
		})

		self:expectLuaError("validate with 'fatal' setting (raise an error)", _mt_val.validate, v, tbl, nil, true)
	end
	--]====]


	-- [====[
	do
		local v = pSchema.newValidator()
		self:expectLuaError("validate() arg 1 bad type", _mt_val.validate, v, true, "main")
		self:expectLuaError("validate() arg 2 bad type", _mt_val.validate, v, {}, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model References", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("sub-table test", {
			main = models.keys {
				foo = handlers.number,
				bar = "aux"
			},

			aux = models.keys {
				doop = handlers.string
			}
		})

		local t1 = {
			foo = 1,
			bar = {
				doop = "bar"
			}
		}

		local ok, err = self:expectLuaReturn("Model Reference: success", _mt_val.validate, v, t1)
		if err then
			self:print(4, table.concat(err, "\n"))
		end
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("sub-table test", {
			main = models.keys {
				foo = handlers.number,
				bar = "my_invalid_ref"
			},

			aux = models.keys {
				doop = handlers.string
			}
		})

		local t1 = {
			foo = 1,
			bar = {
				doop = "bar"
			}
		}

		local ok, err = self:expectLuaReturn("Model Reference: failure (bad Model ID)", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Problems in Model creation functions", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		self:expectLuaError("keys: bad model", models.keys)

		self:expectLuaError("keysX: bad model", models.keysX)

		self:expectLuaError("keysM: bad model", models.keysM)
		self:expectLuaError("keysM: bad model.metatable", models.keysM, {keys={}})
		self:expectLuaError("keysM: bad model.keys", models.keysM, {metatable=handlers.pass})

		self:expectLuaError("keysMX: bad model", models.keysMX)
		self:expectLuaError("keysMX: bad model.metatable", models.keysMX, {keys={}})
		self:expectLuaError("keysMX: bad model.keys", models.keysMX, {metatable=handlers.pass})

		self:expectLuaError("array: bad model", models.array)
		self:expectLuaError("array: bad model.ref", models.array, {ref=true})
		self:expectLuaError("array: bad model.len", models.array, {ref=handlers.pass, len=true})
		self:expectLuaError("array: bad model.min", models.array, {ref=handlers.pass, min=true})
		self:expectLuaError("array: bad model.max", models.array, {ref=handlers.pass, max=true})

		self:expectLuaError("arrayX: bad model", models.arrayX)
		self:expectLuaError("arrayX: bad model.ref", models.arrayX, {ref=true})
		self:expectLuaError("arrayX: bad model.len", models.arrayX, {ref=handlers.pass, len=true})
		self:expectLuaError("arrayX: bad model.min", models.arrayX, {ref=handlers.pass, min=true})
		self:expectLuaError("arrayX: bad model.max", models.arrayX, {ref=handlers.pass, max=true})

		self:expectLuaError("arrayM: bad model", models.arrayM)
		self:expectLuaError("arrayM: bad model.metatable", models.arrayM, {keys={}})
		self:expectLuaError("arrayM: bad model.ref", models.arrayM, {metatable=handlers.pass, ref=true})
		self:expectLuaError("arrayM: bad model.len", models.arrayM, {metatable=handlers.pass, ref=handlers.pass, len=true})
		self:expectLuaError("arrayM: bad model.min", models.arrayM, {metatable=handlers.pass, ref=handlers.pass, min=true})
		self:expectLuaError("arrayM: bad model.max", models.arrayM, {metatable=handlers.pass, ref=handlers.pass, max=true})

		self:expectLuaError("arrayMX: bad model", models.arrayMX)
		self:expectLuaError("arrayMX: bad model.metatable", models.arrayMX, {ref=handlers.pass})
		self:expectLuaError("arrayMX: bad model.ref", models.arrayMX, {metatable=handlers.pass, ref=true})
		self:expectLuaError("arrayMX: bad model.len", models.arrayMX, {metatable=handlers.pass, ref=handlers.pass, len=true})
		self:expectLuaError("arrayMX: bad model.min", models.arrayMX, {metatable=handlers.pass, ref=handlers.pass, min=true})
		self:expectLuaError("arrayMX: bad model.max", models.arrayMX, {metatable=handlers.pass, ref=handlers.pass, max=true})

		self:expectLuaError("mixed: bad model", models.mixed)
		self:expectLuaError("mixed: bad model.keys", models.mixed, {keys=true, ref=handlers.pass})
		self:expectLuaError("mixed: bad model.ref", models.mixed, {keys={}, ref=true})
		self:expectLuaError("mixed: bad model.len", models.mixed, {keys={}, ref=handlers.pass, len=true})
		self:expectLuaError("mixed: bad model.min", models.mixed, {keys={}, ref=handlers.pass, min=true})
		self:expectLuaError("mixed: bad model.max", models.mixed, {keys={}, ref=handlers.pass, max=true})

		self:expectLuaError("mixedX: bad model", models.mixedX)
		self:expectLuaError("mixedX: bad model.keys", models.mixedX, {keys=true, ref=handlers.pass})
		self:expectLuaError("mixedX: bad model.ref", models.mixedX, {keys={}, ref=true})
		self:expectLuaError("mixedX: bad model.len", models.mixedX, {keys={}, ref=handlers.pass, len=true})
		self:expectLuaError("mixedX: bad model.min", models.mixedX, {keys={}, ref=handlers.pass, min=true})
		self:expectLuaError("mixedX: bad model.max", models.mixedX, {keys={}, ref=handlers.pass, max=true})

		self:expectLuaError("mixedM: bad model", models.mixedM)
		self:expectLuaError("mixedM: bad model.metatable", models.mixedM, {keys={}, ref=handlers.pass})
		self:expectLuaError("mixedM: bad model.keys", models.mixedM, {metatable=handlers.pass, keys=true, ref=handlers.pass})
		self:expectLuaError("mixedM: bad model.ref", models.mixedM, {metatable=handlers.pass, keys={}, ref=true})
		self:expectLuaError("mixedM: bad model.len", models.mixedM, {metatable=handlers.pass, keys={}, ref=handlers.pass, len=true})
		self:expectLuaError("mixedM: bad model.min", models.mixedM, {metatable=handlers.pass, keys={}, ref=handlers.pass, min=true})
		self:expectLuaError("mixedM: bad model.max", models.mixedM, {metatable=handlers.pass, keys={}, ref=handlers.pass, max=true})

		self:expectLuaError("mixedMX: bad model", models.mixedMX)
		self:expectLuaError("mixedMX: bad model.metatable", models.mixedMX, {keys={}, ref=handlers.pass})
		self:expectLuaError("mixedMX: bad model.keys", models.mixedMX, {metatable=handlers.pass, keys=true, ref=handlers.pass})
		self:expectLuaError("mixedMX: bad model.ref", models.mixedMX, {metatable=handlers.pass, keys={}, ref=true})
		self:expectLuaError("mixedMX: bad model.len", models.mixedMX, {metatable=handlers.pass, keys={}, ref=handlers.pass, len=true})
		self:expectLuaError("mixedMX: bad model.min", models.mixedMX, {metatable=handlers.pass, keys={}, ref=handlers.pass, min=true})
		self:expectLuaError("mixedMX: bad model.max", models.mixedMX, {metatable=handlers.pass, keys={}, ref=handlers.pass, max=true})

		self:expectLuaError("all: bad model", models.all)
		self:expectLuaError("all: bad model.ref", models.all, {ref=123})

		self:expectLuaError("allM: bad model", models.allM)
		self:expectLuaError("allM: bad model.metatable", models.allM, {ref=handlers.pass})
		self:expectLuaError("allM: bad model.ref", models.allM, {metatable=handlers.pass, ref=123})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: keys", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("key_test", {
			main = models.keys {
				foo = {handlers.string, "^yes$"},
				[false] = {handlers.this, 12345}
			}
		})

		local ok, err

		local t1 = {foo="no", [false] = 54321}
		ok, err = self:expectLuaReturn("keys: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {foo="yes", [false] = 12345}
		ok, err = self:expectLuaReturn("keys: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: keysM", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("key_test", {
			main = models.keysM {
				metatable = _metatableStandIn,

				keys = {
					foo = {handlers.string, "^yes$"}
				}
			}
		})

		local ok, err

		local t1 = {foo="yes"}
		ok, err = self:expectLuaReturn("keysM: metatable failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({foo="yes"}, _dummy_mt)
		ok, err = self:expectLuaReturn("keysM: metatable success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({}, _dummy_mt)
		ok, err = self:expectLuaReturn("keysM: keys failure", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: keysX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("keysX Test", {
			main = models.keysX {
				[false] = {handlers.this, 12345}
			}
		})

		local ok, err

		local t1 = {[false] = 12345, foo="no"}
		ok, err = self:expectLuaReturn("keysX: failure (unhandled key 'foo')", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {[false] = 12345}
		ok, err = self:expectLuaReturn("keysX: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]



-- [===[
self:registerJob("Model: keysMX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("keysMX Test", {
			main = models.keysMX {
				metatable = _metatableStandIn,

				keys = {
					foo = {handlers.string, "^yes$"}
				}
			}
		})

		local ok, err

		local t1 = {foo="yes"}
		ok, err = self:expectLuaReturn("keysMX: metatable failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({foo="yes"}, _dummy_mt)
		ok, err = self:expectLuaReturn("keysMX: metatable success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({[false] = 12345, foo="yes"}, _dummy_mt)
		ok, err = self:expectLuaReturn("keysMX: failure (unhandled key 'foo')", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: array", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("array test", {
			main = models.array {
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2, 3, 4, 5, "foobar"}
		ok, err = self:expectLuaReturn("array: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8, 9, 10}
		ok, err = self:expectLuaReturn("array: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = {bar="zoop"}
		ok, err = self:expectLuaReturn("array: pass/ignore non-array keys", _mt_val.validate, v, t3)
		self:isEqual(ok, true)

		local t4 = {}
		ok, err = self:expectLuaReturn("array: pass empty table", _mt_val.validate, v, t4)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("array test", {
			main = models.array {
				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("array: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("array: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("array test", {
			main = models.array {
				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("array: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("array: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("array: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: arrayX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayX test", {
			main = models.arrayX {
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2, 3, 4, 5, "foobar"}
		ok, err = self:expectLuaReturn("arrayX: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8, 9, 10}
		ok, err = self:expectLuaReturn("arrayX: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = {bar="zoop"}
		ok, err = self:expectLuaReturn("arrayX: reject unhandled keys", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t4 = {}
		ok, err = self:expectLuaReturn("arrayX: pass empty table", _mt_val.validate, v, t4)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayX test", {
			main = models.arrayX {
				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("arrayX: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayX: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayX test", {
			main = models.arrayX {
				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("arrayX: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("arrayX: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayX: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: arrayM", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayM test", {
			main = models.arrayM {
				metatable = _metatableStandIn,

				ref = handlers.number
			}
		})

		local ok, err

		local t0 = {1, 2, 3}
		ok, err = self:expectLuaReturn("arrayM: metatable failure", _mt_val.validate, v, t0)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t1 = setmetatable({1, 2, 3, 4, 5, "foobar"}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayM: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({6, 7, 8, 9, 10}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayM: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({bar="zoop"}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayM: pass/ignore non-array keys", _mt_val.validate, v, t3)
		self:isEqual(ok, true)

		local t4 = setmetatable({}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayM: pass empty table", _mt_val.validate, v, t4)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayM test", {
			main = models.arrayM {
				metatable = handlers.pass,

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("arrayM: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayM: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayM test", {
			main = models.arrayM {
				metatable = handlers.pass,

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("arrayM: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("arrayM: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayM: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: arrayMX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayMX test", {
			main = models.arrayMX {
				metatable = _metatableStandIn,

				ref = handlers.number
			}
		})

		local ok, err

		local t00 = {1, 2, 3}
		ok, err = self:expectLuaReturn("arrayMX: metatable failure", _mt_val.validate, v, t00)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t1 = setmetatable({1, 2, 3, 4, 5, "foobar"}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayMX: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({6, 7, 8, 9, 10}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayMX: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({bar="zoop"}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayMX: reject unhandled keys", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t4 = setmetatable({}, _dummy_mt)
		ok, err = self:expectLuaReturn("arrayMX: pass empty table", _mt_val.validate, v, t4)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayMX test", {
			main = models.arrayMX {
				metatable = handlers.pass,

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("arrayMX: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayMX: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("arrayMX test", {
			main = models.arrayMX {
				metatable = handlers.pass,

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("arrayMX: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("arrayMX: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("arrayMX: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: mixed", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixed test", {
			main = models.mixed {
				keys = {
					[false] = {handlers.this, 12345}
				},

				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {bar=54321}
		ok, err = self:expectLuaReturn("keys: 'keys' failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, "foo", [false]=12345}
		ok, err = self:expectLuaReturn("keys: 'array' failure", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {1, 2, 3, 4, 5, [false]=12345}
		ok, err = self:expectLuaReturn("keys: success", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]

	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixed test", {
			main = models.mixed {
				keys = {},

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("mixed: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixed: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixed test", {
			main = models.mixed {
				keys = {},

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("mixed: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("mixed: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixed: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: mixedX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedX test", {
			main = models.mixedX {
				keys = {
					[false] = {handlers.this, 12345}
				},

				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {bar=54321}
		ok, err = self:expectLuaReturn("keys: 'keys' failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, "foo", [false]=12345}
		ok, err = self:expectLuaReturn("keys: 'array' failure", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {1, 2, 3, 4, 5, [false]=12345}
		ok, err = self:expectLuaReturn("keys: success", _mt_val.validate, v, t3)
		self:isEqual(ok, true)

		local t4 = {[false]=12345, zoop="doop"}
		ok, err = self:expectLuaReturn("keys: reject unhandled keys", _mt_val.validate, v, t4)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))
	end
	--]====]

	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedX test", {
			main = models.mixedX {
				keys = {},

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("mixedX: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedX: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedX test", {
			main = models.mixedX {
				keys = {},

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("mixedX: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("mixedX: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedX: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: mixedM", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedM test", {
			main = models.mixedM {
				metatable = _metatableStandIn,

				keys = {
					[false] = {handlers.this, 12345}
				},

				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2, 3, 4, 5, [false]=12345}
		ok, err = self:expectLuaReturn("keys: 'metatable' failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({1, 2, 3, 4, 5, [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'metatable' success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({bar=54321}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'keys' failure", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t4 = setmetatable({1, 2, 3, 4, "foo", [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'array' failure", _mt_val.validate, v, t4)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t5 = setmetatable({1, 2, 3, 4, 5, [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: success", _mt_val.validate, v, t5)
		self:isEqual(ok, true)
	end
	--]====]

	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedM test", {
			main = models.mixedM {
				metatable = handlers.pass,

				keys = {},

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("mixedM: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedM: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedM test", {
			main = models.mixedM {
				metatable = handlers.pass,

				keys = {},

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("mixedM: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("mixedM: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedM: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: mixedMX", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedMX test", {
			main = models.mixedMX {
				metatable = _metatableStandIn,

				keys = {
					[false] = {handlers.this, 12345}
				},

				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2, 3, 4, 5, [false]=12345}
		ok, err = self:expectLuaReturn("keys: 'metatable' failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({1, 2, 3, 4, 5, [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'metatable' success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = setmetatable({[false]=54321}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'keys' failure", _mt_val.validate, v, t3)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t4 = setmetatable({1, 2, 3, 4, "foo", [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: 'array' failure", _mt_val.validate, v, t4)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t5 = setmetatable({1, 2, 3, 4, 5, [false]=12345}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: success", _mt_val.validate, v, t5)
		self:isEqual(ok, true)

		local t6 = setmetatable({zoop="doop"}, _dummy_mt)
		ok, err = self:expectLuaReturn("keys: reject unhandled keys", _mt_val.validate, v, t6)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))
	end
	--]====]

	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedMX test", {
			main = models.mixedMX {
				metatable = handlers.pass,

				keys = {},

				len = 3,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1, 2}
		ok, err = self:expectLuaReturn("mixedMX: wrong length", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedMX: correct length", _mt_val.validate, v, t2)
		self:isEqual(ok, true)
	end
	--]====]


	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("mixedMX test", {
			main = models.mixedMX {
				metatable = handlers.pass,

				keys = {},

				min = 2,
				max = 4,
				ref = handlers.number
			}
		})

		local ok, err

		local t1 = {1}
		ok, err = self:expectLuaReturn("mixedMX: below the minimum", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {1, 2, 3, 4, 5}
		ok, err = self:expectLuaReturn("mixedMX: above the maximum", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = {6, 7, 8}
		ok, err = self:expectLuaReturn("mixedMX: in range", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: all", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("key_test", {
			main = models.all {
				ref = handlers.string
			}
		})

		local ok, err

		local t1 = {foo=123}
		ok, err = self:expectLuaReturn("all: failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = {foo="yes", bar="maybe"}
		ok, err = self:expectLuaReturn("all: success", _mt_val.validate, v, t2)
		self:isEqual(ok, true)

		local t3 = {}
		ok, err = self:expectLuaReturn("all: empty table passes", _mt_val.validate, v, t3)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Model: allM", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("key_test", {
			main = models.allM {
				metatable = _metatableStandIn,

				ref = handlers.string
			}
		})

		local ok, err

		local t1 = {foo="yes", bar="maybe"}
		ok, err = self:expectLuaReturn("allM: metatable failure", _mt_val.validate, v, t1)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t2 = setmetatable({foo=123}, _dummy_mt)
		ok, err = self:expectLuaReturn("allM: failure", _mt_val.validate, v, t2)
		self:isEqual(ok, false)
		self:print(4, table.concat(err, "\n"))

		local t3 = setmetatable({foo="yes", bar="maybe"}, _dummy_mt)
		ok, err = self:expectLuaReturn("allM: success", _mt_val.validate, v, t3)
		self:isEqual(ok, true)

		local t4 = setmetatable({}, _dummy_mt)
		ok, err = self:expectLuaReturn("allM: empty table passes", _mt_val.validate, v, t4)
		self:isEqual(ok, true)
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("Built-in Handlers", function(self)
	-- [====[
	do
		local models, handlers = pSchema.models, pSchema.handlers
		local v = pSchema.newValidator("Handler Tests", {
			main = models.keysX {
				type_bad = {handlers.type, "number", "string", "boolean"},
				type_ok = {handlers.type, "number", "string", "boolean"},

				number_bad = handlers.number,
				number_bad_min = {handlers.number, min=5, max=10},
				number_bad_max = {handlers.number, min=5, max=10},
				number_ok = handlers.number,
				number_ok_range = {handlers.number, min=5, max=10},

				number_eval_bad = handlers.numberEval,
				number_eval_bad_min = {handlers.numberEval, min=5, max=10},
				number_eval_bad_max = {handlers.numberEval, min=5, max=10},
				number_eval_ok = handlers.numberEval,
				number_eval_ok_range = {handlers.numberEval, min=5, max=10},
				number_eval_false = handlers.numberEval,

				integer_bad = handlers.integer,
				integer_fractional = handlers.integer,
				integer_bad_min = {handlers.integer, min=5, max=10},
				integer_bad_max = {handlers.integer, min=5, max=10},
				integer_ok = handlers.integer,
				integer_eval_ok_range = handlers.integer,

				integer_eval_bad = handlers.integerEval,
				integer_eval_fractional = handlers.integerEval,
				integer_eval_bad_min = {handlers.integerEval, min=5, max=10},
				integer_eval_bad_max = {handlers.integerEval, min=5, max=10},
				integer_eval_ok = handlers.integerEval,
				integer_eval_ok_range = handlers.integerEval,
				integer_eval_false = handlers.integerEval,

				string_bad = handlers.string,
				string_bad_pattern = {handlers.string, "^foo$"},
				string_bad_patterns = {handlers.string, "^foo$", "^bar$"},
				string_ok = handlers.string,
				string_ok_pattern = {handlers.string, "^foo$"},
				string_ok_patterns = {handlers.string, "^foo$", "^bar$"},

				string_eval_bad = handlers.stringEval,
				string_eval_bad_pattern = {handlers.stringEval, "^foo$"},
				string_eval_bad_patterns = {handlers.stringEval, "^foo$", "^bar$"},
				string_eval_ok = handlers.stringEval,
				string_eval_ok_pattern = {handlers.stringEval, "^foo$"},
				string_eval_ok_patterns = {handlers.stringEval, "^foo$", "^bar$"},
				string_eval_false = handlers.stringEval,

				table_bad = handlers.table,
				table_ok = handlers.table,

				table_eval_bad = handlers.tableEval,
				table_eval_ok = handlers.tableEval,
				table_eval_false = handlers.tableEval,

				function_bad = handlers["function"],
				function_ok = handlers["function"],

				function_eval_bad = handlers.functionEval,
				function_eval_ok = handlers.functionEval,
				function_eval_false = handlers.functionEval,

				-- No userdata tests; can only make userdata objects from the C API.

				thread_bad = handlers.thread,
				thread_ok = handlers.thread,

				thread_eval_bad = handlers.threadEval,
				thread_eval_ok = handlers.threadEval,
				thread_eval_false = handlers.threadEval,

				boolean_bad = handlers.boolean,
				boolean_ok = handlers.boolean,

				boolean_eval_bad = handlers.booleanEval,
				boolean_eval_ok = handlers.booleanEval,
				boolean_eval_false = handlers.booleanEval,

				nil_bad = handlers["nil"],
				nil_ok = handlers["nil"],

				not_nil_bad = handlers.notNil,
				not_nil_ok = handlers.notNil,

				not_false_not_nil_bad = handlers.notFalseNotNil,
				not_false_not_nil_bad2 = handlers.notFalseNotNil,
				not_false_not_nil_ok = handlers.notFalseNotNil,

				not_false_not_nil_bad = handlers.notFalseNotNilNotNan,
				not_false_not_nil_bad2 = handlers.notFalseNotNilNotNan,
				not_false_not_nil_bad3 = handlers.notFalseNotNilNotNan,
				not_false_not_nil_ok = handlers.notFalseNotNilNotNan,

				this_bad = {handlers.this, "bar"},
				this_ok = {handlers.this, "bar"},

				one_of_bad = {handlers.oneOf, true, 7, "foo"},
				one_of_ok = {handlers.oneOf, true, 7, "foo"},

				enum_bad = {handlers.enum, {"left", "center", "right"}},
				enum_ok = {handlers.enum, {"left", "center", "right"}},

				enum_eval_bad = {handlers.enumEval, {"left", "center", "right"}},
				enum_eval_ok = {handlers.enumEval, {"left", "center", "right"}},
				enum_eval_false = {handlers.enumEval, {"left", "center", "right"}},

				choice_bad = {handlers.choice,
					handlers.boolean,
					handlers.string,
					{handlers.number, min=1, max=3}
				},
				choice_ok = {handlers.choice,
					handlers.boolean,
					handlers.string,
					{handlers.number, min=1, max=3}
				},

				pass_ok = handlers.pass,

				fail_bad = handlers.fail,
			}
		})

		local t = {
			type_bad = function() end,
			type_ok = true,

			number_bad = "foo",
			number_bad_min = 1,
			number_bad_max = 11,
			number_bad_ok = 1,
			number_ok_range = 7,

			number_eval_bad = "foo",
			number_eval_bad_min = 1,
			number_eval_bad_max = 11,
			number_eval_ok = 1,
			number_eval_ok_range = 7,
			number_eval_false = false,

			integer_bad = "foo",
			integer_fractional = 0.5,
			integer_bad_min = 1,
			integer_bad_max = 1,
			integer_ok = 1,
			integer_ok_eval_range = 7,

			integer_eval_bad = "foo",
			integer_eval_fractional = 0.5,
			integer_eval_bad_min = 1,
			integer_eval_bad_max = 11,
			integer_eval_ok = 1,
			integer_eval_ok_range = 7,
			integer_eval_false = false,

			string_bad = 345,
			string_bad_pattern = "zoop",
			string_bad_patterns = "zup",
			string_ok = "wee",
			string_ok_pattern = "foo",
			string_ok_patterns = "bar",

			string_eval_bad = 345,
			string_eval_bad_pattern = "zoop",
			string_eval_bad_patterns = "zup",
			string_eval_ok = "wee",
			string_eval_ok_pattern = "foo",
			string_eval_ok_patterns = "bar",
			string_eval_false = false,

			table_bad = true,
			table_ok = {},

			table_eval_bad = true,
			table_eval_ok = {},
			table_eval_false = false,

			function_bad = true,
			function_ok = function() end,

			function_eval_bad = true,
			function_eval_ok = function() end,
			function_eval_false = false,

			-- No userdata tests; can only make userdata objects from the C API.

			thread_bad = true,
			thread_ok = coroutine.create(function() end),

			thread_eval_bad = true,
			thread_eval_ok = coroutine.create(function() end),
			thread_eval_false = false,

			boolean_bad = 5,
			boolean_ok = true,

			boolean_eval_bad = 5,
			boolean_eval_ok = true,
			boolean_eval_false = false,

			nil_bad = true,
			nil_ok = nil,

			not_nil_bad = nil,
			not_nil_ok = true,

			not_false_not_nil_bad = nil,
			not_false_not_nil_bad2 = false,
			not_false_not_nil_ok = true,

			not_false_not_nil_bad = nil,
			not_false_not_nil_bad2 = false,
			not_false_not_nil_bad3 = 0/0,
			not_false_not_nil_ok = true,

			this_bad = "foo",
			this_ok = "bar",

			one_of_bad = "zing",
			one_of_ok = "foo",

			enum_bad = "sideways",
			enum_ok = "center",

			enum_eval_bad = "sideways",
			enum_eval_ok = "center",
			enum_eval_false = false,

			choice_bad = 790,
			choice_ok = 2,

			pass_ok = "anything will pass here",

			fail_bad = "everything will fail here",
		}

		self:expectLuaReturn("Test of built-in Handlers", _mt_val.validate, v, t)
	end
	--]====]
end
)
--]===]


self:runJobs()
