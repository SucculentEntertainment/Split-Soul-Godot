extends StaticBody2D

onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()

export (String) var tileName
export (String) var layer
export (bool) var hasCollision

func _ready():
	pass

func setType(tileName):
	self.tileName = tileName
	
	hasCollision = def.TILE_DATA["tiles"][tileName].hasCollision
	
	layer = def.TILE_DATA["layers"][tileName.substr(tileName.length() - 1, 1)].layer
	$Sprite.frame = def.TILE_DATA["tiles"][tileName].startFrame
	
	$CollisionShape2D.disabled = !hasCollision

func changeDimension(dimension):
	if dimension == layer:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
