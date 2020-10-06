extends Area2D

onready var def = get_node("/root/Definitions")
const id = "p_itemStack"

var itemName = ""
var amount = 0

var health = -1 
var state = 0

var armed = false

func _ready():
	connect("area_entered", self, "_onPickup")
	connect("area_exited", self, "_onAreaExit")
	
	$Timer.connect("timeout", self, "_onArm")
	$Timer.start()

func _onPickup(area):
	if "Interactions" in area.name:
		if armed:
			var body = area.get_parent()
			
			if body != null and "Player" in body.name:
				body.itemAction(self)
				queue_free()

func _onAreaExit(area):
	if "Interactions" in area.name:
		$Timer.stop()
		_onArm()

func _onArm():
	armed = true

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
	
	$Tween.interpolate_property($Sprite, "frame", def.ITEM_DATA[itemName].startFrame, def.ITEM_DATA[itemName].startFrame + (def.ITEM_DATA[itemName].numFrames - 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	$Tween.start()

func changeDimension(dimension):
	pass
