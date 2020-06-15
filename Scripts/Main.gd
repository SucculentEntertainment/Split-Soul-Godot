extends Node

export (int, "Easy", "Normal", "Hard") var difficulty
var level

# ================================
# Util
# ================================

func _ready():
	loadLevel("Test")

func loadLevel(levelName):
	var levelScene = load(str("res://Scenes/Levels/" + levelName + "/" + levelName + ".tscn"))
	level = levelScene.instance()
	$Level.add_child(level)
	
	level.spawn()
	level.initPlayer($CanvasLayer/GUI)

func destroyLevel():
	if level != null: level.queue_free()
