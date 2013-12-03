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
local colors = {
	headerStart = 0x18caf0, headerEnd = 0x9fedfd, white = 0xffffff, red = 0xFF0000
}

-- Functions
local function drawMain()
	mainBox = bridge.addBox(10, 75, 100, 50, colors.headerEnd, 0.3)
	header = bridge.addGradientBox(5, 75, 75, 11, colors.headerEnd, 0, colors.headerStart, 1, 2)
	edgeBox = bridge.addGradientBox(10, 123, 100, 2, colors.headerStart, 1, colors.headerEnd, 0, 2)
	header.setZIndex(2)
end

local function drawHeader()
	headerText = bridge.addText(7, 77, "OTE Glasses    LITE", colors.white)
	headerText.setZIndex(3)
end

local function drawTps()
	local tps = parser.getTps()
	tpsTextText = bridge.addText(44, 114, "TPS: ", colors.white)
	tpsText = bridge.addText(65, 114, tps, colors.white)
	clockText = bridge.addText(20, 95, "clock", colors.white)
	clockText.setScale(2)
end

local function drawSanta(inputX, inputY)
--white parts
box1 = bridge.addBox(inputX, inputY-9, 2, 2, colors.white, 1)
box2 = bridge.addBox(inputX-9, inputY-1, 9, 2, colors.white, 1)

--red parts
box3 = bridge.addBox(inputX-2, inputY-8, 2, 1, colors.red, 1)
box4 = bridge.addBox(inputX-3, inputY-7, 4, 1, colors.red, 1)
box5 = bridge.addBox(inputX-4, inputY-6, 5, 1, colors.red, 1)
box6 = bridge.addBox(inputX-5, inputY-5, 5, 1, colors.red, 1)
box7 = bridge.addBox(inputX-6, inputY-4, 5, 1, colors.red, 1)
box8 = bridge.addBox(inputX-7, inputY-3, 6, 1, colors.red, 1)
box9 = bridge.addBox(inputX-8, inputY-2, 8, 1, colors.red, 1)

--set zindexes
box1.setZIndex(4)
box2.setZIndex(4)
box3.setZIndex(4)
box4.setZIndex(4)
box5.setZIndex(4)
box6.setZIndex(4)
box7.setZIndex(4)
box8.setZIndex(4)
box9.setZIndex(4)
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
	
	drawMain()
	drawHeader()
	drawTps()
	drawSanta(105,120)
	
	parallel.waitForAll(tpsRefreshLoop, clockRefreshLoop)
end

init()