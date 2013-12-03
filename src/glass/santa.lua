bridge = peripheral.wrap("top")
bridge.clear()

--colors
white = 0xffffff
red = 0xFF0000

--initial starting position
x = 100
y = 100

--white parts
box1 = bridge.addBox(x-2, y-11, 2, 2, white, 1)
box2 = bridge.addBox(x-9, y-1, 9, 2, white, 1)

--red parts
box3 = bridge.addBox(x-2, y-8, 2, 1, red, 1)
box4 = bridge.addBox(x-3, y-7, 4, 1, red, 1)
box5 = bridge.addBox(x-4, y-6, 5, 1, red, 1)
box6 = bridge.addBox(x-5, y-5, 5, 1, red, 1)
box7 = bridge.addBox(x-6, y-4, 5, 1, red, 1)
box8 = bridge.addBox(x-7, y-3, 6, 1, red, 1)
box9 = bridge.addBox(x-8, y-2, 8, 1, red, 1)