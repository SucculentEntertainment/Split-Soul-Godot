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
	
	$CanvasLayer/LoadingScreen.start("d_alive", level, $CanvasLayer/GUI)
	yield($CanvasLayer/LoadingScreen, "loadingFinished")
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")

func destroyLevel():
	if level != null: level.queue_free()
