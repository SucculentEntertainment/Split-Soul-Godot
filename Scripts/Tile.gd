extends StaticBody2D

onready var def = get_node("/root/Definitions")

export (String) var tileName
export (String) var layer
export (bool) var hasCollision

func _ready():
	$CollisionShape2D.disabled = !hasCollision

func changeDimension(dimension):
	if dimension & int(pow(2, def.DIMENSION_NAMES.find(layer))) != 0:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
