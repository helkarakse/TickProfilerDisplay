--[[

	Terminal Glasses Lite Version 0.1 Dev
	Do not modify, copy or distribute without permission of author
	Helkarakse & Shotexpert, 20131203

]]

-- Libraries
os.loadAPI("functions")
os.loadAPI("parser")

-- Variables
local jsonFile = "profile.txt"
local bridge, mainBox, edgeBox
local header, headerText, clockText, tpsText
local limit = 5
local lineMultiplier = 5

local args = {...}

local colors = {
	headerStart = 0x18caf0,
	headerEnd = 0x9fedfd,
	white = 0xffffff
}

local size = {
	small = 0.5, normal = 0.75, large = 1
}

-- Functions
local function drawMain(inputX, inputY, inputWidth, inputHeight)	
	mainBox = bridge.addBox(inputX, inputY, inputWidth, inputHeight, colors.headerEnd, 0.3)
	header = bridge.addGradientBox(inputX-5, inputY, inputWidth, 7, colors.headerEnd, 0, colors.headerStart, 1, 2)
	edgeBox = bridge.addGradientBox(inputX, inputY+inputHeight-2, inputWidth, 2, colors.headerStart, 1, colors.headerEnd, 0, 2)
	header.setZIndex(2)
end

local function drawHeader(inputX, inputY)
	headerText = bridge.addText(inputX, inputY + 2, "OTE Glasses    LITE", colors.white)
	headerText.setZIndex(3)
	headerText.setScale(size.small)
end

local function drawTps(inputX, inputY)
	local tps = parser.getTps()
	tpsText = bridge.addText(240, 225, tps, parser.getTpsHexColor(tps))
	tpsText.setScale(size.normal)
	tpsText.setZIndex(3)
	clockText = bridge.addText(240, inputY + 2, "clock", colors.white)
	clockText.setScale(size.small)
	clockText.setZIndex(3)
end

local function drawEntities(inputX, inputY)
	local data = parser.getSingleEntities()
	bridge.addText(inputX, inputY, "Entity Name:", colors.white).setScale(size.small)
	bridge.addText(inputX + 100, inputY, "Position:", colors.white).setScale(size.small)
	bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small)
	bridge.addText(inputX + 200, inputY, "Dimension:", colors.white).setScale(size.small)
	
	for i = 1, limit do
		bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].name, colors.white).setScale(size.small)
		bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].position, colors.white).setScale(size.small)
		bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small)
		bridge.addText(inputX + 200, inputY + (lineMultiplier * i), parser.getDimensionName(1, data[i].dimId), colors.white).setScale(size.small)
	end
end

local function drawChunks(inputX, inputY)
	local data = parser.getChunks()
	bridge.addText(inputX, inputY, "Chunk Position (X, Z):", colors.white).setScale(size.small)
	bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small)
	bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small)
	
	for i = 1, limit do
		bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].positionX .. ", " .. data[i].positionZ, colors.white).setScale(size.small)
		bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small)
		bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small)
	end
end

local function drawTypes(inputX, inputY)
	local data = parser.getEntityByTypes()
	bridge.addText(inputX, inputY, "Entity Type:", colors.white).setScale(size.small)
	bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small)
	bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small)
	
	for i = 1, limit do
		bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].type, colors.white).setScale(size.small)
		bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small)
		bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small)
	end
end

local function drawCalls(inputX, inputY)
	local data = parser.getAverageCalls()
	bridge.addText(inputX, inputY, "Entity Name:", colors.white).setScale(size.small)
	bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small)
	bridge.addText(inputX + 150, inputY, "Average Calls", colors.white).setScale(size.small)
	
	for i = 1, limit do
		bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].name, colors.white).setScale(size.small)
		bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small)
		bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].calls, colors.white).setScale(size.small)
	end
end

local function drawSanta(inputX, inputY)
	local boxArray = {}
	--white parts
	table.insert(boxArray, bridge.addBox(inputX, inputY-9, 2, 2, colors.white, 1))
	table.insert(boxArray, bridge.addBox(inputX-9, inputY-1, 9, 2, colors.white, 1))
	
	--red parts
	table.insert(boxArray, bridge.addBox(inputX-2, inputY-8, 2, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-3, inputY-7, 4, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-4, inputY-6, 5, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-5, inputY-5, 5, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-6, inputY-4, 5, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-7, inputY-3, 6, 1, colors.red, 1))
	table.insert(boxArray, bridge.addBox(inputX-8, inputY-2, 8, 1, colors.red, 1))
	
	--set zindexes
	for key, value in pairs(boxArray) do
		value.setZIndex(4)
	end
end

local tpsRefreshLoop = function()
	while true do
		local file = fs.open(jsonFile, "r")
		local text = file.readAll()
		file.close()
		
		parser.parseData(text)
		tpsText.setText(parser.getTps())
		sleep(15)
	end
end

local clockRefreshLoop = function()
	while true do
		local nTime = os.time()
		clockText.setText(textutils.formatTime(nTime, false))
		sleep(1)
	end
end

local function init()
	local hasBridge, bridgeDir = functions.locatePeripheral("glassesbridge")
	if (hasBridge ~= true) then
		functions.debug("Terminal glasses bridge peripheral required.")
	else
		functions.debug("Found terminal bridge peripheral at: ", bridgeDir)
		bridge = peripheral.wrap(bridgeDir)
		bridge.clear()
	end
	
	local file = fs.open(jsonFile, "r")
	local text = file.readAll()
	file.close()
	
	functions.debug("Beginning initial data parsing.")
	parser.parseData(text)
	functions.debug("Data parsing complete.")
	
	drawMain(10, 65, 250, 160)
	drawHeader(10, 65)
	drawTps(10, 65)
--	drawSanta(105,120)
	drawEntities(15, 75)
	drawChunks(15, 110)
	drawTypes(15, 145)
	drawCalls(15, 180)
	
	parallel.waitForAll(tpsRefreshLoop, clockRefreshLoop)
end

init()
