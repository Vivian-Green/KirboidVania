extends Node2D

export(bool) var isInventoryItem
export(String) var ID

func _ready():
	if isInventoryItem:
		while not DataHandler.inventory.has(ID):
			#wait until things are loaded before unloading yourself
			yield(get_tree().create_timer(0.1), "timeout")

		if DataHandler.inventory.get(ID):
			print("I already exist!")
			self.queue_free()
