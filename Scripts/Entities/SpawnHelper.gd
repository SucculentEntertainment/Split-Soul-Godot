extends Node

onready var def = get_node("/root/Definitions")

var tileSize = Vector2()

# ================================
# Util
# ================================

func _ready():
	pass

func getTileSize():
	var dimensions = get_parent().get_node("Dimension").get_children()
	var cellSize = dimensions[0].get_node("Tiles").cell_size
	
	tileSize = cellSize

# ================================
# Coord Conversion
# ================================

func coordsToPos(coords, tile = false):
	if tileSize == Vector2(): getTileSize()
	
	var pos
	if tile: pos = coords * (tileSize * 2)
	else: pos = coords * tileSize
	return pos

func posToCoords(pos, tile = false):
	if tileSize == Vector2(): getTileSize()
	
	var coords
	if tile: coords = pos / (tileSize * 2)
	else: coords = pos / tileSize
	return coords

# ================================
# Spawn
# ================================

func spawn(eName, coords, scale = Vector2(1, 1), tile = false, offset = Vector2()):
	var obj = def.SPAWNABLE_SCENES[eName].instance()
	if obj == null: return
	
	var parent = get_parent().get_node("Entities")
	if tile: parent = get_parent().get_node("Tiles")
	
	parent.add_child(obj)
	var textureOffset = posToCoords(obj.get_node("Sprite").offset * Vector2(-1, -1) * obj.get_node("Sprite").scale, tile)
	
	obj.position = coordsToPos(coords + offset + textureOffset, tile)
	obj.scale = scale
	return obj
