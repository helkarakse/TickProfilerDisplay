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
	local tps = parser.getTps()
	monitor.setCursorPos(2, 14)
	monitor.write("TPS: " .. tps)
	monitor.setCursorPos(2, 15)
	monitor.write("Helkarakse")
	monitor.setCursorPos(1, 1)
end

local function displayEntities()

end

local function displayChunks()

end

local function displayTypes()

end

local function displayCalls()

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
	elseif (id == 3) then
	elseif (id == 4) then
	end
end

-- Listeners
-- Listener to listen for monitor touch events
local monitorListener = function()
	while true do
		local event, side, xPos, yPos = os.pullEvent("monitor_touch")
		functions.debug("Detected monitor touch at (", xPos, ", ", yPos, ")")
		
--		if (state == "main") then
--			
--		end
		
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