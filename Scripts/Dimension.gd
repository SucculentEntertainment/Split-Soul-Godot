extends Node2D

export (String) var dimensionName
onready var def = get_node("/root/Definitions")

func _ready():
	pass

func changeDimension(dimension):
	if def.DIMENSION_NAMES.has(dimensionName):
		for child in get_children(): child.changeDimension(dimension)
		
		if pow(2, def.DIMENSION_NAMES.find(dimensionName)) & dimension != 0:
			show()
		else:
			hide()
