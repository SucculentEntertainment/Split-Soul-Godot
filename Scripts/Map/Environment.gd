extends StaticBody2D

onready var def = get_node("/root/Definitions")
var rng = RandomNumberGenerator.new()

export (String) var objectName
export (int, FLAGS, "d_alive", "d_dead") var layer
export (bool) var hasCollision

var animSpeedMin = 0.8
var animSpeedMax = 1.2

func _ready():
	rng.randomize()
	$CollisionShape2D.disabled = !hasCollision
	
	$AnimationPlayer.play("Idle")
	$AnimationPlayer.seek(rng.randf_range(0.0, $AnimationPlayer.current_animation_length))
	$AnimationPlayer.playback_speed = rng.randf_range(animSpeedMin, animSpeedMax)

func setType(_type):
	pass

func changeDimension(dimension):
	if def.getDimensionLayer(dimension) & layer != 0:
		show()
		if hasCollision: $CollisionShape2D.disabled = false
	else:
		hide()
		$CollisionShape2D.disabled = true
