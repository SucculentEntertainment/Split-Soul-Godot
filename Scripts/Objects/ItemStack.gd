extends Area2D

onready var def = get_node("/root/Definitions")

var itemName = ""
var amount = 0

func _ready():
	pass

func resetItem():
	itemName = ""
	amount = 0

func setType(itemName, amount):
	resetItem()
	
	self.itemName = itemName
	self.amount = amount
	
	if itemName == "" or amount <= 0:
		queue_free()
		return
	
	$Tween.interpolate_property($Sprite, "frame", def.ITEM_START_FRAMES[itemName], def.ITEM_START_FRAMES[itemName] + (def.ITEM_NUM_FRAMES[itemName] - 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	$Tween.start()

func changeDimension(dimension):
	pass
