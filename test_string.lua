-- Test: pile_string.lua
-- v1.1.8


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pString = require(PATH .. "pile_string")


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("PILE String", cli_verbosity)



-- [===[
self:registerJob("test pString.ptn_dollar", function(self)
	-- [====[
	do
		local output = self:expectLuaReturn("successful interpolation", string.gsub, "$a $bc$def$", pString.ptn_dollar, {a="foo", bc="bar", def="baz"})
		self:isEqual(output, "foo barbaz$")

		local output = self:expectLuaReturn("escape $", string.gsub, "$a$b$c$d$e", pString.ptn_dollar, {d="$"})
		self:isEqual(output, "$a$b$c$$e")
	end
	--]====]
end
)
--]===]


-- [===[
self:registerJob("test pString.ptn_percent", function(self)
	-- [====[
	do
		local output = self:expectLuaReturn("successful interpolation", string.gsub, "%aaa% %bbb% %% %ccc%", pString.ptn_percent, {aaa="foo", bbb="bar"})
		self:isEqual(output, "foo bar %% %ccc%")

		local output = self:expectLuaReturn("escape %", string.gsub, "%a%%b%%c%%d%%e%", pString.ptn_percent, {d="%"})
		self:isEqual(output, "%a%%b%%c%%%e%")
	end
	--]====]
end
)
--]===]


self:runJobs()
