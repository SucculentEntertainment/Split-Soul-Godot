extends Node

var playerScene = preload("res://Scenes/Entities/Player.tscn")
var player
var level

func _ready():
	loadLevel("Test")

func loadLevel(levelName):
	destroyLevel()
	
	var levelScene = load(str("res://Scenes/Levels/" + levelName + ".tscn"))
	level = levelScene.instance()
	add_child(level);
	
	loadPlayer()
	setSpawn()

func setSpawn():
	player.position = level.get_node("Spawn").position

func loadPlayer():
	player = playerScene.instance()
	add_child(player)

func destroyLevel():
	if level != null: level.queue_free()
	if player != null: player.queue_free()
