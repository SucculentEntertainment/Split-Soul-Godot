extends Node2D

func _ready():
	$FireBall.init($FireBall.position.direction_to($Player.position))
