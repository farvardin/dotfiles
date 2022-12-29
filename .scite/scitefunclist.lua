-- SciteFuncList.lua
-- by 2011.04.22 lee.sheen@gmail.com

scite_Command {
	'Function List|functionList|Ctrl+/',
}

function functionList()
	local sourceFilename = props["FilePath"]
	local ctagsFilename = sourceFilename .. ".ctags"

	makeCtagsFile(sourceFilename, ctagsFilename)
	readCtagsFile(ctagsFilename)
	removeCtagsFile(ctagsFilename)
end

function makeCtagsFile(sourceFilename, ctagsFilename)
	local makeCtagsCommand = "ctags -u -f " .. ctagsFilename .. " " .. sourceFilename
	--print(makeCtagsCommand)
	os.execute(makeCtagsCommand)
end

function readCtagsFile(ctagsFilename)
	print()
	io.input(ctagsFilename)
	while true do
		local line = io.read("*line")
		if line == nil then break end
		if not isCommentLine(line) then
			print(getFunctionName(line))
		end
	end
end

function isCommentLine(line)
	return '!' == string.sub(line, 0, 1)
end

function getFunctionName(line)
	local ctagsTable = {}
	ctagsTable = splitCtagsLine(line)
	local functionName = makeFunctionName(ctagsTable)
	local searchString = makeSearchString(ctagsTable)
	return functionName, searchString
end

function splitCtagsLine(line)
	local t = {}
	local l = 0
	local r = 0
	while true do
		r = string.find(line, "\t", l)
		if r == nil then
			r = #line + 1
		end

		local name = string.sub(line, l, r - 1)
		t[#t + 1] = name

		l = r + 1
		if #line <= l then break end
	end
	return t
end

function makeFunctionName(ctagsTable)
	local functionName = ctagsTable[1]
--[[
	-- with it's class name
	if not(ctagsTable[5] == nil) then
		local isClass = not(string.find(ctagsTable[5], "class:", 0) == nil)
		if isClass then 
			local className = string.sub(ctagsTable[5], 7)
			functionName = className.."::"..functionName
		end
	end
--]]
	return functionName
end

function makeSearchString(ctagsTable)
	local searchString = nil
	local s = string.sub(ctagsTable[3], 0, #ctagsTable[3] - 2)
	local l = 0
	local r = 0
	while true do
		r = string.find(s, "\\", l)
		if r == nil then
			r = #s + 1
		elseif string.sub(s, r + 1, r + 1) == "\\" then 
			r = r + 1
		end

		local name = string.sub(s, l, r - 1)
		if searchString == nil then 
			searchString = name
		else
			searchString = searchString..name
		end

		l = r + 1
		if #s <= l then break end
	end

	return searchString
end

function removeCtagsFile(ctagsFilename)
	os.remove(ctagsFilename)
end