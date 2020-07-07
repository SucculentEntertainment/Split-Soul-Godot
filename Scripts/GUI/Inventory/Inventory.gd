extends Control

onready var def = get_node("/root/Definitions")

var slotScene = preload("res://Scenes/GUI/Inventory/Slot.tscn")
var player = null
var level = null

export (String) var title = "Inventory"
export (int) var numSlots
export (Vector2) var margins

var slots = []
var mouseItem = false
var mouseOutside = false

func _ready():
	$Label.text = title
	
	$Label.set_position(margins)
	$Slots.set_position(Vector2(0, $Label.get_minimum_size().y + margins.y) + margins)
	
	for i in numSlots:
		var slot = slotScene.instance()
		$Slots.add_child(slot)
		slots.append(slot)
	
	connect("mouse_exited", self, "_onMouseExit")
	connect("mouse_entered", self, "_onMouseEnter")

func givePlayerReference(player):
	self.player = player

func toggle():
	if visible:
		visible = false
		player.disableIn = false
	else:
		visible = true
		player.disableIn = true

# ================================
# Events
# ================================

func getHoveredSlot():
	var clickedSlot = null
	
	for slot in slots:
		if slot.is_hovered():
			clickedSlot = slot
			break
	
	return clickedSlot

func _onMouseEnter():
	mouseOutside = false

func _onMouseExit():
	mouseOutside = true

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if visible: toggle()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var slot = getHoveredSlot()
			
			if !mouseItem:
				if slot != null and !slot.isEmpty():
					$MouseItem.setType(slot.item, slot.amount)
					$MouseItem.show()
					slot.resetItem()
					mouseItem = true
			elif mouseItem:
				if slot != null and (slot.item == $MouseItem.itemName or slot.isEmpty()):
					slot.updateItem($MouseItem.itemName, slot.amount + $MouseItem.amount)
					$MouseItem.hide()
					$MouseItem.resetType()
					mouseItem = false
				elif mouseOutside:
					if level == null:
						level = player.get_parent()
					
					var obj = level.spawn(player.get_position(), level.get_node("Powerups"), def.ITEM_STACK_SCENE)
					obj.setType($MouseItem.itemName, $MouseItem.amount)
					print(obj.position)
		
		if event.pressed and event.button_index == BUTTON_RIGHT:
			var slot = getHoveredSlot()
			
			if !mouseItem:
				if slot != null and !slot.isEmpty():
					$MouseItem.setType(slot.item, ceil(slot.amount / 2))
					$MouseItem.show()
					slot.updateItem(slot.item, slot.amount - $MouseItem.amount)
					mouseItem = true
			elif mouseItem:
				if slot != null and (slot.item == $MouseItem.itemName or slot.isEmpty()):
					slot.updateItem($MouseItem.itemName, slot.amount + 1)
					$MouseItem.setType($MouseItem.itemName, $MouseItem.amount - 1)
					
					if $MouseItem.amount <= 0:
						$MouseItem.hide()
						$MouseItem.resetType()
						mouseItem = false

# ================================
# Inventory functions
# ================================

func findSlot(itemName):
	var found = []
	
	for s in slots:
		if s.item == itemName:
			found.push_back(s)
	
	return found

func divideAmounts(item, amount, slots):
	var amounts = []
	
	for s in slots:
		var freeAmount = def.ITEM_STACK_SIZES[item] - s.amount
		
		if amount > freeAmount:
			amounts.push_back(freeAmount)
			amount -= amounts[amounts.size() - 1]
		else:
			amounts.push_back(amount)
			amount = 0
			break
	
	if amount != 0:
		return null
	
	return amounts

func insertItem(itemName, amount):
	var slots = findSlot(itemName)
	var amounts = []
	
	slots += findSlot("")
	
	if slots.size() == 0:
		return -1
	
	amounts = divideAmounts(itemName, amount, slots)
	if amounts == null:
		return -1
	
	for a in amounts.size():
		slots[a].updateItem(itemName, amounts[a] + slots[a].amount)
	
	return 0
	
