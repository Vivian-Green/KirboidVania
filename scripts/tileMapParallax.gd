extends Node2D
onready var game = get_parent() 
onready var player = game.get_node("player")

var foregroundParallaxAmount = -0.1

func _process(_delta):
	$foreground.position.x = player.position.x * foregroundParallaxAmount
