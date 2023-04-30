extends Node2D

onready var fpsLabel = get_node("fps")
onready var frameTimeLabel = get_node("frameTime")
onready var playTimeLabel = get_node("playTime")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var frameTime = round(delta*1000000)/1000
	var fps = round(1/delta)
	
	frameTimeLabel.text = "Frame time: "+str(frameTime)
	fpsLabel.text = "FPS: "+str(fps)
	playTimeLabel.text = "Play time: "+str(DataHandler.playTime)
