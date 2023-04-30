extends Button

onready var menu = get_parent().get_parent()

func _on_close():
	menu.queue_free()
