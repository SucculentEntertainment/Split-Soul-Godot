extends Control

signal startedLoading

onready var def = get_node("/root/Definitions")
onready var transition = get_parent().get_parent().get_node("TransitionShader/AnimationPlayer")
var rng = RandomNumberGenerator.new()

func start(variant):
	rng.randomize()
	var i = rng.randi_range(0, def.LOADING_SCREEN_MESSAGES.size() - 1)
	$VBoxContainer/Label.text = def.LOADING_SCREEN_MESSAGES[i]
	
	transition.play("Close")
	yield(transition, "animation_finished")
	
	if variant == null:
		variant = "d_alive"
	
	show()
	$AnimationPlayer.play(variant)
	
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("startedLoading")

func end():
	yield(get_tree().create_timer(0.5), "timeout")
	
	hide()
	transition.play("Open")
	yield(transition, "animation_finished")
