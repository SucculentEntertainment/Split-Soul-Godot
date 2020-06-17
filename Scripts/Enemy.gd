extends KinematicBody2D

onready var def = get_node("/root/Definitions")

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

export (int) var maxHealth = 100
export (int) var speed = 500
export (int) var damage = 5
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, SpriteFrames) var textures

export (bool) var canSpawn

var health = maxHealth

# ================================
# Util
# ================================

func _ready():
	_onReceiveDamage(0)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if dimension & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		
		if textures.size() > def.logB(dimension, 2):
			$AnimatedSprite.frames = textures[def.logB(dimension, 2)]
	else:
		hide()
		$CollisionShape2D.disabled = true;

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	health -= damage
	$HealthBar.changeHealth(health, maxHealth)
	
	if health <= 0: die()

func die():
	$CollisionShape2D.disabled = true
	
	$AnimatedSprite.play("death")
	yield($AnimatedSprite, "animation_finished")
	
	queue_free()
