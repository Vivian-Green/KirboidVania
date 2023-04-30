extends Node2D
onready var game = get_parent() 
onready var player = game.get_node("player")

export(Vector2) var doorPosL
export(Vector2) var doorPosR

export(NodePath) var sceneL
export(NodePath) var sceneR

var foregroundParallaxAmount = -0.1

func _process(_delta):
	$foreground.position.x = player.position.x * foregroundParallaxAmount

func _ready():
	doorPosL = get_node("door-L").get_world_position()
	doorPosR = get_node("door-R").get_world_position()
	
	get_node("door-L").scenePath = sceneL
	get_node("door-R").scenePath = sceneR
