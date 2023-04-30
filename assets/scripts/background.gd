extends ParallaxBackground

const sevenTwentyP = Vector2(1280, 720)
const baseResolution = Vector2(640, 250)
const baseOffset = 50

var currentResolution = 0



func getOffset(resolution):
	return Vector2(0, -resolution/2 + (baseOffset*(resolution/720)))

func _process(_delta):
	if DataHandler.settingsDict["resolution"].y != currentResolution:
		currentResolution = DataHandler.settingsDict["resolution"].y
		offset = getOffset(currentResolution)
		scale = (sevenTwentyP / baseResolution)
