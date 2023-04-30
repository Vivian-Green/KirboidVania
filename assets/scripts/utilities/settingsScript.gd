extends Control

var resolutionsArray = [2160.0, 1440.0, 1080.0, 900.0, 720.0]
var aspectRatiosArray = [16.0/9.0, 16.0/10.0, 4.0/3.0, 21.0/9.0, 32.0/9.0]

onready var settingsControlNode = get_node("ColorRect").get_node("settings")

onready var graphicsOptions = settingsControlNode.get_node("graphicsSection").get_node("graphicsOptions")

onready var resolutionSection = graphicsOptions.get_node("resolution").get_node("control")
onready var screenHeightDropdown = resolutionSection.get_node("screenHeight").get_node("screenHeightDropdown")
onready var aspectRatioDropdown = resolutionSection.get_node("aspectRatio").get_node("aspectRatioDropdown")

onready var fullScreenDropdown = graphicsOptions.get_node("fullscreen").get_node("fullScreenDropdown")
onready var vsyncDropdown = graphicsOptions.get_node("vsync").get_node("vsyncDropdown")


onready var accessibilitySection = settingsControlNode.get_node("accessibilitySection")
onready var fontOverrideDropdown = accessibilitySection.get_node("fontOverride").get_node("fontOverrideDropdown")



func getDescendants(parent):
	var descendents = [parent]
	for child in parent.get_children():
		var grandchildren = getDescendants(child)
		for grandchild in grandchildren:
			descendents.append(grandchild)
	return descendents

func _ready():
	#set values to actual values
	fullScreenDropdown.selected = 1 if DataHandler.settingsDict["fullscreen"] 	else 0
	vsyncDropdown.selected = 1		if DataHandler.settingsDict["vsync"]		else 0
	
	screenHeightDropdown.selected = resolutionsArray.find(DataHandler.settingsDict["resolution"].y)
	aspectRatioDropdown.selected = aspectRatiosArray.find(DataHandler.settingsDict["resolution"].x/DataHandler.settingsDict["resolution"].y)
	
	fontOverrideDropdown.selected = 1 if DataHandler.settingsDict["fontOverride"] else 0
	
	if DataHandler.settingsDict["fontOverride"] == true:
		var font = DataHandler.overrideFont

		print("balls")
		for child in getDescendants(get_tree().get_root()):
			if child.get("text"):
				child.set("custom_fonts/font", font)
				print("Changing Font")


func handleScreenSizeChange(_index):
	var screenHeight = resolutionsArray[screenHeightDropdown.selected]
	var aspectRatio = aspectRatiosArray[aspectRatioDropdown.selected]
	
	DataHandler.settingsDict["resolution"] = Vector2(screenHeight*aspectRatio, screenHeight)
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, DataHandler.settingsDict["resolution"])
	DataHandler.saveSettings()
	
func _on_fullScreenDropdown_item_selected(index):
	DataHandler.settingsDict["fullscreen"] = index == 1
	OS.window_fullscreen = DataHandler.settingsDict["fullscreen"]
	DataHandler.saveSettings()

func _on_vsync_Dropdown_item_selected(index):
	DataHandler.settingsDict["vsync"] = index == 1
	OS.vsync_enabled = DataHandler.settingsDict["vsync"]
	DataHandler.saveSettings()


func _on_fontOverrideDropdown_item_selected(index):
	DataHandler.settingsDict["fontOverride"] = index == 1
	DataHandler.saveSettings()
