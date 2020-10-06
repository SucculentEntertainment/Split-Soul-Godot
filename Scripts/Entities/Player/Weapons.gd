extends Node2D

export (String) var itemName

var hasAttacked = false

func _ready():
	$Cooldown.connect("timeout", self, "_onCooldown")

func attack(player):
	if hasAttacked: return
	
	hasAttacked = true
	$Cooldown.start()
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			var spawnHelper = player.get_parent().get_node("SpawnHelper")
			
			var obj = spawnHelper.spawn("r_fireBall", player.get_position(), Vector2(0.5, 0.5), "", player.get_parent().currentDimensionID, true)
			obj.init(dir)

func _onCooldown():
	hasAttacked = false
