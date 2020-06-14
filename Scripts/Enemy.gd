extends KinematicBody2D

onready var def = get_node("/root/Definitions")

var dimensions = []
var highestDimension
var currentDimension = 1

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

export (int) var maxHealth = 100
export (int) var speed = 500
export (int) var damage = 5
export (int, FLAGS, "Alive", "Dead") var layer

var health = maxHealth

# ================================
# Util
# ================================

func _ready():
	$HealthBar.max_value = maxHealth
	_onReceiveDamage(0)
	
	for d in $Dimensions.get_children(): d.frame = 0
	
	highestDimension = getHighestDimension()

func getHighestDimension():
	for dimension in $Dimensions.get_children():
		dimensions.append(dimension)
	return 1 << (dimensions.size() - 1)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if dimension <= highestDimension and layer & dimension != 0:
		dimensions[def.logB(currentDimension, 2)].hide()
		dimensions[def.logB(dimension, 2)].show()
		currentDimension = dimension

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	health -= damage
	$HealthBar.value = health
	
	if health < 25: $HealthBar.tint_progress = critical
	elif health < 50: $HealthBar.tint_progress = damaged
	else: $HealthBar.tint_progress = healthy
	
	if health <= 0: die()

func die():
	$CollisionShape2D.disabled = true
	
	dimensions[def.logB(currentDimension, 2)].play("death")
	yield(dimensions[def.logB(currentDimension, 2)], "animation_finished")
	
	queue_free()
