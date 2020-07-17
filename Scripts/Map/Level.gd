extends Node2D

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, FLAGS, "Alive", "Dead") var availableDimensions
export (String) var levelName
export (Array, int) var numEnemies
export (Array, String) var spawnableEnemies

var currentDimensionID = ""

var player = null
var rng = RandomNumberGenerator.new()

# ================================
# Util
# ================================

func _ready():
	loadPlayer()
	connectSignals()
	
	if currentDimensionID == "": changeDimension("d_alive")
	
	setSpawn()
	spawnAll()

func spawnAll():
	spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Tiles"))
	spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Environment"))
	#spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Triggers"))
	spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Interactive"))
	spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Powerups"))
	spawnObjects(get_node("SpawnMaps/" + currentDimensionID + "/Enemies"))
	
	$SpawnMaps.hide()

func initPlayer(gui):
	if player != null:
		vars.initHealth(player.maxHealth)
		player.initGUI(gui)
		gui.player = player

func loadPlayer():
	player = def.PLAYER_SCENE.instance()
	add_child(player)

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")

func setBoundary():
	player.setBoundaries($SpawnHelper.coordsToPos((get_node("SpawnMaps/" + currentDimensionID + "/Tiles").get_used_rect().end - Vector2(1, 1))) * 2)

# ================================
# Spawns
# ================================

func setSpawn():
	player.position = $Spawn.position * 2

func spawnObjects(spawnMap, scale = Vector2(1, 1)):
	var objects = spawnMap.get_used_cells()
	
	for i in objects.size():
		var objectID = spawnMap.get_cellv(objects[i])
		var pos = objects[i]
		var tiles = false
		
		var category = spawnMap.name
		if category == "Tiles": tiles = true
		
		var stringID = def.STRING_IDS[category]
		if tiles: stringID = stringID[currentDimensionID]
		var type = stringID[str(objectID)]
		
		stringID = type
		if tiles: stringID = "t_tile"
		
		var obj = $SpawnHelper.spawn(stringID, pos, scale, tiles, currentDimensionID)
		obj.setType(type)

func spawnEnemies():
	var spawnedOn = []
	var tiles = get_node("Spawnable").get_used_cells()
	
	if tiles.size() <= 0: return
	
	for i in numEnemies[vars.difficulty]:
		rng.randomize()
		var enemyType = spawnableEnemies[rng.randi_range(0, spawnableEnemies.size() - 1)]
		
		rng.randomize()
		var tile = null
		while spawnedOn.find(tile) == -1:
			tile = tiles[rng.randi_range(0, tiles.size() - 1)]
			if  spawnedOn.find(tile) == -1: spawnedOn.append(tile)
		
		$SpawnHelper.spawn(enemyType, tile, Vector2(1, 1), false, currentDimensionID)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	currentDimensionID = dimension
	setBoundary()
	
	for t in $Tiles.get_children(): t.changeDimension(dimension)
	for e in $Entities.get_children(): e.changeDimension(dimension)
