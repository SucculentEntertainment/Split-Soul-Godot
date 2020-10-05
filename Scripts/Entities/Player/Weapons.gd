extends Node2D

export (String) var itemName

func _ready():
	pass

func attack(player):
	match itemName:
		"i_fireWand":
			var dir = player.get_node("AnimationTree").get("parameters/Idle/blend_position")
			var spawnHelper = player.get_parent().get_node("SpawnHelper")
			
			var obj = spawnHelper.spawn("r_fireBall", player.get_position(), Vector2(1, 1), "", player.get_parent().currentDimensionID, true)
			obj.init(dir)
