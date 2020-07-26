extends Node

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, "Easy", "Normal", "Hard") var difficulty
var prevLevel = null
var level = null

var prevLoaded = []

# ================================
# Util
# ================================

func _ready():
	vars.difficulty = difficulty
	loadLevel("l_test", "d_alive")

func loadLevel(levelID, dimension):
	print("Loading level: " + levelID)
	var levelScene = load(str("res://Scenes/Levels/" + levelID + ".tscn"))
	level = levelScene.instance()
	
	if prevLevel != null:
		prevLevel.unload()
	
	$Level.add_child(level)
	level.connect("changeLevel", self, "_onLevelChange")
	
	level.prevLevel = prevLevel
	level.gui = $CanvasLayer/GUI
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	$CanvasLayer/LoadingScreen.start(dimension, level, $CanvasLayer/GUI)
	yield($CanvasLayer/LoadingScreen, "loadingFinished")
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	if not prevLoaded.has(level):
		prevLoaded.append(level)
	
	if prevLevel != null:
		prevLevel.queue_free()
	
	prevLevel = level
	level = null

func _onLevelChange(level, dimension):
	loadLevel(level, dimension)

func destroyLevel():
	if level != null: level.queue_free()
