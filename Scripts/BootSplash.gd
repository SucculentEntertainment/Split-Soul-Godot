extends ColorRect

onready var def = get_node("/root/Definitions")
export (bool) var skipLogo = false

func _ready():
	OS.window_fullscreen = def.CONFIG.get_value("video", "fullscreen")
	
	if !skipLogo:
		$AnimationPlayer.play("BootAnim")
		yield($AnimationPlayer, "animation_finished")
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()
