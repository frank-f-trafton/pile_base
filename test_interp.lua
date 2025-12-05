-- Test: pile_interp.lua
-- v2.011


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local interp = require(PATH .. "pile_interp")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("interp", cli_verbosity)


self:registerFunction("interp()", interp)


-- [===[
self:registerJob("interp with varargs", function(self)
	-- [====[
	do
		local output = self:expectLuaReturn("convert arguments to strings", interp, "1:$1 2:$2 3:$3", {}, function() end, true)
		self:isEqual(output:match("1:table"), "1:table")
		self:isEqual(output:match("2:function"), "2:function")
		self:isEqual(output:match("3:true"), "3:true")
	end
	--]====]


	-- [====[
	do
		self:print(4, "[+] (5.1, JIT, 5.2) bad __tostring metamethods should not lead to a crash")
		if _VERSION > "Lua 5.2" then
			self:expectLuaReturn("(Skip this test in 5.3 and 5.4, because it doesn't work.)", function() end)
		else
			local obj = setmetatable({}, {__tostring=function(e) return false end})
			self:expectLuaReturn("(5.1, JIT, 5.2) bad __tostring metamethods should not lead to a crash", interp, "foo$1bar", obj)
		end
	end
	--]====]


	-- [====[
	do
		local output = self:expectLuaReturn("empty input", interp)
		self:isEqual(output, "nil")
	end
	--]====]


	-- [====[
	do
		self:print(4, "[+] Escape interpolation marks ($$ -> $)")
		local output = interp("That'll be $$29.99")
		self:isEqual(output, "That'll be $29.99")
	end
	--]====]


	-- [====[
	do
		self:print(4, "[+] Arguments 1 through 9")
		local output = interp(
			"$1 $2 $3 $4 $5 $6 $7 $8 $9",
			"a", "b", "c", "d", "e", "f", "g", "h", "i"
		)
		self:isEqual(output, "a b c d e f g h i")
	end
	--]====]


	-- [====[
	do
		self:print(4, "[+] Missing arguments have no effect")
		local output = interp(
			"$1 $2 $3 $4 $5 $6 $7 $8 $9",
			"a", "b", "c"
		)
		self:isEqual(output, "a b c $4 $5 $6 $7 $8 $9")
	end
	--]====]


	-- [====[
	do
		self:print(4, "[+] Extra arguments have no effect")
		local output = interp(
			"$1 $2 $3",
			"a", "b", "c", "d", "e", "f", "g", "h", "i"
		)
		self:isEqual(output, "a b c")
	end
	--]====]
end
)
--]===]


self:runJobs()
