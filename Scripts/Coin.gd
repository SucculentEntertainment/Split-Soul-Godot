extends Node2D

func _ready():
	connect("body_entered", self, "_onPickup")

func _onPickup(body):
	if "Player" in body.name:
		body.addCoin()
		queue_free()
