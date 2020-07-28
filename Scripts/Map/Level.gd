extends Node2D

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

signal changeLevel(level)

export (String) var levelID

var prevLevel = null
var prevLevelID = ""

var wentBack = false

var currentDimensionID = "d_alive"
var player = null
var rng = RandomNumberGenerator.new()

var gui = null

# ================================
# Util
# ================================

func _ready():
	pass

func loadLevel(resetHealth = false):
	if prevLevel != null:
		player = prevLevel.player
		prevLevel.remove_child(player)
		
		if wentBack:
			player.global_position = get_parent().get_parent().lastPositions[levelID]
		
		prevLevelID = prevLevel.levelID
		currentDimensionID = prevLevel.currentDimensionID
	
	loadPlayer(resetHealth)
	setSpawn()
	
	spawnAll()

func spawnAll():
	for map in $SpawnMaps.get_children():
		if get_parent().get_parent().prevLoaded.has(levelID):
			map.get_node("Enemies").clear()
		
		for spawnMap in map.get_children():
			spawnObjects(spawnMap, map.name)
			yield(get_tree().create_timer(0.01), "timeout")
	
	$SpawnMaps.hide()

func initPlayer(gui, resetHealth = false):
	if player != null:
		if resetHealth:
			vars.initHealth(player.maxHealth)
		player.initGUI(gui)
		gui.player = player

func loadPlayer(resetHealth = false):
	if player == null:
		player = def.PLAYER_SCENE.instance()
	
	add_child(player)
	connectSignals()
	
	initPlayer(gui, resetHealth)

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")

# ================================
# Spawns
# ================================

func setSpawn():
	if !wentBack:
		player.position = $Spawn.position / 2

func spawnObjects(spawnMap, dimension, scale = Vector2(1, 1)):
	var objects = spawnMap.get_used_cells()
	var levelChangeCount = 0
	
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
		
		if stringID == "g_levelChange":
			var targetLevel = def.LEVEL_DATA[levelID].levelChanges[levelChangeCount]
			if targetLevel == "backToPrev":
				obj.wentBack = true
				targetLevel = prevLevelID
				
				if targetLevel == "":
					print("Error: No Level to go back to")
			
			obj.targetLevel = targetLevel
			levelChangeCount += 1
		
		obj.changeDimension(currentDimensionID)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	currentDimensionID = dimension
	
	for t in $Tiles.get_children(): t.changeDimension(dimension)
	for e in $Entities.get_children(): e.changeDimension(dimension)
	for g in $Triggers.get_children(): g.changeDimension(dimension)

func unload():
	for e in $Entities.get_children(): e.queue_free()
