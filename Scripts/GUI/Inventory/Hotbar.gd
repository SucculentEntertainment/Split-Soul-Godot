extends Control

func _ready():
	pass

func loadItems(slots):
	var i = 0
	
	for s in $Slots.get_children():
		s.updateItem(slots[i].id, slots[i].amount)
		i += 1

func saveItems():
	var slots = []
	
	for s in $Slots.get_children():
		slots.append({"id": s.item , "amount": s.amount})
	
	return slots

func reset():
	for s in $Slots.get_children():
		s.resetItem()