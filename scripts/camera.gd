extends Camera2D

const sevenTwentyP = Vector2(1280, 720)
const zoomMultiplier = Vector2(1, 1)
const cameraOffset = Vector2(0, -50)
onready var player = get_parent().get_node("player")

var cameraSpeed = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	zoom = zoomMultiplier * sevenTwentyP/DataHandler.settingsDict["resolution"]
	var distanceTaxicab = position - (player.position + cameraOffset)
	distanceTaxicab = abs(distanceTaxicab.x)+abs(distanceTaxicab.y)
	
	position = lerp(position, player.position + cameraOffset, 1)#.1)
