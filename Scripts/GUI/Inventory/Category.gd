extends Control

onready var slotScene = preload("res://Scenes/GUI/Inventory/Slot.tscn")
var slots = []

export (String) var categoryName
export (String) var description
export (int) var numSlots

func _ready():
	for i in numSlots:
		slots.append(slotScene.instance())
		$Slots.add_child(slots[slots.size() - 1])
	
	$Label.text = categoryName
