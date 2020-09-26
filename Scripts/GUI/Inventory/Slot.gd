extends Control

onready var def = get_node("/root/Definitions")

var item = ""
var amount = 0

export (Vector2) var itemMargin
export (int) var itemScale

func _ready():
	pass

func resetItem():
	item = ""
	amount = 0
	
	$Label.text = ""
	
	for c in $Item.get_children():
		$Item.remove_child(c)
		c.queue_free()

func updateItem(item, amount):
	if item == null or amount == null: return
	resetItem()
	
	self.item = item
	self.amount = amount
	
	if item == "" or amount <= 0:
		return
	
	var itemObject = def.ITEM_SCENE.instance()
	$Item.add_child(itemObject)
	
	itemObject.setType(item)
	itemObject.set_position(itemMargin)
	itemObject.rect_scale = (itemObject.get_rect().size - (2 * itemMargin)) / itemObject.get_rect().size
	
	if amount > 1:
		$Label.text = str(amount)
	else:
		$Label.text = ""

func isEmpty():
	if item == "" or amount <= 0:
		return true
	else: 
		return false
