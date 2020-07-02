extends Control

onready var def = get_node("/root/Definitions")

var slotScene = preload("res://Scenes/GUI/Inventory/Slot.tscn")
var player = null

export (String) var title = "Inventory"
export (int) var numSlots
export (Vector2) var margins

var slots = []
var mouseItem = false
var clickedSlot = null

func _ready():
	$Label.text = title
	
	$Label.set_position(margins)
	$Slots.set_position(Vector2(0, $Label.get_minimum_size().y + margins.y) + margins)
	
	for i in numSlots:
		var slot = slotScene.instance()
		$Slots.add_child(slot)
		slots.append(slot)
		slot.connect("slotClicked", self, "_onSlotClicked")

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

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if visible: toggle()
	
	if event is InputEventMouseMotion:
		$MouseItem.rect_position = event.position
	
	if event is InputEventMouseButton:
		if clickedSlot != null:
			if event.pressed and event.button_index == BUTTON_LEFT:
				pass

func _onSlotClicked(slot):
	clickedSlot = slot

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
		slots[a].updateItem(itemName, amounts[a])
	
	return 0
	
