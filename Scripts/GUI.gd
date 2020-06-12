extends Control

signal receiveDamage(damage)

func _ready():
	$Damage.connect("button_down", self, "_onDamageDown")

func updateHealth(health):
	$HealthBar.value = health

func _onDamageDown():
	emit_signal("receiveDamage", 10)
