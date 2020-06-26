extends Control

onready var def = get_node("/root/Definitions")

export (String) var item
export (int) var amount

func _ready():
	var itemID = def.ITEM_NAMES.find(self.item)
	if itemID == -1: return
	
	var itemScene = def.ITEM_SCENES[itemID]
	var item = itemScene.instance()
	
	add_child(item)
