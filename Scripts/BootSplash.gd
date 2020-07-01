extends ColorRect

func _ready():
	$AnimationPlayer.play("BootAnim")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()
