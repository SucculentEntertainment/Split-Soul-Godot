extends Control

onready var def = get_node("/root/Definitions")

var itemName = ""
var amount = 0

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		set_global_position(event.position)

func setType(itemName, amount):
	resetType()
	
	self.itemName = itemName
	self.amount = amount
	
	var item = def.ITEM_SCENE.instance()
	item.setType(itemName, def)
	$Item.add_child(item)
	
	if amount != 1:
		$Amount.text = str(amount)

func resetType():
	itemName = ""
	amount = 0
	
	$Amount.text = ""
	
	for c in $Item.get_children():
		$Item.remove_child(c)
		c.queue_free()
