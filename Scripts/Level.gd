extends Node2D

onready var def = get_node("/root/Definitions")

export (int, FLAGS, "Alive", "Dead") var availableDimensions
export (String) var levelName

var dimensions = []
var currentDimension = null

# ================================
# Util
# ================================

func _ready():
	loadDimensions()

func loadDimensions():
	for i in def.NUM_DIMENSIONS:
		var dimension = availableDimensions & (1 << i)
		if dimension != 0:
			dimensions.append(load(str("res://Scenes/Levels/" + levelName + "/Dimensions/" + def.DIMENSION_STRINGS[dimension] + ".tscn")))

# ================================
# Spawns
# ================================

func setSpawn(player):
	if currentDimension == null: changeDimension(def.DIMENSION_ALIVE)
	player.position = currentDimension.get_node("Spawn").position

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
	if dimensions.size() == 0:
		print("No Dimensions Loaded")
		return
	
	if currentDimension == null:
		currentDimension = dimensions[def.logB(def.DIMENSION_ALIVE, 2)].instance()
		$Dimension.add_child(currentDimension)
	
	if availableDimensions & dimension != 0:
		var prevDimension = currentDimension
		currentDimension = dimensions[def.logB(dimension, 2)].instance()
		$Dimension.add_child(currentDimension)
		prevDimension.queue_free()
		
		for i in $Items.get_children(): i.changeDimension(dimension)
		for e in $Enemies.get_children(): e.changeDimension(dimension)
		for s in $Interactables.get_children(): s.changeDimension(dimension)
