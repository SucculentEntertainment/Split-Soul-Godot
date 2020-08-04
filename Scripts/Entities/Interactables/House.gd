extends "res://Scripts/Map/Environment.gd"

func _ready():
	pass

func setType(_type):
	pass

func changeDimension(dimension):
	if dimension == "d_dead": $Lights.show()
	else: $Lights.hide()
	
	for trigger in $Triggers.get_children():
		trigger.changeDimension(dimension)
	
	.changeDimension(dimension)
