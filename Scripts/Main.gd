extends Node

var playerScene = preload("res://Scenes/Entities/Player.tscn")
var player
var level

# ================================
# Util
# ================================

func _ready():
	loadPlayer()
	loadLevel("Test")
	
	connectSignals()
	
func loadLevel(levelName):
	var levelScene = load(str("res://Scenes/Levels/" + levelName + ".tscn"))
	level = levelScene.instance()
	$Level.add_child(level);
	setSpawn()

func setSpawn():
	player.position = level.get_node("Spawn").position

func loadPlayer():
	player = playerScene.instance()
	$Player.add_child(player)

func destroyLevel():
	if level != null: level.queue_free()
	if player != null: player.queue_free()

# ================================
# Gameplay
# ================================

func changeDimension(dimension):
	level.changeDimension(dimension)
	player.changeDimension(dimension)

# ================================
# Signals
# ================================

func connectSignals():
	player.connect("changeDimension", self, "changeDimension")
	player.get_node("GUI/Main").connect("giveDamage", level.get_node("Enemies/EnemySlime"), "_onReceiveDamage")
