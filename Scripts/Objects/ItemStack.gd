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
		armed = true

func _onArm():
	armed = true
	for a in get_overlapping_areas():
		_onPickup(a)

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
	
	$Item.setType(itemName)

func changeDimension(dimension):
	pass
