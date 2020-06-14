extends KinematicBody2D

signal changeDimension(dimension)

export (int) var speed = 10000
export (int) var maxHealth = 100
export (Array, SpriteFrames) var textures

onready var def = get_node("/root/Definitions")

var health = maxHealth
var coins = 0
var dead = false

var interact = null

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
	getInput()
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
	emit_signal("changeDimension", dimension)
	$CollisionShape2D.disabled = false;
	
	if textures.size() > def.logB(dimension, 2):
		$AnimatedSprite.frames = textures[def.logB(dimension, 2)]

func getInput():
	if Input.is_action_just_pressed("ctrl_interact"):
		if interact != null: interact.interact(self)

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
	changeDimension(def.DIMENSION_DEAD)
	health = maxHealth
