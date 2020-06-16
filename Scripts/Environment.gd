extends StaticBody2D

onready var def = get_node("/root/Definitions")
var rng = RandomNumberGenerator.new()

export (String) var objectName
export (String) var layer
export (bool) var hasCollision

func _ready():
	rng.randomize()
	$CollisionShape2D.disabled = !hasCollision
	$AnimatedSprite.frame = rng.randi_range(0, $AnimatedSprite.frames.get_frame_count("default") - 1)

func changeDimension(dimension):
	if def.DIMENSION_NAMES.has(layer):
		if dimension & int(pow(2, def.DIMENSION_NAMES.find(layer))) != 0:
			show()
			if hasCollision: $CollisionShape2D.disabled = false
		else:
			hide()
			$CollisionShape2D.disabled = true
