extends Control

var newGraphNode = load("res://scenes/GraphNode-Room.tscn")
var myPos = Vector2(40, 40)
var addPos = Vector2(20, 20)

func _ready():
	$GraphEdit.set_right_disconnects(true)

func _on_add_node_button_down():
	var node = newGraphNode.instance()
	myPos += addPos
	node.offset = myPos
	$GraphEdit.add_child(node)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	$GraphEdit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	$GraphEdit.disconnect_node(from, from_slot, to, to_slot)


func _on_Run_button_down():
	var G = $GraphEdit
	var connection_list = G.get_connection_list()
	var result = ""
	
	for i in range(0, connection_list.size()):
		var value = G.get_node(connection_list[i].from).get_node("textEdit").text
		var value2 = G.get_node(connection_list[i].to).get_node("textEdit").text
		result = result+""+value
		if i+1 == connection_list.size():
			result = result+""+value2
	print(result)
	
	getRoomAndDoorFromRoomAndDoor("balls", "R")

func getRoomAndDoorFromRoomAndDoor(room, door):
	var G = $GraphEdit
	var connection_list = G.get_connection_list()
	
	var thisNode = null
	print(connection_list)
	for i in range (0, connection_list.size()):
		var myName = G.get_node(connection_list[i].from).get_node("textEdit").text
		var myName2 = G.get_node(connection_list[i].to).get_node("textEdit").text
		if myName2 == room and door == "L":
			thisNode = G.get_node(connection_list[i].from)
		elif myName == room and door == "R":
			thisNode = G.get_node(connection_list[i].to)
				
	print(thisNode.get_node("textEdit").text, "L" if door == "R" else "R")
 
