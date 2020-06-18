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
export (int) var jumpHeight

var health = maxHealth
var damageCooldown = false

# ================================
# Util
# ================================

func _ready():
	_onReceiveDamage(0)
	$Alerter.connect("body_entered", self, "_onAwakened")
	$AudioStreamPlayer.connect("finished", self, "_onAudioEnd")
	
	$Damager.connect("body_entered", self, "_onGiveDamage")
	$Damager/Timer.connect("timeout", self, "_onDamageTimeout")
	
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

# ================================
# Movement
# ================================

func _physics_process(delta):
	move()

func move():
	if enemyName == "Slime":
		pass

# ================================
# Events
# ================================

func _onAwakened(body):
	if "Player" in body.name:
		$AudioStreamPlayer.play()
		$Alert.show()

func _onAudioEnd():
	$Alert.hide()

func _onDamageTimeout():
	damageCooldown = false
	
	var bodies = $Damager.get_overlapping_bodies()
	for body in bodies:
		if "Player" in body.name:
			_onGiveDamage(body)

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	health -= damage
	$HealthBar.changeHealth(health, maxHealth)
	
	if health <= 0: die()

func _onGiveDamage(body):
	if "Player" in body.name and !damageCooldown:
		body._onReceiveDamage(damage)
		damageCooldown = true
		$Damager/Timer.start()

func die():
	$CollisionShape2D.disabled = true
	
	$AnimationTree.get("parameters/playback").travel("Death")
	yield($AnimationPlayer, "animation_finished")
	
	queue_free()
