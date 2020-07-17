extends Node

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, "Easy", "Normal", "Hard") var difficulty
var level

# ================================
# Util
# ================================

func _ready():
	vars.difficulty = difficulty
	loadLevel("Test")

func loadLevel(levelName):
	var levelScene = load(str("res://Scenes/Levels/" + levelName + ".tscn"))
	level = levelScene.instance()
	$Level.add_child(level)
	
	level.changeDimension("d_alive")
	level.initPlayer($CanvasLayer/GUI)

func destroyLevel():
	if level != null: level.queue_free()
