extends KinematicBody2D

export (int) var maxHealth = 100
export (int) var speed = 500
export (int) var damage = 5
export (bool) var canChange = true

var health = maxHealth

func _ready():
	$HealthBar.max_value = maxHealth
	$HealthBar.value = health
	
	$AliveSprite.frame = 0
	$DeadSprite.frame = 0

func _onReceiveDamage(damage):
	health -= damage
	$HealthBar.value = health
	
	if health <= 0: die()

func changeDimension():
	if canChange:
		if $AliveSprite.visible:
			$AliveSprite.hide()
			$DeadSprite.show()
		else:
			$AliveSprite.show()
			$DeadSprite.hide()

func die():
	queue_free()
