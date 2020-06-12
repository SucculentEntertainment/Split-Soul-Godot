extends KinematicBody2D

const normalSpritesheet = preload("res://Sprites/PlayerNormal.png")
const deadSpritesheet = preload("res://Sprites/PlayerDead.png")

signal died

export (float) var speed = 10000
export (int) var maxHealth = 100

var health = maxHealth
var dead = false

var coins = 0

var dir = Vector2()
var vel = Vector2()

func _ready():
	$GUI/Main/HealthBar.max_value = maxHealth
	$GUI/Main/HealthBar.value = maxHealth
	
	$GUI/Main.connect("receiveDamage", self, "_onReceiveDamage")

func _physics_process(delta):
	move(delta)

func getMoveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()

func move(delta):
	getMoveInput()
	if dir == Vector2(): vel = Vector2()
	else: vel = dir * speed * delta
	vel = move_and_slide(vel)

func addCoin():
	coins += 1
	$GUI/Main.updateCoins(coins)

func _onReceiveDamage(damage):
	health -= damage
	if health <= 0 and !dead: die()
	if health <= 0 and dead:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	
	$GUI/Main.updateHealth(health)

func die():
	dead = true
	emit_signal("died")
	health = maxHealth
	$AliveSprite.hide()
	$DeadSprite.show()
