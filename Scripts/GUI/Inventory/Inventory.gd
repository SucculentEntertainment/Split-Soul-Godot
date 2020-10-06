extends Control

onready var def = get_node("/root/Definitions")

var slotScene = preload("res://Scenes/GUI/Inventory/Slot.tscn")
var player = null
var level = null

export (String) var title = "Inventory"
export (int) var numSlots
export (Vector2) var margins

var slots = []
var hotbar = []
var mouseItem = false
var mouseOutside = false

func _ready():
	$MainPanel/Label.text = title
	
	$MainPanel/Label.set_position(margins)
	$MainPanel/Slots.set_position(Vector2(0, $MainPanel/Label.get_minimum_size().y + margins.y) + margins)
	
	for i in numSlots:
		var slot = slotScene.instance()
		$MainPanel/Slots.add_child(slot)
		slots.append(slot)
	
	for slot in $Hotbar/Slots.get_children():
		hotbar.append(slot)
	
	$MainPanel.connect("mouse_exited", self, "_onMouseExit")
	$MainPanel.connect("mouse_entered", self, "_onMouseEnter")
	$Hotbar.connect("mouse_exited", self, "_onMouseExit")
	$Hotbar.connect("mouse_entered", self, "_onMouseEnter")

func givePlayerReference(player):
	self.player = player

func toggle():
	if $MainPanel.visible:
		$MainPanel.visible = false
		player.disableIn = false
		
		if mouseItem:
			insertItem($MouseItem.itemName, $MouseItem.amount)
			$MouseItem.hide()
			$MouseItem.resetType()
			mouseItem = false
		
	else:
		$MainPanel.visible = true
		player.disableIn = true

# ================================
# Events
# ================================

func _process(_delta):
	var slot = getHoveredSlot()
	
	if slot != null and slot.item != "":
		$MainPanel/Tooltip.show()
		
		$MainPanel/Tooltip/Title.text = def.ITEM_DATA[slot.item].name
		$MainPanel/Tooltip/Description.text = def.ITEM_DATA[slot.item].description
	else:
		$MainPanel/Tooltip.hide()

func getHoveredSlot():
	var clickedSlot = null
	
	for slot in slots:
		if slot.is_hovered():
			clickedSlot = slot
			break
	
	for slot in hotbar:
		if slot.is_hovered():
			clickedSlot = slot
			break
	
	return clickedSlot

func takeSlot(slot, amount):
	$MouseItem.updateItem(slot.item, amount)
	slot.updateItem(slot.item, slot.amount - amount)
	mouseItem = true

func putSlot(slot, amount):
	var newAmount = slot.amount + amount
	var itemName = $MouseItem.itemName
	
	if amount + slot.amount > def.ITEM_DATA[$MouseItem.itemName].stackSize:
		$MouseItem.updateItem($MouseItem.itemName, $MouseItem.amount + slot.amount - def.ITEM_DATA[$MouseItem.itemName].stackSize)
		newAmount = def.ITEM_DATA[$MouseItem.itemName].stackSize
	elif slot.updateItem(itemName, newAmount) != -1:
		$MouseItem.updateItem($MouseItem.itemName, $MouseItem.amount - amount)


func _onMouseEnter():
	mouseOutside = false

func _onMouseExit():
	mouseOutside = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var rightClick = false
		
		if event.button_index == BUTTON_RIGHT: rightClick = true
		if event.button_index != BUTTON_LEFT and !rightClick: return
		
		var slot = getHoveredSlot()
		
		if !mouseItem:
			if slot == null or slot.isEmpty(): return
			
			var amount = slot.amount
			if rightClick: amount /= 2
			takeSlot(slot, amount)
		
		elif mouseItem:
			var amount = $MouseItem.amount
			if rightClick: amount = 1
			
			if !mouseOutside:
				if slot == null: return
				if slot.item != $MouseItem.itemName and !slot.isEmpty(): return
				
				putSlot(slot, amount)
				if $MouseItem.amount == 0: mouseItem = false
			elif mouseOutside:
				if level == null:
					level = player.get_parent()
				
				var spawnHelper = level.get_node("SpawnHelper")
				var obj = spawnHelper.spawn("p_itemStack", spawnHelper.posToCoords(player.get_position() / level.get_node("Tiles").scale), Vector2(0.25, 0.25))
				
				obj.setType($MouseItem.itemName, amount)
				$MouseItem.updateItem($MouseItem.itemName, $MouseItem.amount - amount)
				if $MouseItem.amount == 0: mouseItem = false

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
		var freeAmount = def.ITEM_DATA[item].stackSize - s.amount
		
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
	

func resetInventory():
	for s in slots:
		s.queue_free()
	
	slots = []
	$Hotbar.reset()
	
	for i in numSlots:
		var slot = slotScene.instance()
		$MainPanel/Slots.add_child(slot)
		slots.append(slot)
