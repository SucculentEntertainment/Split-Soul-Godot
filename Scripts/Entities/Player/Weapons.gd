extends Node2D

export (String) var itemName
export (bool) var canHold

export (Array, int) var directionOffsets

var hasAttacked = false
var isCharging = false

var obj = null

func _ready():
	$Cooldown.connect("timeout", self, "_onCooldown")

func updateState(state):
	if "ATK_" in state:
		$AnimationTree.get("parameters/playback").travel("Attack")
		$AnimationTree.get("parameters/Attack/playback").travel(state.substr(4))
	else:
		$AnimationTree.get("parameters/playback").travel(state)

func updateDir(dir):
	$Sprite.region_rect.position.x = directionOffsets[dir]

func charge(player):
	if isCharging: return
	isCharging = true
	
	updateState("ATK_Hold")
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			var spawnHelper = player.get_parent().get_node("SpawnHelper")
			
			obj = spawnHelper.spawn("r_fireBall", player.get_position(), Vector2(0.5, 0.5), "", player.get_parent().currentDimensionID, true)
			obj.init(dir, false)
		

func attack(player):
	if hasAttacked: return
	
	updateState("ATK_Release")
	
	isCharging = false
	hasAttacked = true
	$Cooldown.start()
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			obj.changeDir(dir)
			obj.enableMovement()

func _onCooldown():
	hasAttacked = false
