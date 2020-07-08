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
	
func spawnAll():
	spawnObjects(currentDimension.get_node("Tiles"))
	spawnObjects(currentDimension.get_node("Environment"))
	spawnObjects(currentDimension.get_node("Powerups"))
	spawnObjects(currentDimension.get_node("Enemies"))
	spawnObjects(currentDimension.get_node("Interactables"))
	
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
			dimensions.append(load(str("res://Scenes/Levels/" + levelName + "/Dimensions/" + def.DIMENSION_NAMES[dimension] + ".tscn")))

func loadPlayer():
	player = def.PLAYER_SCENE.instance()
	add_child(player)

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")

func setBoundary():
	player.setBoundaries((currentDimension.get_node("Tiles").get_used_rect().end - Vector2(1, 1)) * 16 * currentDimension.scale * 2)

# ================================
# Spawns
# ================================

func setSpawn():
	if currentDimension == null: changeDimension(def.DIMENSION_ALIVE)
	player.position = currentDimension.get_node("Spawn").position * 2

func spawnObjects(spawnMap, scale = Vector2(1, 1)):
	var objects = spawnMap.get_used_cells()
	
	for i in objects.size():
		var objectID = spawnMap.get_cellv(objects[i])
		var pos = objects[i]
		var tiles = false
		
		var category = spawnMap.name
		if category == "Tiles": tiles = true
		
		var stringID = def.STRING_IDS[category]
		if tiles: stringID = stringID[def.DIMENSION_NAMES[currentDimensionID]]
		var type = stringID[objectID]
		
		stringID = type
		if tiles: stringID = "t_tile"
		
		var offset = (pos * scale) - pos
		
		var obj = $SpawnHelper.spawn(stringID, pos, scale, tiles, offset)
		obj.setType(type)
		obj.changeDimension(currentDimensionID)
	
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
		
		$SpawnHelper.spawn(enemyType, tile)

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
		setBoundary()
	
	if availableDimensions & dimension != 0:
		prevDimension = currentDimension
		currentDimensionID = dimension
		currentDimension = dimensions[def.logB(dimension, 2)].instance()
		
		$Dimension.add_child(currentDimension)
		prevDimension.queue_free()
		setBoundary()
		
		if spawnedDimensions.find(currentDimensionID) == -1:
			spawnedDimensions.append(currentDimensionID)
			spawnAll()
		
	# Hide SpawnMaps
	currentDimension.get_node("Tiles").hide()
	currentDimension.get_node("Environment").hide()
	currentDimension.get_node("Powerups").hide()
	currentDimension.get_node("Enemies").hide()
	currentDimension.get_node("Interactables").hide()
	currentDimension.get_node("Spawnable").hide()
	
	for t in $Tiles.get_children(): t.changeDimension(dimension)
	for e in $Entities.get_children(): e.changeDimension(dimension)
