extends Node2D

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (String) var levelID

var currentDimensionID = "d_alive"
var player = null
var rng = RandomNumberGenerator.new()

# ================================
# Util
# ================================

func _ready():
	pass

func loadLevel():
	loadPlayer()
	setSpawn()
	
	spawnAll()

func spawnAll():
	for map in $SpawnMaps.get_children():
		for spawnMap in map.get_children():
			spawnObjects(spawnMap, map.name)
			yield(get_tree().create_timer(0.01), "timeout")
	
	$SpawnMaps.hide()

func initPlayer(gui):
	if player != null:
		vars.initHealth(player.maxHealth)
		player.initGUI(gui)
		gui.player = player

func loadPlayer():
	player = def.PLAYER_SCENE.instance()
	add_child(player)
	connectSignals()

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")

func setBoundary():
	player.setBoundaries($SpawnHelper.coordsToPos((get_node("SpawnMaps/" + currentDimensionID + "/Tiles").get_used_rect().end - Vector2(1, 1))) * 2)

# ================================
# Spawns
# ================================

func setSpawn():
	player.position = $Spawn.position

func spawnObjects(spawnMap, dimension, scale = Vector2(1, 1)):
	var objects = spawnMap.get_used_cells()
	
	for i in objects.size():
		var objectID = spawnMap.get_cellv(objects[i])
		var pos = objects[i]
		var special = ""
		
		var category = spawnMap.name
		if category == "Tiles" or category == "Triggers": special = category
		
		var stringID = def.STRING_IDS[category]
		var type = stringID[str(objectID)]
		
		stringID = type
		if special == "Tiles": stringID = "t_tile"
		
		var obj = $SpawnHelper.spawn(stringID, pos, scale, special)
		if special != "Triggers": obj.setType(type)
		else: obj.initialize(self, player, dimension)
		
		obj.changeDimension(currentDimensionID)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	currentDimensionID = dimension
	setBoundary()
	
	for t in $Tiles.get_children(): t.changeDimension(dimension)
	for e in $Entities.get_children(): e.changeDimension(dimension)
	for g in $Triggers.get_children(): g.changeDimension(dimension)
