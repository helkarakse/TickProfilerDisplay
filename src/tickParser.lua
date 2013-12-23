--[[

TickProfiler JSON Data Parser
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

-- Variables
local stringData, tableData, tableTps, tableSingleEntity, tableChunk, tableEntityByType, tableAverageCalls, tableUpdated

-- References
local tonumber = tonumber
local tostring = tostring
local colors = colors

-- Dimension names
local dimArray = {
	{dimensionId = 0, dimensionName = "Overworld"},
	{dimensionId = -1, dimensionName = "Nether"},
	{dimensionId = 1, dimensionName = "The End"},
	{dimensionId = 4, dimensionName = "Public Mining"},
	{dimensionId = 7, dimensionName = "Twilight Forest"},
	{dimensionId = 8, dimensionName = "Silver Mining"},
	{dimensionId = 9, dimensionName = "Gold Mining"},
	{dimensionId = -31, dimensionName = "Secret Cow Level"},
	{dimensionId = -20, dimensionName = "Promised Lands"},
	{dimensionId = 100, dimensionName = "Deep Dark"},
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
		tableUpdated = tableData[6]
		return true
	end
end

-- Last Updated
function getUpdatedDate()
	local updatedValue = ""
	for k, v in pairs(tableUpdated) do
		updatedValue = v
	end

	return updatedValue
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
	local tps = string.sub(getExactTps(), 1, 5)
	if (tonumber(tps) > 20) then
		return "20.00"
	else
		return tps
	end
end

-- Returns the dimension name given the server and dimension id
-- If the dimension id is a known minecraft constant, it does not lookup
-- the array.
local function getDimensionName(dimensionId)
	for key, value in pairs(dimArray) do
		if (value.dimensionId == tonumber(dimensionId)) then
			return value.dimensionName
		end
	end
	return "Unknown"
end

-- SingleEntities
-- Returns a table containing single entities that cause lag.
-- Each row is a table containing the following keys:
-- percent: percentage of time/tick, time: time/tick, name: name of entity, position: position of entity, dimension: formatted dimension text
function getSingleEntities()
	local returnTable = {}

	for key, value in pairs(tableSingleEntity) do
		local row = {}
		row.percent = value["%"]
		row.time = value["Time/Tick"]

		local name, posX, posY, posZ, dimensionId = string.match(value["Single Entity"], "(.*)\ (.*)\,(.*)\,(.*)\:(.*)")
		row.name = name
		row.dimension = getDimensionName(dimensionId)
		row.position = posX .. ", " .. posY .. ", " .. posZ

		table.insert(returnTable, row)
	end

	return returnTable
end

-- Chunks
-- Returns a table containing the chunks that cause lag.
-- Each row is a table containing the following keys:
-- percent: percentage of time/tick, time: time/tick, positionX: X coordinate of chunk, positionZ: Z coordinate of chunk, dimension: dimension of chunk
function getChunks()
	local returnTable = {}

	for key, value in pairs(tableChunk) do
		local row = {}
		row.percent = value["%"]
		row.time = value["Time/Tick"]

		local chunkX, chunkZ = string.match(value["Chunk"], "(.*)\,\ (.*)")

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
