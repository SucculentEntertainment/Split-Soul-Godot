extends Node2D

onready var def = get_node("/root/Definitions")
var dimensions = []
var highestDimension
var currentDimension = 1

# ================================
# Util
# ================================

func _ready():
	spawnItems()
	spawnEnemies()
	spawnStructures()
	
	highestDimension = getHighestDimension()

func getHighestDimension():
	for dimension in $Dimensions.get_children():
		dimensions.append(dimension)
	return 1 << (dimensions.size() - 1)

# ================================
# Spawns
# ================================

func spawnItems():
	var items = $ItemSpawns.get_used_cells()
	for i in items.size():
		var itemID = $ItemSpawns.get_cellv(items[i])
		var item = def.ITEM_SCENES[itemID].instance()
		$Items.add_child(item)
		item.position = $ItemSpawns.map_to_world(items[i]) * $ItemSpawns.scale
	$ItemSpawns.clear()

func spawnEnemies():
	var enemies = $EnemySpawns.get_used_cells()
	for e in enemies.size():
		var enemyID = $EnemySpawns.get_cellv(enemies[e])
		var enemy = def.ENEMY_SCENES[enemyID].instance()
		$Enemies.add_child(enemy)
		enemy.position = $EnemySpawns.map_to_world(enemies[e]) * $EnemySpawns.scale
	$EnemySpawns.clear()

func spawnStructures():
	var structures = $StructureSpawns.get_used_cells()
	for s in structures.size():
		var structureID = $StructureSpawns.get_cellv(structures[s])
		var structure = def.STRUCTURE_SCENES[structureID].instance()
		$Structures.add_child(structure)
		structure.position = $StructureSpawns.map_to_world(structures[s]) * $StructureSpawns.scale
	$StructureSpawns.clear()

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if dimension <= highestDimension:
		dimensions[def.logB(currentDimension, 2)].hide()
		dimensions[def.logB(dimension, 2)].show()
		currentDimension = dimension
		
		for i in $Items.get_children(): i.changeDimension(dimension)
		for e in $Enemies.get_children(): e.changeDimension(dimension)
		for s in $Structures.get_children(): s.changeDimension(dimension)
