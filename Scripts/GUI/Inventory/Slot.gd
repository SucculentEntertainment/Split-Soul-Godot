extends Node2D

onready var def = get_node("/root/Definitions")

export (String) var item
export (int) var amount

func _ready():
	var itemID = def.ITEMS[self.item]
	var itemScene = def.ITEM_SCENES[itemID]
	var item = itemScene.instance()
	
	add_child(item)
