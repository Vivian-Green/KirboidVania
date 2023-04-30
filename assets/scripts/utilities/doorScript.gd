extends Area2D
var connected

export(String) var scenePath
var joiner = "-"
export(String) var doorLabel

onready var mySceneToLoad = load(scenePath)

var timeSinceStart= 0
var doorDelay = 2
var enabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func activateDoor():
	self.connect("body_entered", self, "_on_Body_Entered")

func importAndOffset(scene, door):
	if not connected:
		var myOffset = Vector2(0, 0)
		var newScene = scene.instance()
		var newDoorPos = newScene.get_node("door-"+door).get_global_position()
		
		get_parent().get_parent().call_deferred("add_child", newScene)
		
		myOffset = newDoorPos - self.get_global_position()
		
		print(newScene.position)
		
		newScene.position = newScene.position - myOffset
		
		connected = true
		newScene.get_node("door-"+door).connected = true

func _on_Body_Entered(body):
	if body.name == "player":
		importAndOffset(mySceneToLoad, doorLabel)

func _physics_process(delta):
	timeSinceStart += delta
	if not enabled and timeSinceStart > doorDelay:
		enabled = true
		activateDoor()
