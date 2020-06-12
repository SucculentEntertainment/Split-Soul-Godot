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

func changeDimension():
	if level.get_node("Normal").visible:
		level.get_node("Normal").hide()
		level.get_node("Dead").show()
	else:
		level.get_node("Normal").show()
		level.get_node("Dead").hide()
	
	for enemy in level.get_node("Enemies").get_children():
		enemy.changeDimension()

# ================================
# Signals
# ================================

func connectSignals():
	player.connect("died", self, "changeDimension")
	player.get_node("GUI/Main").connect("giveDamage", level.get_node("Enemies/EnemySlime"), "_onReceiveDamage")
