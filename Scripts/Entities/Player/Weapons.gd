extends Node2D

onready var def = get_node("/root/Definitions")

export (String) var itemName
export (bool) var canCharge

export (int, FLAGS, "Alive", "Dead") var layer

export (Array, Resource) var particles
export (Array, Color) var lightColors

var hasAttacked = false
var isCharging = false

var currDimension = "d_alive"

var obj = null

func _ready():
	$Cooldown.connect("timeout", self, "_onCooldown")

func charge(player):
	if !visible: return
	if !canCharge: return
	if isCharging: return
	
	isCharging = true
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			var spawnHelper = player.get_parent().get_node("SpawnHelper")
			
			obj = spawnHelper.spawn("r_fireBall", player.get_position(), Vector2(0.5, 0.5), "", player.get_parent().currentDimensionID, true)
			obj.init(dir, false)

func attack(player):
	if !visible: return
	if hasAttacked: return
	
	isCharging = false
	hasAttacked = true
	$Cooldown.start()
	
	match itemName:
		"i_fireWand":
			var dir = player.get_position().direction_to(get_global_mouse_position())
			obj.changeDir(dir)
			obj.enableMovement()

func changeDimension(dimension):
	currDimension = dimension
	
	if def.getDimensionLayer(dimension) & layer != 0:
		show()
		get_parent().get_node("WeaponHelper").changeDimension(dimension)
		
		if particles.size() > 0: $Effects/Particles2D.process_material = particles[def.getDimensionIndex(dimension)]
		if lightColors.size() > 0: $Effects/Light2D.color = lightColors[def.getDimensionIndex(dimension)]
	else:
		hide()

func _onCooldown():
	hasAttacked = false
