extends Node

onready var def = get_node("/root/Definitions")

var tileSize = Vector2()
var tileScale = Vector2()

# ================================
# Util
# ================================

func _ready():
	pass

func getTileSize():
	var dimensions = get_parent().get_node("SpawnMaps").get_children()
	var cellSize = dimensions[0].get_node("Tiles").cell_size
	
	tileScale = get_parent().get_node("Tiles").scale
	tileSize = cellSize

# ================================
# Coord Conversion
# ================================

func coordsToPos(coords):
	if tileSize == Vector2(): getTileSize()
	
	var pos = coords * tileSize
	return pos

func posToCoords(pos):
	if tileSize == Vector2(): getTileSize()
	
	var coords = pos / tileSize / tileScale
	return coords

# ================================
# Spawn
# ================================

func spawn(eName, coords, scale = Vector2(1, 1), special = "", currentDimensionID = ""):
	var obj = def.SPAWNABLE_SCENES[eName].instance()
	if obj == null: return
	
	var parent = get_parent().get_node("Entities")
	if special != "": parent = get_parent().get_node(special)
	
	parent.add_child(obj)
	var textureOffset = posToCoords(obj.get_node("Sprite").position * Vector2(-1, -1) * scale)
	
	obj.position = coordsToPos(coords + textureOffset)
	obj.scale = scale
	
	if currentDimensionID != "": obj.changeDimension(currentDimensionID)
	return obj
