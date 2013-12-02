-- Official Megaton Glass program
-- This program extends from the lite version with more functionality
-- Without permission of the author you are not allowed to use or copy this code
-- @author Shotexpert c 2013
 
-- declarations
g = peripheral.wrap("top") -- wrap the glassbox
g.clear() -- clears the screen on first start
 
-- menu values that show what menu ur in
-- 0 = hidden
-- 1 = main
-- 2 = min
-- 3 = hub
-- 4 = tps
menu = 0
 
--set values for colors
headerstart =  0x18caf0
headerend = 0x9fedfd
white = 0xffffff
 
function startupmain() -- startup animation main screen
mainbox = g.addBox(10, 75, 100, 50, headerend, 0.3)
header = g.addGradientBox(5, 75, 75, 10, headerend, 0, headerstart, 1, 2)
 
mainbox.setZIndex(1)
header.setZIndex(2)
        for i = 0, 25 do
                mainbox.setWidth(i*4)
                mainbox.setHeight(i*2)
                header.setWidth(i*3)
                header.setHeight(i*0.4)
                sleep(0.05)
        end
edgebox = g.addGradientBox(10, 123, 100, 2, headerstart, 1, headerend, 0, 2)
edgebox.setZIndex(4)
        for i = 0, 25 do
                edgebox.setWidth(i*4)
                sleep(0.05)
        end
headertext = g.addText(7, 77, "Megaton OS    BETA", white)
tpstext = g.addText(65, 114, "tps", white)
clocktext = g.addText(20, 95, "clock", white)
headertext.setZIndex(3)
clocktext.setScale(2)
tpstext.setZIndex(5)
clocktext.setZIndex(6)
menu = 1
end
 
function startupmin() -- startup animation for the minimalized screen
edgebox.delete()
tpstext.delete()
clocktext.delete()
        for i = 25, 0, -1 do
                mainbox.setHeight(i*2)
                mainbox.setWidth(i*4)
                sleep(0.05)
        end
mainbox.delete()
menu = 2
end
 
function startuptps() -- startup animation for the tps screen
edgebox.delete()
tpstext.delete()
clocktext.delete()
        for i = 25, 50 do
                mainbox.setWidth(i*4)
                mainbox.setHeight(i*2)
                sleep(0.05)
        end
edgebox = g.addGradientBox(10, 173, 100, 2, headerstart, 1, headerend, 0, 2)
edgebox.setZIndex(4)
        for i = 0, 25 do
                edgebox.setWidth(i*8)
                sleep(0.05)
        end
menu = 4
end
 
function shutdowntps() -- shutdown animation for the tps screen
edgebox.delete()
        for i = 1, 32 do
                i.delete()
                sleep(0.05)
        end
        for i = 50, 25, -1 do
                mainbox.setWidth(i*4)
                mainbox.setHeight(i*2)
                sleep(0.05)
        end
edgebox = g.addGradientBox(10, 123, 100, 2, headerstart, 1, headerend, 0, 2)
edgebox.setZIndex(4)
        for i = 0, 25 do
                edgebox.setWidth(i*4)
                sleep(0.05)
        end
tpstext = g.addText(65, 114, "tps", white)
clocktext = g.addText(20, 95, "clock", white)
clocktext.setScale(2)
tpstext.setZIndex(5)
clocktext.setZIndex(6)
menu = 1
end
 
function shutdownmin() -- shutdown animation for the minimalized screen
mainbox = g.addBox(10, 75, 100, 50, headerend, 0.3)
mainbox.setZIndex(1)
        for i = 0, 25 do
                mainbox.setHeight(i*2)
                mainbox.setWidth(i*4)
                sleep(0.05)
        end
edgebox = g.addGradientBox(10, 123, 100, 2, headerstart, 1, headerend, 0, 2)
edgebox.setZIndex(4)
        for i = 0, 25 do
                edgebox.setWidth(i*4)
                sleep(0.05)
        end
tpstext = g.addText(65, 114, "tps", white)
clocktext = g.addText(20, 95, "clock", white)
headertext.setZIndex(3)
clocktext.setScale(2)
tpstext.setZIndex(5)
clocktext.setZIndex(6)
menu = 1
end    
 
function shutdownmain() -- shutdown animaton main screen
headertext.delete()
tpstext.delete()
clocktext.delete()
edgebox.delete()
        for i = 25, 0, -1 do
                mainbox.setWidth(i*4)
                mainbox.setHeight(i*2)
                header.setWidth(i*3)
                header.setHeight(i*0.4)
                sleep(0.05)
        end
mainbox.delete()
header.delete()
menu = 0
end
 
function event0() -- holds events for when the screen is hidden
local event, msg = os.pullEvent()
        if event == "chat_command" then        
                if msg == "back" or msg == "b" then            
                        print("back")
                        startupmain()
                elseif msg == "max" then
                        print("max")
                        startupmain()
                else
                        print("message not recognized")
                end
        end
end
 
function event1() -- holds events for the main screen
local event, msg = os.pullEvent()
        if event == "chat_command" then        
                if msg == "back" or msg == "b" then            
                        print("back")
                        shutdownmain()
                elseif msg == "min" then
                        print("min")
                        startupmin()
                elseif msg == "tps" then
                        print("tps")
                        startuptps()
                else
                        print("message not recognized")
                end
        end
end
 
function event2() -- holds events for the min screen
local event, msg = os.pullEvent()
        if event == "chat_command" then        
                if msg == "back" or msg == "b" then            
                        print("back")
                        shutdownmin()
                elseif msg == "max" then
                        print("max")
                        startupmain()
                else
                        print("message not recognized")
                end
        end
end
 
function event3() -- holds events for the hub screen
end
 
function event4() -- holds events for the tps screen
local event, msg = os.pullEvent()
        if event == "chat_command" then        
                if msg == "back" or msg == "b" then            
                        print("back")
                        shutdowntps()
                else
                        print("message not recognized")
                end
        end
end
 
function refresh1() -- holds the refreshes for the main screen
while true do
        local nTime = os.time()
        clocktext.setText(textutils.formatTime(nTime,false))
       
        local file = fs.open("profile.txt", "r") -- opens the file
        tps = file.readLine(1) -- reads the line
        file.close() -- closes the file
        result = string.sub(tps, 1, 9 )
        tpstext.setText(result)
        sleep(1)
end
end
 
function refresh4() -- holds the refreshes for the tps screen
while true do
        local file = fs.open("profile.txt", "r") -- opens the file
        for i = 1,32 do
                tpsadvancedtext = g.addText(14, i*9+80, "tps", white)
                ln = file.readLine(i) -- reads the line
                tpsadvancedtext.setText(ln)
        end
        file.close() -- closes the file
        sleep(30)
        for i = 1, 32 do
                tpsadvancedtext.delete()
                sleep(0.05)
        end
end
end
 
function checkscreen() -- function to check on what screen the user is
while true do
        if menu == 0 then -- hidden
                event0()
        elseif menu == 1 then -- on main screen
                parallel.waitForAny(event1, refresh1)
        elseif menu == 2 then -- on min screen
                event2()
        elseif menu == 3 then -- on hub screen
                event3()
        elseif menu == 4 then -- on tps screen
                parallel.waitForAny(event4, refresh4)
        end
end
end
 
-- program start
startupmain()
checkscreen()