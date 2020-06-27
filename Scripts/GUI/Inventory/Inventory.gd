extends Control

var player = null

func _ready():
	# TEMP
	var category = load("res://Scenes/GUI/Inventory/Category.tscn").instance()
	category.categoryName = "Test"
	category.description = "This is just a fucking Test"
	category.numSlots = 5
	
	$Categories.add_child(category)
	# TEMP END

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if visible: toggle()

func givePlayerReference(player):
	self.player = player

func toggle():
	if visible:
		visible = false
		player.disableIn = false
	else:
		visible = true
		player.disableIn = true
