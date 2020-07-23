extends Control

signal loadingFinished
onready var def = get_node("/root/Definitions")

func start(variant, level, gui):
	show()
	$AnimationPlayer.play(variant)
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	level.loadLevel()
	
	level.initPlayer(gui)
	level.changeDimension(variant)
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	hide()
	emit_signal("loadingFinished")
