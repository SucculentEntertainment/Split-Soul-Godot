extends StaticBody2D

onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()

export (String) var tileName
export (int) var variations
export (String) var layer
export (bool) var hasCollision

var variationChance = 5

func _ready():
	$CollisionShape2D.disabled = !hasCollision
	
	rng.randomize()
	if rng.randi_range(0, 100) <= variationChance:
		$Sprite.frame += rng.randi_range(0, variations - 1)

func changeDimension(dimension):
	if dimension & int(pow(2, def.DIMENSION_NAMES.find(layer))) != 0:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
