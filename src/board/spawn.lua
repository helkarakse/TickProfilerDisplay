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
local slideDelay = 10
local refreshDelay = 80

local dimId = string.sub(os.getComputerLabel(), 1, 1)
local remoteUrl = "http://www.otegamers.com/custom/helkarakse/upload.php?req=show&dim=" .. dimId .. "&output=json"

local limit = 10

-- Functions
local function getTps()
	local tps = tonumber(parser.getTps())
	return tps, parser.getTpsColor(tps)
end

-- Display
local function displayHeader()
	local xPos = 2
	local yPos = 2
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

local function displayDataHeading(id)
	local yPos = 7
	
	if (id == 1) then
		-- id 1 = the single entity list
		monitor.setCursorPos(2, yPos)
		monitor.write("Name:")
		monitor.setCursorPos(26, yPos)
		monitor.write("X - Y - Z:")
		monitor.setCursorPos(41, yPos)
		monitor.write("%")
		monitor.setCursorPos(53, yPos)
		monitor.write("Dimension:")
	elseif (id == 2) then
		-- id 2 = the chunk list
		monitor.setCursorPos(2, yPos)
		monitor.write("Chunk Position:")
		monitor.setCursorPos(26, yPos)
		monitor.write("Time/Tick")
		monitor.setCursorPos(41, yPos)
		monitor.write("%")
		monitor.setCursorPos(53, yPos)
		monitor.write("Dimension:")
	elseif (id == 3) then
		-- id 3 = the type list
		monitor.setCursorPos(2, yPos)
		monitor.write("Type:")
		monitor.setCursorPos(26, yPos)
		monitor.write("Time/Tick:")
		monitor.setCursorPos(41, yPos)
		monitor.write("%")
	elseif (id == 4) then
		-- id 4 = the call list
		monitor.setCursorPos(2, yPos)
		monitor.write("Name:")
		monitor.setCursorPos(26, yPos)
		monitor.write("Time/Tick:")
		monitor.setCursorPos(41, yPos)
		monitor.write("Calls")
	end
end

local function displayData(id)
	local next = next
	local yPos = 8

	if (id == 1) then
		local data = parser.getSingleEntities()
		if (next(data) ~= nil) then
			for i = 1, limit do
				monitor.setCursorPos(2, yPos)
				monitor.write(data[i].name)
				monitor.setCursorPos(26, yPos)
				monitor.write(data[i].position)
				monitor.setCursorPos(41, yPos)
				 
				local percentage = tonumber(data[i].percent)
				monitor.setTextColor(parser.getPercentColor(percentage))
				monitor.write(percentage)
				monitor.setTextColor(colors.white)
				
				-- dimIds
				monitor.setCursorPos(53, yPos)
				monitor.write(data[i].dimension)
				
				yPos = yPos + 1
			end
			
			yPos = yPos + 1
			monitor.setCursorPos(2, yPos)
			monitor.write("Last updated at: " .. parser.getUpdatedDate())
		end
	elseif (id == 2) then
		-- id 2 = the chunk list
		local data = parser.getChunks()
		if (next(data) ~= nil) then
			for i = 1, limit do
				monitor.setCursorPos(2, yPos)
				monitor.write(data[i].positionX .. ", " .. data[i].positionZ)
				monitor.setCursorPos(26, yPos)
				monitor.write(data[i].time)
				monitor.setCursorPos(41, yPos)
				 
				local percentage = tonumber(data[i].percent)
				monitor.setTextColor(parser.getPercentColor(percentage))
				monitor.write(percentage)
				monitor.setTextColor(colors.white)
				
				-- dimIds
				monitor.setCursorPos(53, yPos)
				monitor.write(data[i].dimension)
				
				yPos = yPos + 1
			end
			
			yPos = yPos + 1
			monitor.setCursorPos(2, yPos)
			monitor.write("Last updated at: " .. parser.getUpdatedDate())
		end
	elseif (id == 3) then
		-- id 3 = the type list
		local data = parser.getEntityByTypes()
		if (next(data) ~= nil) then
			for i = 1, limit do
				monitor.setCursorPos(2, yPos)
				monitor.write(data[i].type)
				monitor.setCursorPos(26, yPos)
				monitor.write(data[i].time)
				monitor.setCursorPos(41, yPos)
				 
				local percentage = tonumber(data[i].percent)
				monitor.setTextColor(parser.getPercentColor(percentage))
				monitor.write(percentage)
				monitor.setTextColor(colors.white)
				
				yPos = yPos + 1
			end
			
			yPos = yPos + 1
			monitor.setCursorPos(2, yPos)
			monitor.write("Last updated at: " .. parser.getUpdatedDate())
		end
	elseif (id == 4) then
		-- id 4 = the call list
		local data = parser.getAverageCalls()
		if (next(data) ~= nil) then
			for i = 1, limit do
				monitor.setCursorPos(2, yPos)
				monitor.write(data[i].name or "")
				monitor.setCursorPos(26, yPos)
				monitor.write(data[i].time or "")
				monitor.setCursorPos(41, yPos)
				monitor.write(data[i].calls or "")
				
				yPos = yPos + 1
			end
			
			yPos = yPos + 1
			monitor.setCursorPos(2, yPos)
			monitor.write("Last updated at: " .. parser.getUpdatedDate())
		end
	end
end

-- Loops
local refreshLoop = function()
	while true do
		local data = http.get(remoteUrl)
		if (data) then
			functions.debug("Data retrieved from remote server.")
			-- re-parse the data
			local text = data.readAll()
			parser.parseData(text)
			functions.debug("Data parsing complete.")
			
			monitor.clear()
			displayHeader()
			displayDataHeading(1)
			displayData(1)
			
			functions.debug("Screen refreshed.")
		else
			functions.debug("Failed to retrieve data from remote server.")
		end
		
		sleep(refreshDelay)
	end
end

local slideLoop = function()
	while true do
		for i = 1, 4 do
			functions.debug("Displaying screen #", i)
			
			monitor.clear()
			displayHeader()
			displayDataHeading(i)
			displayData(i)
			
			sleep(slideDelay)
		end
	end
end

local function init()
	functions.debug("Current server id is: ", dimId)
	
	local monFound, monDir = functions.locatePeripheral("monitor")
	if (monFound == true) then
		monitor = peripheral.wrap(monDir)
	else
		functions.debug("A monitor is required to use this program.")
		return
	end
	
	-- open the file for parsing
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
	
	monitor.clear()
	displayHeader()
	displayDataHeading(1)
	displayData(1)
	
	parallel.waitForAll(slideLoop, refreshLoop)
end

init()
