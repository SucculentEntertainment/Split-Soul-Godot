extends Node

onready var def = get_node("/root/Definitions")

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
	
	level.changeDimension(def.DIMENSION_ALIVE)
	level.initPlayer($CanvasLayer/GUI)

func destroyLevel():
	if level != null: level.queue_free()
