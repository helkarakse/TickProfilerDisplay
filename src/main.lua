--[[

	TickProfiler Board Version 1.0 Alpha
	Do not modify, copy or distribute without permission of author
	Helkarakse, 20131201

]]

-- Functions
os.loadAPI("functions")
os.loadAPI("parser")

-- Variables
local monitor, state
local jsonFile = "data"

-- Menu array (left side)
local menuArray = {
	{name = "Entities", screen = "entities"},
	{name = "Chunks", screen = "chunks"},
	{name = "Types", screen = "types"},
	{name = "Calls", screen = "calls"}
}

-- Display
local function displayMenu(id)
	local x = 2
	local y = 2
	
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

local function displayTps()
	local tps = tonumber(parser.getTps())
	local tpsColor
	if (tps >= 18) then
	        tpsColor = colors.green
	elseif (tps >= 15 and tps < 18) then
	        tpsColor = colors.yellow
	elseif (tps < 15) then
	        tpsColor = colors.red
	end
	
	monitor.setCursorPos(2, 14)
	monitor.setTextColor(tpsColor)
	monitor.write("TPS: " .. tps)
	monitor.setTextColor(colors.white)
	monitor.setCursorPos(2, 15)
	monitor.write("Helkarakse")
	monitor.setCursorPos(1, 1)
end

local function displayEntities()
	local entityX = 15
	local posX = 40
	local percentX = 55
	local dimX = 67
	
	local headerY = 2
	monitor.setCursorPos(entityX, headerY)
	monitor.write("Entity Name:")
	monitor.setCursorPos(posX, headerY)
	monitor.write("Position:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")
	monitor.setCursorPos(dimX, headerY)
	monitor.write("Dimension")

	local y = 3
	local entities = parser.getSingleEntities()
	
	for i = 1, 5 do
		monitor.setCursorPos(entityX, y)
		monitor.write(entities[i].name)
		monitor.setCursorPos(posX, y)
		monitor.write(entities[i].position)
		monitor.setCursorPos(percentX, y)
		
		local percentage = tonumber(entities[i].percent)
		local percentageColor
		if (percentage >= 5) then
		        percentageColor = colors.red
		elseif (percentage >= 3 and percentage < 5) then
		        percentageColor = colors.yellow
		elseif (percentage >= 0 and percentage < 3) then
		        percentageColor = colors.green
		end
		 
		monitor.setTextColor(percentageColor)
		monitor.write(percentage)
		monitor.setTextColor(colors.white)
		
		monitor.setCursorPos(dimX, y)
		monitor.write(entities[i].dimension)
		y = y + 1
	end
end

local function displayChunks()
	local posX = 15
	local timeX = 30
	local percentX = 45
	
	local headerY = 2
	monitor.setCursorPos(posX, headerY)
	monitor.write("Position:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")

	local y = 3
	
	local chunks = parser.getChunks()
	
	for i = 1, 5 do
		monitor.setCursorPos(posX, y)
		monitor.write(chunks[i].positionX .. ", " .. chunks[i].positionZ)
		monitor.setCursorPos(timeX, y)
		monitor.write(chunks[i].time)
		monitor.setCursorPos(percentX, y)
		monitor.write(chunks[i].percent)
		y = y + 1
	end
end

local function displayTypes()
	local typeX = 15
	local timeX = 40
	local percentX = 55
	
	local headerY = 2
	monitor.setCursorPos(typeX, headerY)
	monitor.write("Type:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(percentX, headerY)
	monitor.write("%")

	local y = 3
	
	local types = parser.getEntityByTypes()
	
	for i = 1, 5 do
		monitor.setCursorPos(typeX, y)
		monitor.write(types[i].type)
		monitor.setCursorPos(timeX, y)
		monitor.write(types[i].time)
		monitor.setCursorPos(percentX, y)
		monitor.write(types[i].percent)
		y = y + 1
	end
end

local function displayCalls()
	local nameX = 15
	local timeX = 40
	local callX = 55
	
	local headerY = 2
	monitor.setCursorPos(nameX, headerY)
	monitor.write("Name:")
	monitor.setCursorPos(timeX, headerY)
	monitor.write("Time/Tick:")
	monitor.setCursorPos(callX, headerY)
	monitor.write("Average Calls")

	local y = 3
	
	local calls = parser.getAverageCalls()
	
	for i = 1, 5 do
		monitor.setCursorPos(nameX, y)
		monitor.write(calls[i].name)
		monitor.setCursorPos(timeX, y)
		monitor.write(calls[i].time)
		monitor.setCursorPos(callX, y)
		monitor.write(calls[i].calls)
		y = y + 1
	end
end

-- Screen changing
local function displayScreen(id) 
	functions.debug("Displaying the screen for id: ", id)
	state = menuArray[id].screen
	
	monitor.clear()
	displayMenu(id)
	displayTps()
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
			local menuId = yPos / 2
			if (menuId <= #menuArray) then
				displayScreen(menuId)
			end
		end
	end
end

-- Listener to refresh parsed data
local refreshListener = function()
	while true do
		local file = fs.open(jsonFile, "r")
		local text = file.readAll()
		file.close()
		
		parser.parseData(text)
		functions.debug("Refreshing data...")
		sleep(60)
	end
end

local function init()
	-- open the file for parsing
	local file = fs.open(jsonFile, "r")
	local text = file.readAll()
	file.close()
	
	-- parse the data into internal tables
	functions.debug("Beginning initial data parsing.")
	parser.parseData(text)
	functions.debug("Data parsing complete.")
	
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
	
	displayScreen(1)
	parallel.waitForAll(monitorListener, refreshListener)
end

init()