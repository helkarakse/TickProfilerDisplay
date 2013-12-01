--[[
 
    MacroStartup Version 1.0 Beta
    Do not modify, copy or distribute without permission of author
	Helkarakse, 20130614
 
]]--
 
local file = "main"
local api = {"functions", "json"}
local debug = true
 
-- get code from remote server
local function getProgram(link, filename)
        print("Downloading '" .. filename .. "' file from server.")
        local data = http.get(link)
        if data then
                print("File '" .. filename .. "' download complete.")
                local file = fs.open(filename,"w")
                file.write(data.readAll())
                file.close()
        end
end
 
-- download and start program
for key, value in pairs(api) do
        local link = "http://nimcuron.twilightparadox.com:8113/lua/lua.php?u=lua&p=codelua&pkg=api&f=" .. value
        getProgram(link, value)
end
 
local link = "http://nimcuron.twilightparadox.com:8113/lua/lua.php?u=lua&p=codelua&pkg=storage&f=" .. file
if (debug == true) then
        getProgram(link, file)
end
 
if fs.exists(file) then
        print("Starting primary process...")
        shell.run(file)
else
        getProgram(link, file)
        print("Starting primary process...")
        shell.run(file)
end

