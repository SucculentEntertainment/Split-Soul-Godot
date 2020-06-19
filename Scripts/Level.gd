extends Node2D

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, FLAGS, "Alive", "Dead") var availableDimensions
export (String) var levelName
export (Array, int) var numEnemies

var dimensions = []
var spawnedDimensions = []
var currentDimension = null
var prevDimension = null
var currentDimensionID = 0

var player = null
var rng = RandomNumberGenerator.new()

# ================================
# Util
# ================================

func _ready():
	loadDimensions()
	loadPlayer()
	
	connectSignals()
	setSpawn()
	
func spawn():
	spawnObjects(currentDimension.get_node("Tiles"), $Tiles, def.TILE_SCENES[def.logB(currentDimensionID, 2)], 2)
	spawnObjects(currentDimension.get_node("Environment"), $Environment, def.ENVIRONMENT_SCENES, 1, 2, Vector2(0, 1))
	spawnObjects(currentDimension.get_node("Items"), $Items, def.ITEM_SCENES)
	spawnObjects(currentDimension.get_node("Enemies"), $Enemies, def.ENEMY_SCENES)
	spawnObjects(currentDimension.get_node("Interactables"), $Interactables, def.INTERACTABLE_SCENES)
	
	spawnEnemies()

func initPlayer(gui):
	if player != null:
		vars.initHealth(player.maxHealth)
		player.initGUI(gui)
		gui.player = player

func loadDimensions():
	for i in def.NUM_DIMENSIONS:
		var dimension = availableDimensions & (1 << i)
		if dimension != 0:
			dimensions.append(load(str("res://Scenes/Levels/" + levelName + "/Dimensions/" + def.DIMENSION_STRINGS[dimension] + ".tscn")))

func loadPlayer():
	player = def.PLAYER_SCENE.instance()
	add_child(player)

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")

# ================================
# Spawns
# ================================

func setSpawn():
	if currentDimension == null: changeDimension(def.DIMENSION_ALIVE)
	player.position = currentDimension.get_node("Spawn").position * currentDimension.scale * 2

func spawnObjects(spawnMap, objectParent, scenes, scale = 1, positionScale = 1, offset = Vector2(0, 0)):
	var objects = spawnMap.get_used_cells()
	
	for i in objects.size():
		var objectID = spawnMap.get_cellv(objects[i])
		var object = scenes[objectID].instance()
		
		objectParent.add_child(object)
		object.scale = currentDimension.scale * scale
		
		var texture = null
		if objectParent == $Enemies or objectParent == $Items: texture = object.get_node("Sprite").texture
		else: texture = object.get_node("AnimatedSprite").frames.get_frame("default", 0)
		
		object.position = (spawnMap.map_to_world(objects[i]) + (texture.get_size() / 2) + spawnMap.map_to_world(offset)) * object.scale * positionScale
		object.changeDimension(currentDimensionID)
	
	spawnMap.clear()

func spawnEnemies():
	var spawnedOn = []
	var tiles = currentDimension.get_node("Spawnable").get_used_cells()
	
	if tiles.size() <= 0: return
	
	for i in numEnemies[vars.difficulty]:
		rng.randomize()
		var enemyType = def.SPAWNABLE_ENEMIES[rng.randi_range(0, def.SPAWNABLE_ENEMIES.size() - 1)]
		
		rng.randomize()
		var tile = null
		while spawnedOn.find(tile) == -1:
			tile = tiles[rng.randi_range(0, tiles.size() - 1)]
			if  spawnedOn.find(tile) == -1: spawnedOn.append(tile)
		
		var enemy = def.ENEMY_SCENES[enemyType].instance()
		$Enemies.add_child(enemy)
		enemy.position = (currentDimension.get_node("Spawnable").map_to_world(tile) + (enemy.get_node("Sprite").texture.get_size() / 2)) * enemy.scale * currentDimension.scale
		enemy.scale *= currentDimension.scale

# ================================
# Actions
# ================================

func changeDimension(dimension):
	dimension = int(dimension)
	
	if dimensions.size() == 0:
		print("No Dimensions Loaded")
		return
	
	if currentDimension == null:
		currentDimensionID = def.DIMENSION_ALIVE
		currentDimension = dimensions[def.logB(def.DIMENSION_ALIVE, 2)].instance()
		$Dimension.add_child(currentDimension)
	
	if availableDimensions & dimension != 0:
		prevDimension = currentDimension
		currentDimensionID = dimension
		currentDimension = dimensions[def.logB(dimension, 2)].instance()
		
		$Dimension.add_child(currentDimension)
		prevDimension.queue_free()
		
		if spawnedDimensions.find(currentDimensionID) == -1:
			spawnedDimensions.append(currentDimensionID)
			spawn()
		
	# Hide SpawnMaps
	currentDimension.get_node("Tiles").hide()
	currentDimension.get_node("Environment").hide()
	currentDimension.get_node("Items").hide()
	currentDimension.get_node("Enemies").hide()
	currentDimension.get_node("Interactables").hide()
	currentDimension.get_node("Spawnable").hide()
	
	for t in $Tiles.get_children(): t.changeDimension(dimension)
	for e in $Environment.get_children(): e.changeDimension(dimension)
	for i in $Items.get_children(): i.changeDimension(dimension)
	for e in $Enemies.get_children(): e.changeDimension(dimension)
	for s in $Interactables.get_children(): s.changeDimension(dimension)
