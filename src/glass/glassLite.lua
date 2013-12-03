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

local args = {...}

local colors = {
	headerStart = 0x18caf0, headerEnd = 0x9fedfd, white = 0xffffff, red = 0xFF0000
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
	headerText.setScale(0.5)
end

local function drawTps()
	local tps = parser.getTps()
--	tpsTextText = bridge.addText(44, 114, "TPS: ", colors.white)
	tpsText = bridge.addText(65, 114, "TPS: " .. tps, colors.white)
	tpsText.setScale(0.5)
	clockText = bridge.addText(20, 75, "clock", colors.white)
	clockText.setScale(1)
end

local function drawEntities(inputX, inputY)
	local data = parser.getSingleEntities()
	bridge.addText(inputX, inputY, "Entity Name:", colors.white).setScale(0.5)
	bridge.addText(inputX + 50, inputY, "Position:", colors.white).setScale(0.5)
	bridge.addText(inputX + 75, inputY, "%", colors.white).setScale(0.5)
	bridge.addText(inputX + 100, inputY, "Dimension:", colors.white).setScale(0.5)
end

local function drawChunks()

end

local function drawTypes()

end

local function drawCalls()

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

--local tpsRefreshLoop = function()
--	while true do
--		local file = fs.open(jsonFile, "r")
--		local text = file.readAll()
--		file.close()
--		
--		parser.parseData(text)
--		tpsText.setText(parser.getTps())
--		sleep(15)
--	end
--end
--
--local clockRefreshLoop = function()
--	while true do
--		local nTime = os.time()
--		clockText.setText(textutils.formatTime(nTime, false))
--		sleep(1)
--	end
--end

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
	
	drawMain(10, 65, 500, 230)
	drawHeader(10, 65)
--	drawTps()
--	drawSanta(105,120)
	drawEntities(15, 75)
	
--	parallel.waitForAll(tpsRefreshLoop, clockRefreshLoop)
end

init()
