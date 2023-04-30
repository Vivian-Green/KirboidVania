extends Line2D

onready var doorL1 = get_parent().get_node("door-L").get_global_position()
onready var doorR1 = get_parent().get_parent().get_node(get_parent().sceneL.name).get_node("door-R").get_global_position()
onready var doorR2 = get_parent().get_parent().get_node("door-R").get_global_position()
onready var doorL2 = get_parent().get_parent().get_node(get_parent().sceneR.name).get_node("door-L").get_global_position()
var isL = true

export(PoolVector2Array) var Points = [
	[0, 0], 
	[139, 0]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if isL:
		set_global_position(doorL1)
		Points[1] = doorR1-doorL1
	else:
		set_global_position(doorL2)
		Points[1] = doorR2-doorL2
