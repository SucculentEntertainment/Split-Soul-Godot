extends Control

var types = {
	"menu": load("res://Scenes/GUI/UI Elements/SettingsOptionMenu.tscn"),
	"seperator": load("res://Scenes/GUI/UI Elements/SettingsOptionSeperator.tscn"),
	"slider": load("res://Scenes/GUI/UI Elements/SettingsOptionSlider.tscn"),
	"toggle": load("res://Scenes/GUI/UI Elements/SettingsOptionToggle.tscn"),
}

onready var categories = [
	$Content/Tabs/Game/Elements,
	$Content/Tabs/Video/Elements,
	$Content/Tabs/Audio/Elements,
	$Content/Tabs/Controls/Elements
]

func _ready():
	var file = File.new()
	var guiData = []
	
	file.open("res://Data/settingsEntries.json", file.READ)
	guiData = parse_json(file.get_as_text())
	
	var i = 0
	
	for c in guiData:
		for d in c:
			var e = types[d.type].instance()
			categories[i].add_child(e)
			
			match d.type:
				"menu":
					e.init(d.text, d.entries)
				
				"seperator":
					e.init(d.text)
				
				"slider":
					e.init(d.text, d.minVal, d.maxVal, d.step)
				
				"toggle":
					e.init(d.text)
		
		i += 1
