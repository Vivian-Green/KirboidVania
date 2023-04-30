extends Button

export(int) var slot

func on_button_down():
	DataHandler.saveSlot = slot
	get_tree().change_scene("res://Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("button_down", self, "on_button_down")
