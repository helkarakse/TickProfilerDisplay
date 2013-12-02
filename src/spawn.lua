--[[
 
        TickProfiler Basic Version 1.0 Alpha
        Do not modify, copy or distribute without permission of author
        Helkarakse-Shotexpert, 20131201
 
]]

-- Libraries
os.loadAPI("parser")
os.loadAPI("functions")

-- Variables
local monitor
local slideDelay = 5
local refreshDelay = 60
local jsonFile = "profile.txt"

-- Functions
local function getTps()
	local tps = tonumber(parser.getTps())
	local tpsColor
	if (tps >= 18) then
	        tpsColor = colors.green
	elseif (tps >= 15 and tps < 18) then
	        tpsColor = colors.yellow
	elseif (tps < 15) then
	        tpsColor = colors.red
	end
	
	return tps, tpsColor
end

-- Display
local function displayHeader()
	local xPos = 1
	local yPos = 1
	local tps, tpsColor = getTps()
	
	monitor.setCursorPos(xPos, yPos)
	monitor.write("OTE-Gaming Tickboard of Shame")
	monitor.setCursorPos(xPos, yPos + 1)
	monitor.write("Powered by Helk & Shot")
	monitor.setCursorPos(xPos, yPos + 3)
	monitor.write("Global TPS: ")
	monitor.setCursorPos(xPos + 12, yPos + 3)
	monitor.setTextColor(tpsColor)
	monitor.write(tps)
	monitor.setTextColor(colors.white)
end

local function displayDataHeading()
	local yPos = 6
	monitor.setCursorPos(1, yPos)
	monitor.write("Name:")
	monitor.setCursorPos(25, yPos)
	monitor.write("X - Y - Z:")
	monitor.setCursorPos(40, yPos)
	monitor.write("%")
	monitor.setCursorPos(52, yPos)
	monitor.write("Dimension:")
end

local function displayData(id)
	local singleEntities = parser.getSingleEntities()
	for i = 1, 10 do
		monitor.setCursorPos(1, i+6)
		monitor.write(singleEntities[i].name)
		monitor.setCursorPos(25, i+6)
		monitor.write(singleEntities[i].position)
		monitor.setCursorPos(40, i+6)
		 
		local percentage = tonumber(singleEntities[i].percent)
		local percentageColour
		if (percentage >= 5) then
		        percentageColour = colors.red
		elseif (percentage >= 3 and percentage < 5) then
		        percentageColour = colors.yellow
		elseif (percentage >= 0 and percentage < 3) then
		        percentageColour = colors.green
		end
		 
		monitor.setTextColor(percentageColour)
		monitor.write(percentage)
		monitor.setTextColor(colors.white)
		
		-- dimensions
		monitor.setCursorPos(52, i+6)
		if (tonumber(singleEntities[i].dimId) == 11) then
			monitor.write("Gold Mining Age")
		else
			monitor.write(singleEntities[i].dimension)
		end
	end
end

-- Loops
local refreshLoop = function()
	while true do
		local file = fs.open(jsonFile, "r")
		local text = file.readAll()
		file.close()
		
		parser.parseData(text)
		functions.debug("Refreshing data.")
		displayData(1)
		functions.debug("Refreshing screen.")
		sleep(refreshDelay)
	end
end

local slideLoop = function()
	
end

local function init()
	local monFound, monDir = functions.locatePeripheral("monitor")
	if (monFound == true) then
		monitor = peripheral.wrap(monDir)
	else
		functions.debug("A monitor is required to use this program.")
		return
	end
	
	local file = fs.open(jsonFile, "r")
	local text = file.readAll()
	file.close()
	parser.parseData(text)
	
	monitor.clear()
	displayHeader()
	displayDataHeading()
	displayData(1)
	
	parallel.waitForAll(slideLoop, refreshLoop)
end

init()
