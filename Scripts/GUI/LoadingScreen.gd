extends Control

signal loadingFinished
onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()

func start(variant, level, gui):
	rng.randomize()
	var i = rng.randi_range(0, def.LOADING_SCREEN_MESSAGES.size() - 1)
	$VBoxContainer/Label.text = def.LOADING_SCREEN_MESSAGES[i]
	
	show()
	$AnimationPlayer.play(variant)
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	level.loadLevel()
	
	level.initPlayer(gui)
	level.changeDimension(variant)
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	hide()
	emit_signal("loadingFinished")
