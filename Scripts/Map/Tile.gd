extends StaticBody2D

onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()

export (String) var tileName
export (int) var variations
export (String) var layer
export (bool) var hasCollision

var variationChance = 10

func _ready():
	pass

func setType(tileName):
	self.tileName = tileName
	
	variations = def.TILE_VARIATIONS[tileName]
	hasCollision = def.TILE_COLLISIONS.has(tileName)
	
	layer = def.TILE_LAYERS[tileName.substr(tileName.length() - 1, 1)]
	$Sprite.frame = def.TILE_FRAMES[tileName]
	
	$CollisionShape2D.disabled = !hasCollision
	
	rng.randomize()
	if rng.randi_range(0, 100) <= variationChance:
		$Sprite.frame += rng.randi_range(0, variations - 1)

func changeDimension(dimension):
	if dimension & int(pow(2, def.DIMENSION_NAMES.values().find(layer))) != 0:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
