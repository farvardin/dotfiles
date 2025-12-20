--[[--------------------------------------------------
fold2.lua
mozers™
version 0.01 alfa
------------------------------------------------------
It is primitive variant of Steve Donovan's script <http://lua-users.org/wiki/SciteTextFolding>
Intends for understanding mechanism of its work.
extman.lua is not required.

You can fold everything with 

CTRL+LEFTMOUSEBUTTON on the "-" sign (folding sign on the left - near to #Region statement) 
the unfold with "+".

Or the opposite: left mouse button on the "-" sign then  
CRTL+LEFTMOUSEBUTTON on the same "+" folding sign. 

------------------------------------------------------
Connection:
In file SciTEStartup.lua add a line:
  dofile (props["SciteDefaultHome"].."\\.scite\\fold2.lua")
  on windows
 or 
   dofile (props["SciteDefaultHome"].."/.scite/fold2.lua")
   on unix/linux systems
--]]----------------------------------------------------

local function set_level(i,lev,fold)
	-- print (i, lev, fold)
	local foldlevel = lev + SC_FOLDLEVELBASE
	if fold then
		foldlevel = foldlevel + SC_FOLDLEVELHEADERFLAG
		editor.FoldExpanded[i] = true
	end
	editor.FoldLevel[i] = foldlevel
end

local function fold()
	local level = 0
	for i = 0, editor.LineCount do
		local pref = nil
		local line = editor:GetLine(i)
		if line ~= nil then
			pref = string.match (editor:GetLine(i), "^%s*(%=+)")
		end
		if pref ~= nil then
			level = string.len(pref)
			set_level(i, level-1, true)
		else
			if level ~= 0 then
			set_level(i, level, false)
			end
		end
	end
end

-- Add user event handler OnOpen
local old_OnOpen = OnOpen
function OnOpen(file)
	local result
	if old_OnOpen then result = old_OnOpen(file) end
	if props['FileExt'] == 't2t' then
		fold()
	end
	return result
end


