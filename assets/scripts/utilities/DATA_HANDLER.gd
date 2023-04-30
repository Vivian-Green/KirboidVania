#reference from anywhere, since this is an autoload: print(DataHandler.playTime)
extends Node2D

export(Script) var saveSettingsClass
export(Font) var overrideFont

var runTests = true
var saveSlot = 0
var playTime = 0
var inventory = {}
var fontOverride = false


var defaultSettings = {
	"resolution": Vector2(1920, 1080),
	"vsync": true,
	"fullscreen": true,
	"fontOverride": false
}
var settingsDict = defaultSettings
var settingsDir = "user://settings/"

var debugValue = 0
var timeSinceLastUpdate = 0

func makeDirsIfTheyAreKil(directory):
	#returns whether array existed already, makes it if it doesn't
	var dir = Directory.new()
	if not dir.dir_exists(directory):
		dir.make_dir_recursive(directory)
		return false
	return true

func updatePlaytime(delta):
	timeSinceLastUpdate += delta
	if timeSinceLastUpdate > 1:
		timeSinceLastUpdate -= 1
		playTime += 1

func getDescendants(parent):
	var descendents = [parent]
	for child in parent.get_children():
		var grandchildren = getDescendants(child)
		for grandchild in grandchildren:
			descendents.append(grandchild)
	return descendents

func setFontsIfNeeded():
	if settingsDict["fontOverride"] == true:
		for child in getDescendants(get_tree().get_root()):
			if child.get("text"):
				child.set("custom_fonts/font", overrideFont)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~settings~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func loadSettingsFromFile():
	print("loading settings")
	if not makeDirsIfTheyAreKil(settingsDir):
		return false
	
	#debug: fix next check to not need this
	#loadSettings(defaultSettings)
	
	var newSettingsDict = load(settingsDir+"settings.tres").settingsDict
	if newSettingsDict == null:
		loadSettings(defaultSettings)
		return false
	
	#loadSettings(newSettingsDict)
	return true

func loadSettings(newSettingsDict):
	for k in newSettingsDict:
		#set settingsDict to newSettingsDict, BUT if new settings exist in default that aren't in 
		#the one from the saves, keep the new default value
		settingsDict[k] = newSettingsDict[k]
	
	#set fullscreen
	OS.window_fullscreen = settingsDict["fullscreen"]
	#set resolution
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, settingsDict["resolution"])
	#set vsync
	OS.vsync_enabled = settingsDict["vsync"]
	
func saveSettings():
	print("saving settings")
	var newSave = saveSettingsClass.new()
	newSave.settingsDict = settingsDict
	
	makeDirsIfTheyAreKil(settingsDir)
	ResourceSaver.save(settingsDir+"settings.tres", newSave)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~saves~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func loadSave(saveDict):
	#ACTUALLY USED BY saveHandler, DO NOT REMOVE
	playTime = saveDict.playTime
	inventory = saveDict.inventory

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func _process(delta):
	updatePlaytime(delta)

func _ready():
	loadSettingsFromFile()
	setFontsIfNeeded()
