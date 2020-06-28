extends Control

onready var def = get_node("/root/Definitions")

export (String) var item = ""
export (int) var amount = 0
export (Vector2) var itemMargin
export (int) var itemScale

func _ready():
	pass

func resetItem():
	item = ""
	amount = 0

func updateItem(item, amount):
	self.item = item
	self.amount = amount
	if item == "" or amount <= 0:
		resetItem()
		return
	
	var itemObject = def.ITEM_SCENE.instance()
	itemObject.setType(item, def)
	
	$Item.add_child(itemObject)
	itemObject.set_position(itemMargin)
	itemObject.rect_scale = (itemObject.get_rect().size - (2 * itemMargin)) / itemObject.get_rect().size
	
	if amount > 1:
		$Label.text = str(amount)
	else:
		$Label.text = ""
