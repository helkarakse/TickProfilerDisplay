-- Lite free version of the Megaton Glasses
-- Only displaying clock and tps

g = peripheral.wrap("top") 
g.clear()
 
--set values for colors
headerstart =  0x18caf0
headerend = 0x9fedfd
white = 0xffffff
 
-- main layout
mainbox = g.addBox(10, 75, 100, 50, headerend, 0.3)
header = g.addGradientBox(5, 75, 75, 11, headerend, 0, headerstart, 1, 2)
edgebox = g.addGradientBox(10, 123, 100, 2, headerstart, 1, headerend, 0, 2)
header.setZIndex(2)
 
-- main text
headertext = g.addText(7, 77, "Megaton OS    LITE", white)
headertext.setZIndex(3)
local file = fs.open("profile.txt", "r") -- opens the file
tps = file.readLine(1) -- reads the line
file.close() -- closes the file
tpstext = g.addText(65, 114, tps, white)
clocktext = g.addText(20, 95, "clock", white)
clocktext.setScale(2)
 
--refreshing
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