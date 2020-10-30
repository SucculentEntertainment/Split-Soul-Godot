extends Control

onready var def = get_node("/root/Definitions")

var category = ""
var key = ""

func _ready():
	$HBoxContainer/Switch.connect("toggled", self, "_onToggle")

func init(categoryName, text, key):
	$HBoxContainer/Label.text = text
	
	category = categoryName
	self.key = key
	
	$HBoxContainer/Switch.pressed = def.CONFIG.get_value(category, key)

func _onToggle(state):
	def.CONFIG.set_value(category, key, state)
