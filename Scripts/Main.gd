extends Node

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (int, "Easy", "Normal", "Hard") var difficulty
var prevLevel = null
var level = null

var prevLoaded = []
var lastPositions = {}

var locked = false

# ================================
# Util
# ================================

func _ready():
	$CanvasLayer/GUI/QuickMenu.connect("exitToMenu", self, "_onExit")
	
	vars.difficulty = difficulty
	loadLevel("l_test", "d_alive", false, true)

func loadLevel(levelID, dimension, wentBack = false, firstLoad = false):
	if locked: return
	
	yield(get_tree().create_timer(0.1), "timeout")
	if locked: return
	locked = true
	
	print("Loading level: " + levelID)
	var levelScene = load(str("res://Scenes/Levels/" + levelID + ".tscn"))
	level = levelScene.instance()
	
	$Level.add_child(level)
	level.connect("changeLevel", self, "_onLevelChange")
	
	level.wentBack = wentBack
	
	level.prevLevel = prevLevel
	level.gui = $CanvasLayer/GUI
	
	$CanvasLayer/LoadingScreen.loadLevel(dimension, level, prevLevel, $CanvasLayer/GUI, firstLoad)
	yield($CanvasLayer/LoadingScreen, "loadingFinished")
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	if not prevLoaded.has(level):
		prevLoaded.append(level)
	
	prevLevel = level
	level = null
	
	locked = false

func _onLevelChange(level, dimension, wentBack):
	lastPositions[self.prevLevel.levelID] = self.prevLevel.player.prevPos
	loadLevel(level, dimension, wentBack)

func destroyLevel():
	if prevLevel != null: prevLevel.queue_free()

func saveGame(file):
	print("Saving")

func loadGame(file):
	print("Loading")

func _onExit():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	prevLevel.unload()
	destroyLevel()
	
	get_tree().change_scene("res://Scenes/GUI/MainMenu.tscn")
	queue_free()
