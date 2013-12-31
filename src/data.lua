--[[

	Data File for Common Configurations
	Do not modify, copy or distribute without permission of author
	Helkarakse 20131218

]]

dimId = string.sub(os.getComputerLabel(), 1, 1)
server = string.lower(string.sub(os.getComputerLabel(), 2))

dataUrl = "http://dev.otegamers.com/index.php?c=upload&m=get&server=" .. server .. "&type=" .. dimId