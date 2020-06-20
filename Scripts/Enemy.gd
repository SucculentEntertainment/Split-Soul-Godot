extends KinematicBody2D

onready var def = get_node("/root/Definitions")

export (String) var enemyName

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

export (int) var maxHealth = 100
export (int) var speed = 500
export (int) var damage = 5
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, Texture) var textures

export (bool) var canSpawn
export (bool) var useMovementCooldown
export (bool) var longRange

var health

var damageCooldown = false
var movementCooldown = false

var player = null
var dir = Vector2()
var vel = Vector2()

enum {
	IDLE,
	ATTACK,
	DEAD
}

var state = IDLE

# ================================
# Util
# ================================

func _ready():
	health = maxHealth
	$HealthBar.changeHealth(health, maxHealth)
	
	$Alerter.connect("body_entered", self, "_onAwakened")
	$Interest.connect("timeout", self, "_onInterestLoss")
	
	$Hitbox.connect("area_entered", self, "_onGiveDamage")
	$Hitbox/Timer.connect("timeout", self, "_onDamageTimeout")
	$Hurtbox.connect("area_entered", self, "_onReceiveDamage")
	$MoveTimer.connect("timeout", self, "_onMovementTimeout")
	
	$AnimationTree.get("parameters/playback").start("Jump")

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if dimension & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		
		if textures.size() > def.logB(dimension, 2):
			$Sprite.texture = textures[def.logB(dimension, 2)]
			pass
	else:
		hide()
		$CollisionShape2D.disabled = true;

func updateInterest():
	var bodies = $Alerter.get_overlapping_bodies()
	for body in bodies:
		if "Player" in body.name:
			player = body
			state = ATTACK
			$Interest.start()

# ================================
# Movement
# ================================

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		ATTACK:
			attack(delta)
		DEAD:
			die()

func move(delta):
	if !movementCooldown:
		vel = dir * speed * delta
		vel = move_and_slide(vel)
		
		if useMovementCooldown:
			movementCooldown = true
			$MoveTimer.start()

# ================================
# Idle
# ================================

func idle(delta):
	pass

# ================================
# Attack
# ================================

func attack(delta):
	if !longRange:
		dir = self.global_position.direction_to(player.global_position)
		move(delta)
		updateInterest()

# ================================
# Events
# ================================

func _onAwakened(body):
	if "Player" in body.name:
		$AudioStreamPlayer.play()
		$Alert.show()
		
		state = ATTACK
		player = body
		$Interest.start()

func _onInterestLoss():
	player = null
	state = IDLE
	$Alert.hide()

func _onDamageTimeout():
	damageCooldown = false
	
	var areas = $Hitbox.get_overlapping_areas()
	for area in areas:
		var body = area.get_parent()
		
		if body != null and "Player" in body.name:
			_onGiveDamage(area)

func _onMovementTimeout():
	movementCooldown = false

# ================================
# Damage
# ================================

func receiveDamage(damage):
	health -= damage
	$HealthBar.changeHealth(health, maxHealth)
	if health <= 0: state = DEAD

func _onGiveDamage(area):
	if "Hurtbox" in area.name and !damageCooldown and state != DEAD:
		var body = area.get_parent()
		if body != null and "Player" in body.name:
			body._onReceiveDamage(damage)
			damageCooldown = true
			$Hitbox/Timer.start()

func die():
	$CollisionShape2D.disabled = true
	$AnimationTree.get("parameters/playback").travel("Death")

func deadAnimEnd():
	queue_free()
