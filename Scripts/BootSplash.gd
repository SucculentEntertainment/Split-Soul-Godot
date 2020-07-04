extends ColorRect

export (bool) var skipLogo = false

func _ready():
	if !skipLogo:
		$AnimationPlayer.play("BootAnim")
		yield($AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()
