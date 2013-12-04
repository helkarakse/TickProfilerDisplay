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
local header, headerText, clockText, tpsText, lastUpdatedText
local limit = 5

local lastUpdated, currentFileSize

local colors = {
	headerStart = 0x18caf0,
	headerEnd = 0x9fedfd,
	white = 0xffffff, 
	red = 0xFF0000
}

local size = {
	small = 0.6, normal = 1, large = 1.25
}

-- Positioning Variables
local headerHeight = (size.small * 10)
local tpsHeight = (size.normal * 10)
local lineMultiplier = headerHeight

local mainX = 10
local mainY = 65
local mainWidth = 250
local mainHeight = (28 * lineMultiplier) + 10

local entitiesArray, chunksArray, typesArray, callsArray

-- Functions
local function drawMain(inputX, inputY, inputWidth, inputHeight)
	mainBox = bridge.addBox(inputX, inputY, inputWidth, inputHeight, colors.headerEnd, 0.3)
	header = bridge.addGradientBox(inputX-5, inputY, inputWidth, headerHeight, colors.headerEnd, 0, colors.headerStart, 1, 2)
	edgeBox = bridge.addGradientBox(inputX, inputY+inputHeight-2, inputWidth, 2, colors.headerStart, 1, colors.headerEnd, 0, 2)
	header.setZIndex(2)
end

local function drawHeader(inputX, inputY)
	headerText = bridge.addText(inputX, inputY + 1, "OTE Glass - Tick Lite (c) Helk & Shot 2013", colors.white)
	headerText.setZIndex(3)
	headerText.setScale(size.small)
end

local function drawTps(inputX, inputY)
	local tps = parser.getTps()
	
	local tpsLabelText = bridge.addText(mainX + mainWidth - 55, mainY + mainHeight - tpsHeight, "TPS:", colors.white)
	tpsLabelText.setScale(size.normal)
	tpsLabelText.setZIndex(4)
	
	tpsText = bridge.addText(mainX + mainWidth - 30, mainY + mainHeight - tpsHeight, tps, parser.getTpsHexColor(tps))
	tpsText.setScale(size.normal)
	tpsText.setZIndex(4)
	
	clockText = bridge.addText(mainX + mainWidth - 30, inputY + 1, "", colors.white)
	clockText.setScale(size.small)
	clockText.setZIndex(4)
	
	local lastUpdatedLabelText = bridge.addText(mainX + mainWidth - 100, inputY + 1, "Last Updated:", colors.white)
	lastUpdatedLabelText.setScale(size.small)
	lastUpdatedLabelText.setZIndex(4)
	
	lastUpdatedText = bridge.addText(mainX + mainWidth - 55, inputY + 1, "", colors.white)
	lastUpdatedText.setScale(size.small)
	lastUpdatedText.setZIndex(4)
end

local function drawEntities(inputX, inputY)
	local data = parser.getSingleEntities()
	entitiesArray = {}
	
	table.insert(entitiesArray, bridge.addText(inputX, inputY, "Entity Name:", colors.white).setScale(size.small))
	table.insert(entitiesArray, bridge.addText(inputX + 100, inputY, "Position:", colors.white).setScale(size.small))
	table.insert(entitiesArray, bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small))
	table.insert(entitiesArray, bridge.addText(inputX + 200, inputY, "Dimension:", colors.white).setScale(size.small))
	
	for i = 1, limit do
		table.insert(entitiesArray, bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].name, colors.white).setScale(size.small))
		table.insert(entitiesArray, bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].position, colors.white).setScale(size.small))
		table.insert(entitiesArray, bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small))
		table.insert(entitiesArray, bridge.addText(inputX + 200, inputY + (lineMultiplier * i), parser.getDimensionName(parser.getServerId(os.getComputerID()), data[i].dimId), colors.white).setScale(size.small))
	end
	
	for i = 1, #entitiesArray do
		entitiesArray[i].setZIndex(5)
	end
end

local function drawChunks(inputX, inputY)
	local data = parser.getChunks()
	chunksArray = {}
	
	table.insert(chunksArray, bridge.addText(inputX, inputY, "Chunk Position (X, Z):", colors.white).setScale(size.small))
	table.insert(chunksArray, bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small))
	table.insert(chunksArray, bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small))
	
	for i = 1, limit do
		table.insert(chunksArray, bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].positionX .. ", " .. data[i].positionZ, colors.white).setScale(size.small))
		table.insert(chunksArray, bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small))
		table.insert(chunksArray, bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small))
	end
	
	for i = 1, #chunksArray do
		chunksArray[i].setZIndex(5)
	end
end

local function drawTypes(inputX, inputY)
	local data = parser.getEntityByTypes()
	typesArray = {}
	
	table.insert(typesArray, bridge.addText(inputX, inputY, "Entity Type:", colors.white).setScale(size.small))
	table.insert(typesArray, bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small))
	table.insert(typesArray, bridge.addText(inputX + 150, inputY, "%", colors.white).setScale(size.small))
	
	for i = 1, limit do
		table.insert(typesArray, bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].type, colors.white).setScale(size.small))
		table.insert(typesArray, bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small))
		table.insert(typesArray, bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].percent, parser.getPercentHexColor(data[i].percent)).setScale(size.small))
	end
	
	for i = 1, #typesArray do
		typesArray[i].setZIndex(5)
	end
end

local function drawCalls(inputX, inputY)
	local data = parser.getAverageCalls()
	callsArray = {}
	
	table.insert(callsArray, bridge.addText(inputX, inputY, "Entity Name:", colors.white).setScale(size.small))
	table.insert(callsArray, bridge.addText(inputX + 100, inputY, "Time/Tick:", colors.white).setScale(size.small))
	table.insert(callsArray, bridge.addText(inputX + 150, inputY, "Average Calls", colors.white).setScale(size.small))
	
	for i = 1, limit do
		table.insert(callsArray, bridge.addText(inputX, inputY + (lineMultiplier * i), data[i].name, colors.white).setScale(size.small))
		table.insert(callsArray, bridge.addText(inputX + 100, inputY + (lineMultiplier * i), data[i].time, colors.white).setScale(size.small))
		table.insert(callsArray, bridge.addText(inputX + 150, inputY + (lineMultiplier * i), data[i].calls, colors.white).setScale(size.small))
	end
	
	for i = 1, #callsArray do
		callsArray[i].setZIndex(5)
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
		value.setZIndex(6)
	end
end

local function drawData()
	drawEntities(mainX + 5, mainY + headerHeight + 5)
	drawChunks(mainX + 5, mainY + headerHeight + 5 + ((limit + 2) * lineMultiplier))
	drawTypes(mainX + 5, mainY + headerHeight + 5 + ((limit + 2) * 2 * lineMultiplier))
	drawCalls(mainX + 5, mainY + headerHeight + 5 + ((limit + 2) * 3 * lineMultiplier))
end

local dataRefreshLoop = function()
	lastUpdated = 0
	while true do
		if (fs.getSize(jsonFile) ~= currentFileSize) then
			functions.debug("File size of profile.txt has changed. Assuming new data.")
			local file = fs.open(jsonFile, "r")
			local text = file.readAll()
			file.close()
			
			-- reset the updated time and the new file size
			currentFileSize = fs.getSize(jsonFile)
			functions.debug("Setting the current file size to: ", currentFileSize)
			lastUpdated = 0
			
			-- re-parse the data
			parser.parseData(text)
			bridge.clear()
			
			-- redraw the new data
			drawMain(mainX, mainY, mainWidth, mainHeight)
			drawHeader(mainX, mainY)
			drawTps(mainX, mainY)
			drawSanta(mainX + 10, mainY - 1)
			drawData()
		else
			lastUpdatedText.setText(lastUpdated .. "s")
		end
		
		lastUpdated = lastUpdated + 1
		sleep(1)
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
	
	currentFileSize = fs.getSize(jsonFile)
	functions.debug("Setting the current file size to: ", currentFileSize)
	
	functions.debug("Beginning initial data parsing.")
	parser.parseData(text)
	functions.debug("Data parsing complete.")
	
	drawMain(mainX, mainY, mainWidth, mainHeight)
	drawHeader(mainX, mainY)
	drawTps(mainX, mainY)
	drawSanta(mainX + 10, mainY - 1)
	drawData()
	
	parallel.waitForAll(dataRefreshLoop, clockRefreshLoop)
end

init()
