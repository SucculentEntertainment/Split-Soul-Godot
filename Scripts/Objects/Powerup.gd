extends Node2D

onready var def = get_node("/root/Definitions")

export (String) var id
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, int) var dimensionOffsets

var health = -1

func _ready():
	$AnimationPlayer.play("Idle")
	connect("area_entered", self, "_onPickup")

func _onPickup(area):
	if "Interactions" in area.name:
		var body = area.get_parent()
		
		if body != null and "Player" in body.name:
			body.itemAction(self)
			queue_free()

func changeDimension(dimension):
	if def.getDimensionLayer(dimension) & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		
		$Sprite.region_rect.position.y = dimensionOffsets[def.getDimensionIndex(dimension)]
	else:
		hide()
		$CollisionShape2D.disabled = true;

func setType(_type):
	pass
