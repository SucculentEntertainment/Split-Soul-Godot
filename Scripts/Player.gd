extends KinematicBody2D

signal changeDimension(dimension)

export (int) var speed = 10000
export (int) var maxHealth = 100

onready var def = get_node("/root/Definitions")

var health = maxHealth
var coins = 0
var dead = false

var dir = Vector2()
var vel = Vector2()

# ================================
# Utility
# ================================

func _ready():
	$GUI/Main/HealthBar.max_value = maxHealth
	$GUI/Main/HealthBar.value = maxHealth
	
	$GUI/Main.connect("receiveDamage", self, "_onReceiveDamage")

func _physics_process(delta):
	$GUI/Main.updateValues(health, coins)
	move(delta)

# ================================
# Movement
# ================================

func getMoveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()

func move(delta):
	getMoveInput()
	if dir == Vector2(): vel = Vector2()
	else: vel = dir * speed * delta
	vel = move_and_slide(vel)

# ================================
# Items
# ================================

func itemAction(item):
	if item.itemName == "Coin":
		coins += 1


# ================================
# Actions
# ================================

func changeDimension(dimension):
	pass

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	health -= damage
	if health <= 0:
		if !dead: die()
		else: get_tree().change_scene("res://Scenes/GameOver.tscn")

func _onGiveDamage(damage):
	pass

func die():
	dead = true
	emit_signal("changeDimension", def.DIMENSION_DEAD)
	health = maxHealth
	$AliveSprite.hide()
	$DeadSprite.show()
