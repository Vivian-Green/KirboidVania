extends Control
# warning-ignore:unused_argument

var dragPosition = null
var offset = Vector2(-100, -100)

func on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			dragPosition = get_global_mouse_position()-rect_global_position
			#start dragging
		else:
			dragPosition = null
	if event is InputEventMouseMotion and dragPosition:
		rect_global_position = get_global_mouse_position()-dragPosition

func _ready():
	self.connect("gui_input", self, "on_gui_input")
	rect_global_position = get_global_mouse_position() + offset
