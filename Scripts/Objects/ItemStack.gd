extends Area2D

onready var def = get_node("/root/Definitions")

var itemName = ""
var amount = 0

func _ready():
	pass

func resetItem():
	itemName = ""
	amount = 0
	
	for c in $Item.get_children():
		$Item.remove_child(c)
		c.queue_free()

func setType(itemName, amount):
	resetItem()
	
	self.itemName = itemName
	self.amount = amount
	
	if itemName == "" or amount <= 0:
		queue_free()
		return
	
	var item = def.ITEM_SCENE.instance()
	$Item.add_child(item)
	item.setType(itemName)

func changeDimension(dimension):
	pass
