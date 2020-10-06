extends Control

var items = []

func _ready():
	for i in range(4):
		items.append("")

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

func _process(delta):
	items = []
	
	for s in $Slots.get_children():
		items.append(s.item)
