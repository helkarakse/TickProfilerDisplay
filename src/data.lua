--[[

	Data File for Common Configurations
	Do not modify, copy or distribute without permission of author
	Helkarakse 20131218

]]

local server = string.sub(os.getComputerLabel(), 1, 1)
local pack = string.lower(string.sub(os.getComputerLabel(), 2))
dataUrl = "http://dev.otegamers.com/api/v1/tps/get/" .. $pack .. "/" .. $server