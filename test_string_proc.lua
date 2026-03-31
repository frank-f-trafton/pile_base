-- Test: pStringProc
-- VERSION: 2.106

local PATH = ... and (...):match("(.-)[^%.]+$") or ""


require(PATH .. "test.strict")


local errTest = require(PATH .. "test.err_test")
local inspect = require(PATH .. "test.inspect")
local pStringWalk = require(PATH .. "p_string_walk")
local pStringProc = require(PATH .. "p_string_proc")


local _mt_walk = getmetatable(pStringWalk.new())


local cli_verbosity
for i = 0, #arg do
	if arg[i] == "--verbosity" then
		cli_verbosity = tonumber(arg[i + 1])
		if not cli_verbosity then
			error("invalid verbosity value")
		end
	end
end


local self = errTest.new("pStringProc", cli_verbosity)


-- [===[
self:registerFunction("pStringProc.toTable()", pStringProc.toTable)

self:registerJob("pStringProc.toTable", function(self)

	self:expectLuaError("arg #1 bad type", pStringProc.toTable, {})


	self:print(3, "[+] expected behavior")

	local t
	-- [====[
	t = self:expectLuaReturn("empty string", pStringProc.toTable, "")
	self:isType(t, "table")
	self:isEqual(next(t), nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("whitespace", pStringProc.toTable, " \t\n")
	self:isType(t, "table")
	self:isEqual(next(t), nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("char", pStringProc.toTable, "w")
	self:isType(t, "table")
	self:isEqual(t[1], "w")
	self:isEqual(t[2], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("word", pStringProc.toTable, "word")
	self:isType(t, "table")
	self:isEqual(t[1], "word")
	self:isEqual(t[2], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("string literal, single quotes", pStringProc.toTable, "'wörd'")
	self:isType(t, "table")
	self:isEqual(t[1], "'wörd'")
	self:isEqual(t[2], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("string literal, double quotes", pStringProc.toTable, [["wörd"]])
	self:isType(t, "table")
	self:isEqual(t[1], [["wörd"]])
	self:isEqual(t[2], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("sequence of words", pStringProc.toTable, "word word word")
	self:isType(t, "table")
	self:isEqual(t[1], "word")
	self:isEqual(t[2], "word")
	self:isEqual(t[3], "word")
	self:isEqual(t[4], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("sequence of words", pStringProc.toTable, "word | word")
	self:isType(t, "table")
	self:isEqual(t[1], "word")
	self:isEqual(t[2], "|")
	self:isEqual(t[3], "word")
	self:isEqual(t[4], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("separation of tokens and words without whitespace", pStringProc.toTable, [[whitespace|between|words'and'nonword"tokens"is|optional]])
	self:isType(t, "table")
	self:isEqual(t[1], "whitespace")
	self:isEqual(t[2], "|")
	self:isEqual(t[3], "between")
	self:isEqual(t[4], "|")
	self:isEqual(t[5], "words")
	self:isEqual(t[6], "'and'")
	self:isEqual(t[7], "nonword")
	self:isEqual(t[8], '"tokens"')
	self:isEqual(t[9], "is")
	self:isEqual(t[10], "|")
	self:isEqual(t[11], "optional")
	self:isEqual(t[12], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("nested groups (1)", pStringProc.toTable, "word (word)")
	self:isType(t, "table")
	self:isEqual(t[1], "word")
	self:isType(t[2], "table")
	self:isEqual(t[2][1], "word")
	self:isEqual(t[2][2], nil)
	self:isEqual(t[3], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("nested groups (2)", pStringProc.toTable, "word (word (word))")
	self:isType(t, "table")
	self:isEqual(t[1], "word")
	self:isType(t[2], "table")
	self:isEqual(t[2][1], "word")
	self:isType(t[2][2], "table")
	self:isEqual(t[2][2][1], "word")
	self:isEqual(t[2][2][2], nil)
	self:isEqual(t[2][3], nil)
	self:isEqual(t[3], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("empty group", pStringProc.toTable, "()")
	self:isType(t, "table")
	self:isType(t[1], "table")
	self:isEqual(t[1][1], nil)
	--]====]


	-- [====[
	t = self:expectLuaReturn("sequence of empty groups", pStringProc.toTable, "()()()(())()()()((())())")
	self:isType(t, "table")
	self:isType(t[1], "table")
	self:isEqual(t[1][1], nil)

	self:isType(t[2], "table")
	self:isEqual(t[2][1], nil)

	self:isType(t[3], "table")
	self:isEqual(t[3][1], nil)

	self:isType(t[4], "table")
	self:isType(t[4][1], "table")
	self:isEqual(t[4][2], nil)

	self:isType(t[5], "table")
	self:isEqual(t[5][1], nil)

	self:isType(t[6], "table")
	self:isEqual(t[6][1], nil)

	self:isType(t[7], "table")
	self:isEqual(t[7][1], nil)

	self:isType(t[8], "table")
	self:isType(t[8][1], "table")
	self:isType(t[8][1][1], "table")
	self:isEqual(t[8][1][2], nil)
	self:isType(t[8][2], "table")
	self:isEqual(t[8][2][1], nil)
	self:isEqual(t[8][3], nil)


	self:print(3, "[-] syntax errors")


	-- [====[
	self:expectLuaError("isolated '?'", pStringProc.toTable, "?")
	self:expectLuaError("isolated '*'", pStringProc.toTable, "*")
	self:expectLuaError("isolated '+'", pStringProc.toTable, "+")
	self:expectLuaError("invalid token", pStringProc.toTable, "@")
	self:expectLuaError("invalid token between two tokens", pStringProc.toTable, "word @ word")
	self:expectLuaError("'except' token is not supported", pStringProc.toTable, "-")
	self:expectLuaError("isolated '|'", pStringProc.toTable, "|")
	self:expectLuaError("consecutive quantity marks", pStringProc.toTable, "word*? word")
	self:expectLuaError("trailing '|'", pStringProc.toTable, "word | word | ")
	self:expectLuaError("consecutive '|'", pStringProc.toTable, "word | | word")
	self:expectLuaError("consecutive '|'", pStringProc.toTable, "word | | word")
	self:expectLuaError("unbalanced group (1)", pStringProc.toTable, ")")
	self:expectLuaError("unbalanced group (2)", pStringProc.toTable, "(")
	self:expectLuaError("unbalanced group (3)", pStringProc.toTable, "(ab)c)")
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pStringProc.checkWords()", pStringProc.checkWords)

self:registerJob("pStringProc.checkWords", function(self)
	-- [====[
	do

		self:expectLuaError("arg #1 bad type", pStringProc.checkWords, false, {})
		self:expectLuaError("arg #2 bad type", pStringProc.checkWords, {}, false)


		self:expectLuaReturn("all words are populated", pStringProc.checkWords, {foo="bar", baz=function() end, bop=1}, {"foo", "baz", "bop"})
		self:expectLuaError("missing word", pStringProc.checkWords, {foo=1, baz=1, bop=1}, {"foo", "baz", "zyp"})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pStringProc.checkSymbols()", pStringProc.checkSymbols)

self:registerJob("pStringProc.checkSymbols", function(self)
	-- [====[
	do

		self:expectLuaError("arg #1 bad type", pStringProc.checkSymbols, false)


		self:expectLuaReturn("all symbols OK", pStringProc.checkSymbols, {foo="bar", baz=function() end, bop=1})
		self:expectLuaError("bad symbol value", pStringProc.checkSymbols, {burp = false})
	end
	--]====]
end
)
--]===]


-- [===[
self:registerFunction("pStringProc.traverse()", pStringProc.traverse)

self:registerJob("pStringProc.traverse", function(self)
	-- [====[
	do

		self:expectLuaError("arg #1 bad type", pStringProc.traverse, false, {}, {})
		self:expectLuaError("arg #2 bad type", pStringProc.traverse, {}, false, {})
		self:expectLuaError("arg #3 bad type", pStringProc.traverse, {}, {}, false)

		-- A silly grammar rule set.

		local sym = {}
		function sym.s(W)
			return W:match("^(\32+)")
		end

		function sym.EOL(W)
			return W:match("^(\n+)")
		end

		function sym.word(W)
			return W:match("^([a-zA-Z]+)")
		end

		function sym.figure(W)
			return W:match("^([0-9]+%.[0-9]*)") or W:match("^([0-9]+)")
		end

		local _assignment = pStringProc.toTable("word s? '=' s? figure s? EOL?")
		function sym.assignment(W)
			return pStringProc.traverse(W, _assignment, sym)
		end

		function sym.inQuotes(W)
			local q, r = W:match("^(['\"])(.-)%1")
			if q then
				return q .. r .. q
			end
		end

		local _sentenceChunk = pStringProc.toTable("word | inQuotes")
		function sym.sentenceChunk(W)
			return pStringProc.traverse(W, _sentenceChunk, sym)
		end

		function sym.sentenceEnd(W)
			return W:match("^([%.%?!])")
		end

		local _sentence = pStringProc.toTable("(sentenceChunk s?)+ sentenceEnd s?")
		function sym.sentence(W)
			return pStringProc.traverse(W, _sentence, sym)
		end

		local _paragraph = pStringProc.toTable("sentence+ EOL?")
		function sym.paragraph(W)
			return pStringProc.traverse(W, _paragraph, sym)
		end

		local _document = pStringProc.toTable("(paragraph | assignment | s | EOL)+")
		function sym.document(W)
			local r = pStringProc.traverse(W, _document, sym)
			if not r or not W:isEOS() then
				W:error("couldn't read the full document.")
			end
			return r
		end

		function sym.never(W)
			return
		end

		local _inf_loop = pStringProc.toTable("(never*)*")
		function sym.infLoop(W)
			return pStringProc.traverse(W, _inf_loop, sym)
		end

		local _inf_loop2 = pStringProc.toTable("''+")
		function sym.infLoop2(W)
			return pStringProc.traverse(W, _inf_loop2, sym)
		end

		local W, ok

		-- [====[
		self:print(3, "[+] correct input")
		W = pStringWalk.new([=[
Fill the bucket. Empty the bucket.
Move the bucket. Upturn the bucket.
a = 3.21
'everything in quotes is parsed as one chunk'.]=])
		pStringProc._iter = 50000
		ok = sym.document(W)
		self:isType(ok, "table")
		--print(inspect(ok))
		self:isEqual(ok[1], "Fill")
		self:isEqual(ok[2], " ")
		self:isEqual(ok[3], "the")
		self:isEqual(ok[4], " ")
		self:isEqual(ok[5], "bucket")
		self:isEqual(ok[6], ".")
		-- etc., etc.
		--]====]


		-- [====[
		self:print(3, "[-] bad input")
		W = pStringWalk.new("")
		pStringProc._iter = 50000
		self:expectLuaError("empty string", sym.document, W)

		W:setString("foobar")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document (sentences must end with a period)", sym.document, W)

		W:setString(".")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document (no words in sentence)", sym.document, W)

		W:setString("a = a")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document (doesn't match 'assignment' rule)", sym.document, W)

		W:setString("'a' = a")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document ('assignment' rule doesn't allow quoted sections on left hand)", sym.document, W)

		W:setString("a = 1.0.")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document ('assignment' rule doesn't end with a dot)", sym.document, W)

		W:setString("...")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document (infinite loop in grammar rule)", sym.infLoop, W)

		W:setString("abc")
		pStringProc._iter = 50000
		self:expectLuaError("invalid document (infinite loop caused by empty string literal)", sym.infLoop2, W)
		--]====]

		--[[
		You get the idea.

		pStringProc gets more serious use in the Lua XML Library:
		https://github.com/frank-f-trafton/lxl
		--]]
	end
	--]====]
end
)
--]===]


self:runJobs()
