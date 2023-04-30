extends Control

onready var windowPreloads = {
	"saveSelect": preload("res://scenes/menus/saveSelect.tscn"),
	"credits": preload("res://scenes/menus/credits.tscn"),
	"settings": preload("res://scenes/menus/settings.tscn")
}

func createWindow(windowName):
	if not get_node_or_null(windowName):
		add_child(windowPreloads[windowName].instance())

func _on_quit_button_down():
	get_tree().quit()
