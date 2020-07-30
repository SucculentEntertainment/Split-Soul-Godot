extends Control

signal loadingFinished
onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()
var loading = false

func loadLevel(variant, level, prevLevel, gui, firstLoad = false):
	if loading: return
	
	loading = true
	
	rng.randomize()
	var i = rng.randi_range(0, def.LOADING_SCREEN_MESSAGES.size() - 1)
	$VBoxContainer/Label.text = def.LOADING_SCREEN_MESSAGES[i]
	
	show()
	$AnimationPlayer.play(variant)
	
	$TransitionShader/AnimationPlayer.play("Open")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	#yield(get_tree().create_timer(2.0), "timeout")
	
	if prevLevel != null:
		prevLevel.unload()
		prevLevel.queue_free()
	
	level.loadLevel(firstLoad)
	level.changeDimension(variant)
	
	#yield(get_tree().create_timer(2.0), "timeout")
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	hide()
	loading = false
	emit_signal("loadingFinished")
