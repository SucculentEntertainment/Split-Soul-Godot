extends Control

onready var def = get_node("/root/Definitions")

var category = ""
var key = ""
var entries = []

func _ready():
	$HBoxContainer/OptionButton.connect("item_selected", self, "_onItemSelect")

func init(categoryName, text, entries, key):
	$HBoxContainer/Label.text = text
	
	self.entries = entries
	self.category = categoryName
	self.key = key
	
	for e in entries:
		$HBoxContainer/OptionButton.add_item(e)
	
	$HBoxContainer/OptionButton.select(entries.find(def.CONFIG.get_value(category, key)))

func _onItemSelect(i):
	def.CONFIG.set_value(category, key, entries[i])
