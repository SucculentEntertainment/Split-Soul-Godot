<<<<<<< Updated upstream
extends Control

signal finished

onready var def = get_node("/root/Definitions")

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
	
	$Content/Buttons/Done.connect("button_down", self, "toggle")
	def.CONFIG.load("user://settings.cfg")
	
	file.open("res://Data/settingsEntries.json", file.READ)
	guiData = parse_json(file.get_as_text())
	
	var i = 0
	
	for c in guiData:
		var categoryName = c[0]
		c.remove(0)
		
		for d in c:
			var e = types[d.type].instance()
			categories[i].add_child(e)
			
			if d.type != "seperator":
				if not def.CONFIG.has_section_key(categoryName, d.key):
					def.CONFIG.set_value(categoryName, d.key, d.default)
			
			match d.type:
				"menu":
					e.init(categoryName, d.text, d.entries, d.key)
				"seperator":
					e.init(d.text)
				"slider":
					e.init(categoryName, d.text, d.minVal, d.maxVal, d.step, d.key)
				"toggle":
					e.init(categoryName, d.text, d.key)
		
		i += 1
=======
extends Node
var config = ConfigFile.new()

func toggle():
	if visible:
		hide()
		mouse_filter = MOUSE_FILTER_IGNORE
		
		def.emit_signal("settingsUpdateStop")
		def.CONFIG.save("user://settings.cfg")
		
		emit_signal("finished")
		yield(get_tree().create_timer(0.1), "timeout")
	else:
		show()
		mouse_filter = MOUSE_FILTER_STOP
		
		def.emit_signal("settingsUpdateStart")
