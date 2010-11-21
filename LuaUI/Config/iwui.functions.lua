---------------------------------------------------------------
-- iwui.functions.lua
-- Common functions for Imperial Winter's GUI
-- Last update: October 22, 2008
---------------------------------------------------------------

-------------- Localizations

local fhUseFont = fontHandler.UseFont
local fhGetTextWidth = fontHandler.GetTextWidth

local streverse = string.reverse
local stlen = string.len
local stfind = string.find
local stsub = string.sub

local floor = math.floor
local insert = table.insert



-------------- Wraps a long string into a table of lines based on a given font size and maximum length in px

function WordWrap(line, size, maxLen)
	fhUseFont(fontBaseName .. size)
	maxLen = maxLen or 200						--these are both in pixels
	local strLen = fhGetTextWidth(line)
	if(strLen > maxLen) then
		local lines = {}
		while(strLen > maxLen) do
			local lineReverse = streverse(line)
			local actualChars = stlen(line)
			local maxChars = floor((maxLen * actualChars) / strLen)
			local split = stfind(lineReverse," ", -maxChars, true)
			split = actualChars - split

			local line1 = stsub(line, 1, split)
			insert(lines, line1)

			line = stsub(line, split + 2)
			strLen = fhGetTextWidth(line)
		end
		insert(lines, line) --make sure to get the last segment that didn't satisfy the while loop
		return lines
	else
		return {line}
	end
end



-------------- Convert long strings with new line characters to arrays, wordwrapping any lines necessary based on given font size and maximum length in px

function nl2table(tooltip, size, maxLen)
	local newline = stfind(tooltip,"\n", 1, true) or false
	if(newline == false) then return({tooltip})
	else
		local newtooltip = {}
		while(newline ~= false) do
			tooltipins = WordWrap(stsub(tooltip, 1, newline - 1), size, maxLen)
			for i=1,#tooltipins do
				insert(newtooltip, tooltipins[i])
			end
			tooltip = stsub(tooltip, newline + 1)
			newline = stfind(tooltip,"\n", 1, true) or false
		end
		return newtooltip
	end
end