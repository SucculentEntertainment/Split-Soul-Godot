extends KinematicBody2D

onready var def = get_node("/root/Definitions")

var rng = RandomNumberGenerator.new()

export (String) var id

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

export (int) var maxHealth = 100
export (int) var speed = 500
export (int) var damage = 5
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, int) var dimensionOffsets

export (bool) var canSpawn
export (bool) var useMovementCooldown
export (bool) var canLongRange

export (int) var closeRange
export (int) var longRange

var health = 0

var damageCooldown = false
var movementCooldown = false

var player = null
var dir = Vector2()
var vel = Vector2()

enum {
	IDLE,
	MOVE,
	ATTACK,
	DEAD
}

var state = IDLE

var maxAnimOffset = 1

# ================================
# Util
# ================================

func _ready():
	health = maxHealth
	$HealthBar.changeHealth(health, maxHealth)
	
	$AnimationTree.active = true
	$AnimationTree.get("parameters/playback").start("Idle")
	
	rng.randomize()
	$AnimationTree.advance(rng.randf_range(0.0, maxAnimOffset))
	
	$Alerter.connect("body_entered", self, "_onAwakened")
	$Interest.connect("timeout", self, "_onInterestLoss")
	
	$Hitbox.connect("area_entered", self, "_onGiveDamage")
	$Hitbox/Timer.connect("timeout", self, "_onDamageTimeout")

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if def.getDimensionLayer(dimension) & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		$Sprite.region_rect.position.y = dimensionOffsets[def.getDimensionIndex(dimension)]
	else:
		hide()
		$CollisionShape2D.disabled = true;

func setType(_type):
	pass

func updateInterest():
	var bodies = $Alerter.get_overlapping_bodies()
	for body in bodies:
		if "Player" in body.name:
			player = body
			state = MOVE
			$Interest.start()

# ================================
# Movement
# ================================

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		MOVE:
			targetPlayer(delta)
		ATTACK:
			attack(delta)
		DEAD:
			die()

func move(delta):
	if !movementCooldown:
		vel = dir * speed * delta
		vel = move_and_slide(vel)


func moveCooldownStart():
	if useMovementCooldown:
		movementCooldown = true

func moveCooldownEnd():
	if useMovementCooldown:
		movementCooldown = false

# ================================
# Idle
# ================================

func idle(delta):
	$AnimationTree.get("parameters/playback").travel("Idle")

# ================================
# Attack
# ================================

func targetPlayer(delta):
	$AnimationTree.get("parameters/playback").travel("Move")
	
	if !canLongRange:
		if movementCooldown or !useMovementCooldown:
			dir = self.global_position.direction_to(player.global_position)
		
			$AnimationTree.set("parameters/Idle/blend_position", dir)
			$AnimationTree.set("parameters/Move/blend_position", dir)
			$AnimationTree.set("parameters/Attack/blend_position", dir)
		
		if self.global_position.distance_to(player.global_position) > closeRange:
			move(delta)
		else:
			state = ATTACK
		
		updateInterest()
	else:
		state = IDLE

func attack(delta):
	$AnimationTree.get("parameters/playback").travel("Attack")

func attackEnd():
	state = IDLE

# ================================
# Events
# ================================

func _onAwakened(body):
	if "Player" in body.name:
		$AudioStreamPlayer.play()
		$Alert.show()
		
		state = MOVE
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
