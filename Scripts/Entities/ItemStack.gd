extends Node2D

onready var def = get_node("/root/Definitions")

export (String) var item
export (int) var amount

func _ready():
	if item == "" or amount == 0: return
	
	var itemObject = def.ITEM_SCENE.instance()
	itemObject.setType(item)
	
	add_child(item)
