extends Node2D

export (String) var itemName

var hasAttacked = false
var isCharging = false

var obj = null

func _ready():
	$Cooldown.connect("timeout", self, "_onCooldown")

func charge():
	if isCharging: return
	isCharging = true
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			var spawnHelper = player.get_parent().get_node("SpawnHelper")
			
			obj = spawnHelper.spawn("r_fireBall", player.get_position(), Vector2(0.5, 0.5), "", player.get_parent().currentDimensionID, true)
			obj.init(dir, false)
		

func attack(player):
	if hasAttacked: return
	
	isCharging = false
	hasAttacked = true
	$Cooldown.start()
	
	match itemName:
		"i_fireWand":
			obj.allowMovement = true

func _onCooldown():
	hasAttacked = false
