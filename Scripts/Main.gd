extends Node

signal levelLoaded
signal saveComplete
signal loadComplete

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, "Easy", "Normal", "Hard") var difficulty
var prevLevel = null
var level = null

var prevLoaded = []
var lastPositions = {}

var locked = false
var loading = false

var entities = {}

# ================================
# Util
# ================================

func _ready():
	$CanvasLayer/GUI/QuickMenu.connect("exitToMenu", self, "_onExit")
	
	var mainMenu = load("res://Scenes/GUI/MainMenu.tscn").instance()
	$Menu.add_child(mainMenu)
	mainMenu.connect("menuClosed", self, "_onMenuExit")
	
	vars.difficulty = difficulty

func loadLevel(levelID, dimension, wentBack = false, firstLoad = false, prevLevelID = ""):
	if locked: return
	
	yield(get_tree().create_timer(0.1), "timeout")
	if locked: return
	locked = true
	
	if !loading:
		$Loading/LoadingScreen.start(dimension)
		yield($Loading/LoadingScreen, "startedLoading")
	
	var levelScene = load(str("res://Scenes/Levels/" + levelID + ".tscn"))
	level = levelScene.instance()
	
	$Level.add_child(level)
	level.connect("changeLevel", self, "_onLevelChange")
	
	if prevLevel != null:
		level.prevLevelID = prevLevel.levelID
		destroyLevel()
	
	if prevLevelID != "":
		level.prevLevelID = prevLevelID
	
	level.wentBack = wentBack
	level.gui = $CanvasLayer/GUI
	
	level.loadLevel(prevLoaded, entities, firstLoad)
	level.player.changeDimension(dimension)
	
	if not prevLoaded.has(levelID):
		prevLoaded.append(levelID)
	
	prevLevel = level
	level = null
	
	locked = false
	
	if !loading:
		$Loading/LoadingScreen.end()
	
	emit_signal("levelLoaded")

func _onLevelChange(level, dimension, wentBack):
	lastPositions[self.prevLevel.levelID] = self.prevLevel.player.prevPos
	
	entities[self.prevLevel.levelID] = []
	
	for e in self.prevLevel.get_node("Entities").get_children():
		entities[self.prevLevel.levelID].append({"id": e.id, "pos": e.global_position, "health": e.health})
	
	loadLevel(level, dimension, wentBack)
	yield(self, "levelLoaded")

func destroyLevel():
	if prevLevel != null:
		prevLevel.unload()
		prevLevel.queue_free()
		prevLevel = null
	
	$CanvasLayer/GUI.player = null
	$CanvasLayer/GUI/Inventory.resetInventory()
	vars.resetVars()

func saveGame(file):
	var level = prevLevel
	
	file.store_var(vars.difficulty)
	
	file.store_var(level.levelID)
	file.store_var(level.prevLevelID)
	
	file.store_var(level.currentDimensionID)
	
	file.store_var(prevLoaded)
	file.store_var(lastPositions)
	
	file.store_var(level.wentBack)
	
	entities[self.prevLevel.levelID] = []
	for e in level.get_node("Entities").get_children():
		entities[self.prevLevel.levelID].append({"id": e.id, "pos": e.global_position, "health": e.health})
	
	file.store_var(entities)
	
	file.store_var(level.player.global_position)
	file.store_var(vars.health)
	file.store_var(vars.coins)
	file.store_var(vars.soulpoints)
	
	file.store_var(vars.dead)
	
	var inventory = []
	for slot in $CanvasLayer/GUI/Inventory.slots:
		inventory.append({"id": slot.item, "amount": slot.amount})
	
	file.store_var(inventory)
	
	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("saveComplete")

func loadGame(file):
	vars.difficulty = file.get_var()
	
	var levelID = file.get_var()
	var prevLevelID = file.get_var()
	
	var dimension = file.get_var()
	
	$Loading/LoadingScreen.start(dimension)
	yield($Loading/LoadingScreen, "startedLoading")
	loading = true
	
	destroyLevel()
	
	prevLoaded = file.get_var()
	lastPositions = file.get_var()
	
	var wentBack = file.get_var()
	
	entities = file.get_var()
	
	loadLevel(levelID, dimension, wentBack, false, prevLevelID)
	yield(self, "levelLoaded")
	
	prevLevel.player.global_position = file.get_var()
	vars.health = file.get_var()
	vars.coins = file.get_var()
	vars.soulpoints = file.get_var()
	
	$CanvasLayer/GUI.updateValues(prevLevel.player.maxHealth)
	
	vars.dead = file.get_var()
	
	var inventory = file.get_var()
	var i = 0
	
	for slot in $CanvasLayer/GUI/Inventory.slots:
		slot.updateItem(inventory[i].id, inventory[i].amount)
		i += 1
	
	$Loading/LoadingScreen.end()
	loading = false
	
	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("loadComplete")

func _onMenuExit():
	for menu in $Menu.get_children():
		menu.queue_free()

func _onExit():
	prevLevel.unload()
	destroyLevel()
	
	var mainMenu = load("res://Scenes/GUI/MainMenu.tscn").instance()
	$Menu.add_child(mainMenu)
	mainMenu.connect("menuClosed", self, "_onMenuExit")

func newGame():
	destroyLevel()
	prevLoaded = []
	lastPositions = {}
	entities = {}
	
	loadLevel("l_test", "d_alive", false, true)
