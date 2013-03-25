switchApp("iPhone Simulator") #NOTE: not iOS Simulator
menuTop = find("i0SSimulator.png") #NOTE: use shortcut: cmd + shift + 2 to take a screen shot
menuTop.right().click("Hardware.png")
for i in range(6):
    type(Key.DOWN)
type(Key.ENTER)
click("1364198142202.png")

#assert not exists("W01mP1mss.png")

assert exists("W01mP1mss.png")
click("3.png")
assert exists("About.png")
click("Close.png")
assert exists("W01mP1mss.png")
    
