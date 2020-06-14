extends Node2D

onready var def = get_node("/root/Definitions")

export (String) var itemName
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, SpriteFrames) var textures

func _ready():
	connect("body_entered", self, "_onPickup")

func _onPickup(body):
	if "Player" in body.name:
		body.itemAction(self)
		queue_free()

func changeDimension(dimension):
	if dimension & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		
		if textures.size() > def.logB(dimension, 2):
			$AnimatedSprite.frames = textures[def.logB(dimension, 2)]
	else:
		hide()
		$CollisionShape2D.disabled = true;
