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
export (int) var longRangeMin
export (int) var longRangeMax

export (String) var projectile

var health = 0

var damageCooldown = false
var movementCooldown = false

var initializedMove = false
var spawnedLoot = false

var player = null
var dir = Vector2()
var vel = Vector2()

var instancedProjectile = null
var projectileCooldown = false

var transTarget = ""

enum {
	IDLE,
	MOVE,
	ATTACK,
	DEAD,
	TRANS_INIT,
	TRANS
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
	$ProjectileCooldown.connect("timeout", self, "_onProjectileTimeout")

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if def.getDimensionLayer(dimension) & layer != 0:
		show()
		$CollisionShape2D.set_deferred("disabled", false)
		$Sprite.region_rect.position.y = dimensionOffsets[def.getDimensionIndex(dimension)]
	else:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)

func setType(_type):
	pass

func updateInterest():
	var bodies = $Alerter.get_overlapping_bodies()
	for body in bodies:
		if "Player" in body.name:
			player = body
			if state == IDLE: state = MOVE
			$Interest.start()
			return 0
	return -1

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
		TRANS_INIT:
			transInit()
		TRANS:
			trans()

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
	if player == null: return
	
	$AnimationTree.get("parameters/playback").travel("Move")
	
	var dist = self.global_position.distance_to(player.global_position)
	var atkRange = closeRange
	if canLongRange: atkRange = longRangeMax
	
	if movementCooldown or !useMovementCooldown:
		dir = self.global_position.direction_to(player.global_position)
		initializedMove = false
		
		if canLongRange and dist < longRangeMin:
			dir = -dir
		
		$AnimationTree.set("parameters/Idle/blend_position", dir)
		$AnimationTree.set("parameters/Move/blend_position", dir)
		$AnimationTree.set("parameters/Attack/blend_position", dir)
	
	if dist > atkRange or (canLongRange and dist < longRangeMin):
		if useMovementCooldown: initializedMove = true
		else: move(delta)
	
	if dist <= atkRange:
		if !useMovementCooldown or (useMovementCooldown and !initializedMove): state = ATTACK
	
	if useMovementCooldown and initializedMove: move(delta)

func attack(delta):
	if canLongRange and projectileCooldown:
		state = MOVE
		return
	
	$AnimationTree.get("parameters/playback").travel("Attack")

func attackEnd():
	updateInterest()
	state = MOVE

func spawnProjectile():
	if !canLongRange: return
	if player == null: return
	if projectileCooldown: return
	
	projectileCooldown = true
	$ProjectileCooldown.start()
	
	var dir = self.global_position.direction_to(player.global_position)
	var spawnHelper = player.get_parent().get_node("SpawnHelper")
	
	instancedProjectile = spawnHelper.spawn(projectile, self.global_position, Vector2(0.5, 0.5), "", player.get_parent().currentDimensionID, true)
	instancedProjectile.init(dir, false)

func shootProjectile():
	if !canLongRange: return
	if instancedProjectile == null: return
	instancedProjectile.enableMovement()

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
	if updateInterest() == -1:
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

func _onProjectileTimeout():
	projectileCooldown = false

func changeType(id):
	var spawnHelper = get_parent().get_parent().get_node("SpawnHelper")
	var obj = spawnHelper.call_deferred("spawn", id, position, scale, "", spawnHelper.get_parent().currentDimensionID, true)
	get_parent().remove_child(self)
	queue_free()

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

func generateItems():
	var chances = []
	var items = []
	var counter = 0
	
	var numItems = rng.randi_range(0, def.LOOTTABLES[id].numItems)
	
	
	for item in def.LOOTTABLES[id].items:
		if counter >= 100: break
		
		chances.append({"id": item.id, "min": counter, "max": counter + item.chance})
		counter += item.chance
	
	for i in range(1, numItems):
		var n = rng.randi_range(0, 100)
		var id = ""
		
		for c in chances:
			if n >= c.min and n < c.max:
				id = c.id
				break
		
		if id == "": return null
		items.append(id)
	
	return items

func die():
	$CollisionShape2D.disabled = true
	$AnimationTree.get("parameters/playback").travel("Death")
	
	if spawnedLoot == true: return
	spawnedLoot = true
	
	# Spawn Item
	var spawnHelper = get_parent().get_parent().get_node("SpawnHelper")
	
	var items = generateItems()
	while items.empty(): items = generateItems()
	
	for i in items:
		if i == "none": continue
		
		var obj = spawnHelper.spawn("p_itemStack", position, Vector2(0.25, 0.25), "", "", true)
		obj.setType(i, 1)

func deadAnimEnd():
	get_parent().remove_child(self)
	queue_free()

# ================================
# Transitions
# ================================

func transInit():
	$AnimationTree.get("parameters/playback").travel("Transition_Init")

func trans():
	$AnimationTree.get("parameters/playback").travel("Transition_" + transTarget)

func _transInitEnd():
	state = TRANS

func _transitionEnd():
	changeType("e_" + transTarget + "Slime")
