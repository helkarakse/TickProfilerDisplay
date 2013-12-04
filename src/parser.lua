--[[

	TickProfiler JSON Data Parser Version 1.3 Alpha
	Do not modify, copy or distribute without permission of author
	Helkarakse, 20131128
	
	Changelog:
	- 1.3 Added the dimension resolution for dimension ids into the parser
	- 1.2 Moved the tps color and percentage color functions into parser
	- 1.1.1 Added dimension name resolution for nether, overworld and end - 20131201
	- 1.1 Fixed the functions.explode call nil issue - 20131201
	- 1.0 Added all the methods - 20131128
	
]]

-- following json format, first key is tps, 
-- second key is array for single entity, 
-- third key is array for chunk,
-- fourth key is array for entity by type,
-- fifth key is array for average entity

-- Libraries
os.loadAPI("json")
os.loadAPI("functions")

-- Vars
local stringData, tableData, tableTps, tableSingleEntity, tableChunk, tableEntityByType, tableAverageCalls

-- Dimension names
local dimArray = {
	{rrServer = 1, dimensionId = 16, dimensionName = "Public Mining"},
	{rrServer = 1, dimensionId = 11, dimensionName = "Gold Mining"},
	{rrServer = 1, dimensionId = 5, dimensionName = "Silver Mining"},
	{rrServer = 1, dimensionId = 7, dimensionName = "Twilight Forest"},
	{rrServer = 2, dimensionId = 9, dimensionName = "Public Mining"},
	{rrServer = 2, dimensionId = 11, dimensionName = "Gold Mining"},
	{rrServer = 2, dimensionId = 7, dimensionName = "Twilight Forest"},
	{rrServer = 2, dimensionId = 10, dimensionName = "Silver Mining"}
}

local hexColor = {
	red = 0xFF0000,
	green = 0x00FF00,
	yellow = 0xFFFF00
}

-- Main Functions
-- Parses the json string and initializes each table variable. Returns true on successful parse, false on empty string passed.
function parseData(stringInput)
	if (stringInput == "") then
		return false
	else
		stringData = stringInput
		tableData = json.decode(stringData)
		
		tableTps = tableData[1]
		tableSingleEntity = tableData[2]
		tableChunk = tableData[3]
		tableEntityByType = tableData[4]
		tableAverageCalls = tableData[5]
		return true
	end
end

-- TPS
-- Returns the exact tps value as listed in the profile
function getExactTps()
	local tpsValue = ""
	for k, v in pairs(tableTps) do
		tpsValue = v
	end
	
	return tpsValue
end

-- Rounds the tps value to given decimal places and returns it
-- Fixed, but not accurately rounding the number (using strsub method)
function getTps()
	-- return roundTo(getExactTps(), (places or 2))
	return string.sub(getExactTps(), 1, 5)
end

-- SingleEntities
-- Returns a table containing single entities that cause lag. 
-- Each row is a table containing the following keys: 
-- percent: percentage of time/tick, time: time/tick, name: name of entity, position: position of entity, dimId: dimension id containing entity, dimension: formatted dimension text
function getSingleEntities()
	local returnTable = {}
	
	for key, value in pairs(tableSingleEntity) do
		local row = {}
		row.percent = value["%"]
		row.time = value["Time/Tick"]
		
		local nameTable = functions.explode(" ", value["Single Entity"])
		-- the first part of the name contains the actual entity name
		row.name = nameTable[1]
		
		local dimTable = functions.explode(":", value["Single Entity"])
		row.dimId = dimTable[2]
		
		if (row.dimId == "1") then
			row.dimension = "The End"
		elseif (row.dimId == "0") then
			row.dimension = "Overworld"
		elseif (row.dimId == "-1") then
			row.dimension = "Nether"
		else
			row.dimension = row.dimId
		end
		
		-- strip off the dimension from the position
		local position = nameTable[2]
		local dimCharCount = string.len(row.dimId)
		row.position = string.sub(position, 0, string.len(position) - (dimCharCount + 1))
		
		
		table.insert(returnTable, row)
	end
	
	return returnTable
end

-- Chunks
-- Returns a table containing the chunks that cause lag.
-- Each row is a table containing the following keys:
-- percent: percentage of time/tick, time: time/tick, positionX: X coordinate of chunk, positionZ: Z coordinate of chunk
function getChunks()
	local returnTable = {}
	
	for key, value in pairs(tableChunk) do
		local row = {}
		row.percent = value["%"]
		row.time = value["Time/Tick"]
		
		local chunkTable = functions.explode("\, ", value["Chunk"])
		local chunkX = tonumber(chunkTable[1])
		local chunkZ = tonumber(chunkTable[2])
		
		local realX = chunkX * 16
		local realZ = chunkZ * 16
		
		row.positionX = realX
		row.positionZ = realZ
		
		table.insert(returnTable, row)
	end
	
	return returnTable
end

-- EntityByTypes
-- Returns a table containing the types of entities causing the most lag
-- Each row is a table containing the following keys:
-- percent: percentage of time/tick, time: time/tick, type: the type of entity that is listed
function getEntityByTypes()
	local returnTable = {}
	
	for key, value in pairs(tableEntityByType) do
		local row = {}
		row.percent = value["%"]
		row.time = value["Time/Tick"]
		row.type = value["All Entities of Type"]
		
		table.insert(returnTable, row)
	end
	
	return returnTable
end

-- AverageCallsPerEntity
-- Returns a table containing the top average calls made by specific entities
-- Each row is a table containing the following keys:
-- name: name of entity, time: time/tick, calls: number of calls made

function getAverageCalls()
	local returnTable = {}
	
	for key, value in pairs(tableAverageCalls) do
		local row = {}
		row.time = value["Time/tick"]
		row.name = value["Average Entity of Type"]
		row.calls = value["Calls"]
		
		table.insert(returnTable, row)
	end
	
	return returnTable
end

-- Miscellaneous Functions
-- Returns the color for the percentage based on severity
function getPercentColor(percent)
	local percentage = tonumber(percent)
	local percentageColor
	if (percentage >= 5) then
		percentageColor = colors.red
	elseif (percentage >= 3 and percentage < 5) then
		percentageColor = colors.yellow
	elseif (percentage >= 0 and percentage < 3) then
		percentageColor = colors.green
	end
	
	return percentageColor
end

-- Returns the color for the percentage based on severity
-- Hex version for glasses
function getPercentHexColor(percent)
	local percentage = tonumber(percent)
	local percentageColor
	if (percentage >= 5) then
		percentageColor = hexColor.red
	elseif (percentage >= 3 and percentage < 5) then
		percentageColor = hexColor.yellow
	elseif (percentage >= 0 and percentage < 3) then
		percentageColor = hexColor.green
	end
	
	return percentageColor
end

-- Returns the color for the TPS based on severity
function getTpsColor(tps)
	local tpsColor
	local tps = tonumber(tps)
	if (tps >= 18) then
	        tpsColor = colors.green
	elseif (tps >= 15 and tps < 18) then
	        tpsColor = colors.yellow
	elseif (tps < 15) then
	        tpsColor = colors.red
	end
	
	return tpsColor
end

function getTpsHexColor(tps)
	local tpsColor
	local tps = tonumber(tps)
	if (tps >= 18) then
	        tpsColor = hexColor.green
	elseif (tps >= 15 and tps < 18) then
	        tpsColor = hexColor.yellow
	elseif (tps < 15) then
	        tpsColor = hexColor.red
	end
	
	return tpsColor
end

-- Returns the dimension name given the server and dimension id
-- If the dimension id is a known minecraft constant, it does not lookup
-- the array.
function getDimensionName(server, dimensionId)
	if (dimensionId == "1") then
		return "The End"
	elseif (dimensionId == "0") then
		return "Overworld"
	elseif (dimensionId == "-1") then
		return "Nether"
	else
		for key, value in pairs(dimArray) do
			if (value.rrServer == tonumber(server) and value.dimensionId == tonumber(dimensionId)) then
				return value.dimensionName
			end
		end
	end
end

-- Resolves the RR server ID against the computer ID
-- Add new computerIds as needed
function getServerId(inputId)
	local computerId = tonumber(inputId)
	if (computerId == 17 or computerId == 26 or computerId == 27) then
		return 2
	elseif (computerId == 25 or computerId == 88 or computerId == 78) then
		return 1
	end
end