extends Control

signal loadingFinished
onready var def = get_node("/root/Definitions")

func start(variant, level, gui):
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
