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

local function init()
	local monFound, monDir = functions.locatePeripheral("monitor")
	if (monFound == true) then
		monitor = peripheral.wrap(monDir)
	else
		functions.debug("A monitor is required to use this program.")
		return
	end
end

while true do
	--initial actions
	local monitor = peripheral.wrap("top")
	 
	local file = fs.open("profile.txt", "r")
	local text = file.readAll()
	file.close()
	parser.parseData(text)
	 
	--program start
	local tps, tpsColor = getTps()
	monitor.clear()
	monitor.setCursorPos(1,1)
	monitor.write("OTE-Gaming Tickboard of Shame")
	monitor.setCursorPos(1,2)
	monitor.write("Powered by Helk & Shot")
	monitor.setCursorPos(1,4)
	monitor.write("Global TPS: ")
	monitor.setCursorPos(13,4)
	monitor.setTextColor(tpsColor)
	monitor.write(tps)
	monitor.setTextColor(colors.white)
	 
	--headers
	monitor.setCursorPos(1,6)
	monitor.write("Name:")
	monitor.setCursorPos(25,6)
	monitor.write("X - Y - Z:")
	monitor.setCursorPos(40,6)
	monitor.write("%")
	monitor.setCursorPos(52,6)
	monitor.write("Dimension:")
	 
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
	
	sleep(60)
end
