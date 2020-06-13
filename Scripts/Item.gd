extends Node2D

export (String) var itemName
export (int, FLAGS, "Alive", "Dead") var layer

func _ready():
	connect("body_entered", self, "_onPickup")

func _onPickup(body):
	if "Player" in body.name:
		body.itemAction(self)
		queue_free()

func updateDimension(dimension):
	if dimension & layer == 1:
		$CollisionShape2D.disabled = false;
	else:
		$CollisionShape2D.disabled = true;
