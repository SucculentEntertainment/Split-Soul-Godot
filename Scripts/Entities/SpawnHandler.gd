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
	
	tileSize = cellSize * dimensions[0].scale

# ================================
# Coord Conversion
# ================================

func coordsToPos(coords):
	if tileSize == Vector2(): getTileSize()
	
	var pos = coords * tileSize
	return pos

func posToCoords(pos):
	if tileSize == Vector2(): getTileSize()
	
	var coords = pos / (tileSize * 2)
	return coords

# ================================
# Spawn
# ================================

func spawn(eName, coords, scale = Vector2(1, 1), tile = false):
	var obj = def.SPAWNABLE_SCENES[eName].instance()
	if obj == null: return
	
	var parent = get_parent().get_node("Entities")
	if tile: parent = get_parent().get_node("Tiles")
	
	parent.add_child(obj)
	
	obj.position = coordsToPos(coords * scale)
	obj.scale = scale
	return obj
