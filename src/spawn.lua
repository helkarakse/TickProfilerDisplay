--[[
 
        TickProfiler Basic Version 1.0 Alpha
        Do not modify, copy or distribute without permission of author
        Shotexpert, 20131201
 
]]
 
--library
os.loadAPI("parser")

--initial actions
local monitor = peripheral.wrap("top")

local file = fs.open("data", "r")
local text = file.readAll()
file.close()
parser.parseData(text)

--program start

local tps = tonumber(parser.getTps())
local tpsColour
if (tps >= 18) then
	tpsColour = colors.green
elseif (tps >= 15 and tps < 18) then
	tpsColour = colors.yellow
elseif (tps < 15) then
	tpsColour = colors.red
end

monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Global TPS: ")
monitor.setCursorPos(13,1)
monitor.setTextColor(tpsColour)
monitor.write(tps)
monitor.setTextColor(colors.white)

-- 0 to 3, 3 to 5, above 5

--headers
monitor.setCursorPos(1,3)
monitor.write("Name:")
monitor.setCursorPos(25,3)
monitor.write("X - Y - Z:")
monitor.setCursorPos(40,3)
monitor.write("ServerLoad:")
monitor.setCursorPos(52,3)
monitor.write("Dimension:")

local singleEntities = parser.getSingleEntities()
for i = 1, 10 do
monitor.setCursorPos(1, i+3)
monitor.write(singleEntities[i].name)
monitor.setCursorPos(25, i+3)
monitor.write(singleEntities[i].position)
monitor.setCursorPos(40, i+3)

local percentage = tonumber(singleEntities[i].percent)
local percentageColour
if (percentage >= 5) then
	percentageColour = colors.green
elseif (percentage >= 3 and percentage < 5) then
	percentageColour = colors.yellow
elseif (percentage >= 0 and percentage < 3) then
	percentageColour = colors.red
end

monitor.setTextColor(percentageColour)
monitor.write(percentage)
monitor.setTextColor(colors.white)

monitor.setCursorPos(52, i+3)
monitor.write(singleEntities[i].dimension)
end