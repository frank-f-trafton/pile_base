-- PILE Line
-- VERSION: 2.022
-- https://github.com/frank-f-trafton/pile_base


--[[
MIT License

Copyright (c) 2024 - 2026 PILE Contributors

LUIGI code: Copyright (c) 2015 airstruck
  https://github.com/airstruck/luigi

lume code: Copyright (c) 2020 rxi
  https://github.com/rxi/lume

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


local M = {}


local PATH = ... and (...):match("(.-)[^%.]+$") or ""


local pMath = require(PATH .. "pile_math")
local pAssert = require(PATH .. "pile_assert")


local _lerp, _roundInf = pMath.lerp, pMath.roundInf
local _min, _max = math.min, math.max


--[[ASSERT
local L = pAssert.L


local function _checkLine(l, name)
	pAssert.type(nil, l, "table")
	L[1] = name
	L[2] = "x"; pAssert.numberNotNaN(L, l.x)
	L[2] = "w"; pAssert.numberNotNaN(L, l.w)
end


local function _checkArrayOfLines(list, name)
	pAssert.type(1, list, "table")
	for i, v in ipairs(list) do
		_checkLine(v, name .. "[" .. i .. "]")
	end
end


local function _checkVarargOfLines(name, ...)
	for i = 1, select("#", ...) do
		local l = select(i, ...)
		_checkLine(l, name .. "[" .. i .. "]")
	end
end


local function _checkSideDelta(sd, name)
	pAssert.type(nil, sd, "table")
	L[1] = name
	L[2] = "x1"; pAssert.numberNotNaN(L, sd.x1)
	L[2] = "x2"; pAssert.numberNotNaN(L, sd.x2)
end
--]]


function M.set(a, x, w)
	--[[ASSERT
	pAssert.type(1, a, "table")
	pAssert.numberNotNaN(2, x)
	pAssert.numberNotNaN(3, w)
	--]]

	a.x, a.w = x, _max(0, w)

	return a
end


function M.copy(a, b)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.type(2, b, "table")
	--]]

	b.x, b.w = a.x, a.w

	return a
end


function M.expand(a, x1, x2)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x1)
	pAssert.numberNotNaN(3, x2)
	--]]

	a.x = a.x - x1
	a.w = _max(0, a.w + x1 + x2)

	return a
end


function M.reduce(a, x1, x2)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x1)
	pAssert.numberNotNaN(3, x2)
	--]]

	a.x = a.x + x1
	a.w = _max(0, a.w - x1 - x2)

	return a
end


function M.expandT(a, sd)
	--[[ASSERT
	_checkLine(a, "a")
	_checkSideDelta(sd, "sd")
	--]]

	a.x = a.x - sd.x1
	a.w = _max(0, a.w + sd.x1 + sd.x2)

	return a
end


function M.reduceT(a, sd)
	--[[ASSERT
	_checkLine(a, "a")
	_checkSideDelta(sd, "sd")
	--]]

	a.x = a.x + sd.x1
	a.w = _max(0, a.w - sd.x1 - sd.x2)

	return a
end


function M.expandLeft(a, x1)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x1)
	--]]

	a.x = a.x - x1
	a.w = _max(0, a.w + x1)

	return a
end


function M.reduceLeft(a, x1)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x1)
	--]]

	a.x = a.x + x1
	a.w = _max(0, a.w - x1)

	return a
end


function M.expandRight(a, x2)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x2)
	--]]

	a.w = _max(0, a.w + x2)

	return a
end


function M.reduceRight(a, x2)
	--[[ASSERT
	_checkLine(a, "a")
	pAssert.numberNotNaN(2, x2)
	--]]

	a.w = _max(0, a.w - x2)

	return a
end


function M.splitLeft(a, b, len)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	pAssert.numberNotNaN(3, len)
	--]]

	len = _min(len, a.w)
	a.x = a.x + len
	a.w = a.w - len
	b.x = a.x - len
	b.w = len

	return a
end


function M.splitRight(a, b, len)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	pAssert.numberNotNaN(3, len)
	--]]

	len = _min(len, a.w)
	a.w = a.w - len
	b.x = a.x + a.w
	b.w = len

	return a
end


local _split_sides = {
	left=M.splitLeft,
	right=M.splitRight
}


function M.split(a, b, placement, len)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	-- don't assert 'placement'.
	pAssert.numberNotNaN(4, len)
	--]]

	local fn = _split_sides[placement]
	if not fn then
		error("invalid placement: " .. tostring(placement))
	else
		fn(a, b, len)
	end

	return a
end


function M.splitOrOverlay(a, b, placement, len)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	-- don't assert 'placement'.
	if placement ~= "overlay" then
		pAssert.numberNotNaN(4, len)
	end
	--]]

	if placement == "overlay" then
		b.x, b.w = a.x, a.w
	else
		local fn = _split_sides[placement]
		if not fn then
			error("invalid placement: " .. tostring(placement))
		else
			fn(a, b, len)
		end
	end

	return a
end


function M.placeInner(a, b, unit)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	pAssert.numberNotNaN(3, unit)
	--]]

	b.x = _roundInf(_lerp(a.x, a.x + a.w - b.w, unit))

	return a
end


function M.placeMidpoint(a, b, unit)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	pAssert.numberNotNaN(3, unit)
	--]]

	b.x = _roundInf(_lerp(a.x - b.w*.5, a.x + a.w + b.w*.5, unit))

	return a
end


function M.placeOuter(a, b, unit)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	pAssert.numberNotNaN(3, unit)
	--]]

	b.x = _roundInf(_lerp(a.x - b.w, a.x + a.w + b.w, unit))

	return a
end


function M.center(a, b)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	--]]

	b.x = _roundInf(a.x + (a.w - b.w)*.5)

	return a
end


function M.flip(a, b)
	--[[ASSERT
	_checkLine(a, "a")
	_checkLine(b, "b")
	--]]

	local w = b.x - a.x
	b.x = a.w - w - b.w + a.x

	return a
end


function M.positionOverlap(a, x)
	--[[ASSERT
	pAssert.type(1, a, "table")
	pAssert.numberNotNaN(2, x)
	--]]

	return x >= a.x and x < a.x + a.w
end


function M.getBounds(...)
	--[[ASSERT
	_checkVarargOfLines("vararg", ...)
	--]]

	local x1, x2 = 0, 0
	for i = 1, select("#", ...) do
		local l = select(i, ...)
		x1, x2 = _min(x1, l.x), _max(x2, l.x + l.w)
	end

	return x1, x2
end


function M.getBoundsT(list)
	--[[ASSERT
	_checkArrayOfLines(list, "list")
	--]]

	local x1, x2 = 0, 0
	for i, l in ipairs(list) do
		x1, x2 = _min(x1, l.x), _max(x2, l.x + l.w)
	end

	return x1, x2
end


return M
