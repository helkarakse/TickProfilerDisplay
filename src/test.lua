--[[

	TickProfiler Test Cases Version 1.0 Alpha
	Do not modify, copy or distribute without permission of author
	Helkarakse, 20131128

]]

os.loadAPI("parser")

local function main()
	local file = fs.open("data", "r")
	local text = file.readAll()
	file.close()
	
	write("Option: ")
	local option = tonumber(read())
	parser.parseData(text)
	
	if (option == 1) then
		-- tps
		print(parser.getExactTps())
		print(parser.getTps())
	elseif (option == 2) then
		-- single entities
		local singleEntities = parser.getSingleEntities()
		print(singleEntities[1].percent)
		print(singleEntities[1].name)
		print(singleEntities[1].time)
		print(singleEntities[1].position)
		print(singleEntities[1].dimension)
	elseif (option == 3) then
		-- chunks
		local chunks = parser.getChunks()
		print(chunks[1].percent)
		print(chunks[1].time)
		print(chunks[1].positionX)
		print(chunks[1].positionZ)
	elseif (option == 4) then
		-- types
		local types = parser.getEntityByTypes()
		print(types[1].percent)
		print(types[1].time)
		print(types[1].type)
	elseif (option == 5) then
		-- calls
		local calls = parser.getAverageCalls()
		print(calls[1].time)
		print(calls[1].name)
		print(calls[1].calls)
	end
end

main()