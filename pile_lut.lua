-- PILE lut v1.0.1
-- (C) 2024 PILE Contributors
-- License: MIT or MIT-0
-- https://github.com/rabbitboots/pile_base


local lut = {}


local ipairs, pairs = ipairs, pairs


lut.lang = {
	err_dupe = "duplicate values in source table"
}
local lang = lut.lang


function lut.make(t)
	local lut = {}
	for i, v in ipairs(t) do
		lut[v] = true
	end
	return lut
end


function lut.invert(t)
	local lut = {}
	for k, v in pairs(t) do
		if lut[v] then
			error(lang.err_dupe)
		end
		lut[v] = k
	end
	return lut
end


return lut
