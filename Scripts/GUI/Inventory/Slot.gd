extends Control

onready var def = get_node("/root/Definitions")

export (String) var item
export (int) var amount

func _ready():
	# TEMP
	updateItem("i_test1", 5)
	# TEMP END

func updateItem(item, amount):
	self.item = item
	self.amount = amount
	if item == "" or amount == 0: return
	
	var itemObject = def.ITEM_SCENE.instance()
	itemObject.setType(item, def)
	
	add_child(itemObject)
