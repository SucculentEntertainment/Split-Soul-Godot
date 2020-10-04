extends Control

var items = []

func _ready():
	for i in range(4):
		items.append("")

func _process(delta):
	items[0] = $Slots/Weapon.item
	items[1] = $Slots/AltWeapon.item
	items[2] = $Slots/Shield.item
	items[3] = $Slots/Potion.item
