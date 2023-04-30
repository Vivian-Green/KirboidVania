extends Node2D
onready var player = get_parent().get_parent()
onready var feet = player.get_node("cosmeticsLocations").get_node("feet")

func _ready():
	position = feet.position
	player.canJump = true
