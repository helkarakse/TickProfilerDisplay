--[[

	TickProfiler Board Version 1.0 Alpha
	Do not modify, copy or distribute without permission of author
	Helkarakse, 20131201

]]

-- Functions
os.loadAPI("functions")
os.loadAPI("parser")

-- Variables
local monitor
local state = 1
local headerY = 8
local displayY = 9
local limit = 10

local dimId = string.sub(os.getComputerLabel(), 1, 1)
local remoteUrl = "http://www.otegamers.com/custom/helkarakse/upload.php?req=show&dim=" .. dimId .. "&output=json"

local next = next
local tonumber = tonumber

-- Menu array (left side)
local menuArray = {
	{name = "Entities", screen = "entities"},
	{name = "Chunks", screen = "chunks"},
	{name = "Types", screen = "types"},
	{name = "Calls", screen = "calls"}
}

-- Display
local function displayHeader()
	local tps = tonumber(parser.getTps())
	
	monitor.clear()
	monitor.setCursorPos(2, 1)
	monitor.write("OTE-Gaming Tickboard of Shame")
	monitor.setCursorPos(2, 2)
	monitor.write("Powered by Helk & Shot")
	monitor.setCursorPos(2, 4)
	monitor.write("Global TPS: ")
	monitor.setCursorPos(13, 4)
	monitor.setTextColor(parser.getTpsColor(tps))
	monitor.write(tps)
	monitor.setTextColor(colors.white)
	monitor.setCursorPos(2, 6)
	monitor.write("Last updated at: " .. parser.getUpdatedDate())
end

local function displayMenu(id)
	local x = 2
	local y = headerY
	
	for i = 1, #menuArray do
		-- write first column
		monitor.setCursorPos(x, y)
		if (i == id) then
			monitor.setTextColor(colors.orange)
		else
			monitor.setTextColor(colors.white)
		end
		
		monitor.write(menuArray[i].name .. " > ")
		monitor.setTextColor(colors.white)
		y = y + 2
	end
end

local function displayEntities()
	local entityX = 15
	local posX = 40
	local percentX = 55
	local dimX = 67
	
	monitor.setCursorPos(entityX, headerY)
	monitor.write("Entity Name:")
	monitor.setCursorPos(posX, headerY)
	monitor.write("Position:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")
	monitor.setCursorPos(dimX, headerY)
	monitor.write("Dimension")

	local y = displayY
	local entities = parser.getSingleEntities()
	if (next(entities) ~= nil) then
		for i = 1, limit do
			monitor.setCursorPos(entityX, y)
			monitor.write(entities[i].name)
			monitor.setCursorPos(posX, y)
			monitor.write(entities[i].position)
			monitor.setCursorPos(percentX, y)
			 
			monitor.setTextColor(parser.getPercentColor(entities[i].percent))
			monitor.write(entities[i].percent)
			monitor.setTextColor(colors.white)
			
			-- dimensions
			monitor.setCursorPos(dimX, y)
			monitor.write(entities[i].dimension)
			
			y = y + 1
		end
	end
end

local function displayChunks()
	local posX = 15
	local timeX = 30
	local percentX = 45
	local dimX = 57
	
	monitor.setCursorPos(posX, headerY)
	monitor.write("Position:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")
	monitor.setCursorPos(dimX, headerY)
	monitor.write("Dimension")

	local y = displayY
	local chunks = parser.getChunks()
	if (next(chunks) ~= nil) then
		for i = 1, limit do
			monitor.setCursorPos(posX, y)
			monitor.write(chunks[i].positionX .. ", " .. chunks[i].positionZ)
			monitor.setCursorPos(timeX, y)
			monitor.write(chunks[i].time)
			monitor.setCursorPos(percentX, y)
			monitor.setTextColor(parser.getPercentColor(chunks[i].percent))
			monitor.write(chunks[i].percent)
			monitor.setTextColor(colors.white)
			monitor.setCursorPos(dimX, y)
			monitor.write(chunks[i].dimension)
			y = y + 1
		end
	end
end

local function displayTypes()
	local typeX = 15
	local timeX = 40
	local percentX = 55
	
	monitor.setCursorPos(typeX, headerY)
	monitor.write("Type:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")

	local y = displayY
	local types = parser.getEntityByTypes()
	if (next(types) ~= nil) then
		for i = 1, limit do
			monitor.setCursorPos(typeX, y)
			monitor.write(types[i].type)
			monitor.setCursorPos(timeX, y)
			monitor.write(types[i].time)
			monitor.setCursorPos(percentX, y)
			monitor.setTextColor(parser.getPercentColor(types[i].percent))
			monitor.write(types[i].percent)
			monitor.setTextColor(colors.white)
			y = y + 1
		end
	end
end

local function displayCalls()
	local nameX = 15
	local timeX = 40
	local callX = 55
	
	monitor.setCursorPos(nameX, headerY)
	monitor.write("Name:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(callX, headerY)
	monitor.write("Average Calls")

	local y = displayY
	local calls = parser.getAverageCalls()
	if (next(calls) ~= nil) then
		for i = 1, limit do
			monitor.setCursorPos(nameX, y)
			monitor.write(calls[i].name)
			monitor.setCursorPos(timeX, y)
			monitor.write(calls[i].time)
			monitor.setCursorPos(callX, y)
			monitor.write(calls[i].calls)
			y = y + 1
		end
	end
end

-- Screen changing
local function displayScreen(id) 
	functions.debug("Displaying the screen for id: ", id)
	state = id
	
	monitor.clear()
	displayHeader()
	displayMenu(id)
	if (id == 1) then
		displayEntities()
	elseif (id == 2) then
		displayChunks()
	elseif (id == 3) then
		displayTypes()
	elseif (id == 4) then
		displayCalls()
	end
end

-- Listeners
-- Listener to listen for monitor touch events
local monitorListener = function()
	while true do
		local event, side, xPos, yPos = os.pullEvent("monitor_touch")
		functions.debug("Detected monitor touch at (", xPos, ", ", yPos, ")")
		
		if (yPos % 2 == 0 and xPos <= 14) then
			local menuId = (yPos - 6) / 2
			if (menuId <= #menuArray and menuId ~= 0 and menuId ~= nil) then
				displayScreen(menuId)
			end
		end
	end
end

-- Listener to refresh parsed data
local refreshListener = function()
	while true do
		local data = http.get(remoteUrl)
		if (data) then
			functions.debug("Data retrieved from remote server.")
			-- re-parse the data
			local text = data.readAll()
			parser.parseData(text)
			functions.debug("Refreshing data.")
			displayScreen(state)
			functions.debug("Refreshing screen.")
		else
			functions.debug("Failed to retrieve data from remote server.")
		end
		sleep(60)
	end
end

local function init()
	functions.debug("Current server id is: ", dimId)
	local data = http.get(remoteUrl)
	if (data) then
		functions.debug("Data retrieved from remote server.")
		-- re-parse the data
		local text = data.readAll()
		parser.parseData(text)
		functions.debug("Data parsing complete.")
	else
		functions.debug("Failed to retrieve data from remote server.")
	end
	
	-- find the monitor and init vars
	local monFound, monDir = functions.locatePeripheral("monitor");
	if (monFound == true) then
		monitor = peripheral.wrap(monDir)
		local screenW, screenH = monitor.getSize()
		functions.debug("Monitor size is: ", screenW, "x", screenH)
	else
		-- no monitor found
		functions.debug("A monitor is required to use this program.")
		return
	end
	
	displayScreen(state)
	parallel.waitForAll(monitorListener, refreshListener)
end

init()
