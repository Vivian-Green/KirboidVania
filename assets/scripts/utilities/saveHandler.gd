extends Node2D
# warning-ignore:unused_argument

var saveVars = ["playTime", "inventory", "fontOverride"]
var defaultInventory = {"shoes": false}

var savesDir = "user://saves/"

export(Script) var saveGameClass

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~verify & load~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func verifyInventory(inventory):
	if typeof(inventory) != typeof(Dictionary()):
		return false
		
	for k in defaultInventory:
		#check all keys, if one doesn't exist, inventory was corrupted
		#todo: tell the user that, lol
		if not inventory.has(k):
			return false
	return true

func verifySave(worldSave):
	for v in saveVars:
		if worldSave.get(v) == null:
			return false
	
	if not verifyInventory(worldSave.inventory):
		return false
	
	return true

func loadGame(slot):
	print("loading")
	if not DataHandler.makeDirsIfTheyAreKil(savesDir):
		return false
	
	var worldSave = load(savesDir+"save_"+str(slot)+".tres")
	if worldSave == null: 
		return false
	if not verifySave(worldSave):
		return false
	
	DataHandler.loadSave(worldSave)
	return true

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~save~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func newEmptySave(slot):
	print("saving")
	var newSave = saveGameClass.new()
	
	DataHandler.playTime = 0
	newSave.playTime = DataHandler.playTime
	
	DataHandler.inventory = defaultInventory
	newSave.inventory = DataHandler.inventory
	
	DataHandler.makeDirsIfTheyAreKil(savesDir)
	ResourceSaver.save(savesDir+"save_"+str(slot)+".tres", newSave)

func saveGame(slot):
	#print("saving")
	var newSave = saveGameClass.new()
	newSave.playTime = DataHandler.playTime
	newSave.inventory = DataHandler.inventory
	newSave.fontOverride = DataHandler.fontOverride
	#print(DataHandler.inventory)
	
	DataHandler.makeDirsIfTheyAreKil(savesDir)
	ResourceSaver.save(savesDir+"save_"+str(slot)+".tres", newSave)
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func _ready():
	print("save slot: "+str(DataHandler.saveSlot))
	
	#attempt to load save, if not, make a new one
	if not loadGame(DataHandler.saveSlot):
		print("save not found, riperino")
		#todo: at least warn the player before overwriting things, lol.
		newEmptySave(DataHandler.saveSlot)
