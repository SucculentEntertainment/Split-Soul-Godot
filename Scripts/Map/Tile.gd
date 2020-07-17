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
	
	variations = def.TILE_DATA["tiles"][tileName].variations
	hasCollision = def.TILE_DATA["tiles"][tileName].hasCollision
	
	layer = def.TILE_DATA["layers"][tileName.substr(tileName.length() - 1, 1)].layer
	$Sprite.frame = def.TILE_DATA["tiles"][tileName].startFrame
	
	$CollisionShape2D.disabled = !hasCollision
	
	rng.randomize()
	if rng.randi_range(0, 100) <= variationChance:
		$Sprite.frame += rng.randi_range(0, variations - 1)

func changeDimension(dimension):
	if dimension == layer:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
