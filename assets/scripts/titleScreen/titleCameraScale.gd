extends Camera2D
const sevenTwentyP = Vector2(1280, 720)

func _process(_delta):
	zoom = sevenTwentyP/DataHandler.settingsDict["resolution"]
