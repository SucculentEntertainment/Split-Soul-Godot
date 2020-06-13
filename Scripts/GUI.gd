extends Control

signal receiveDamage(damage)
signal giveDamage(damage)

func _ready():
	$Damage.connect("button_down", self, "_onDamageDown")
	$EnemyDmg.connect("button_down", self, "_onEnemyDamageDown")

func updateValues(health, coins):
	$HealthBar.value = health
	$Coins/Label.text = str(coins)

func _onDamageDown():
	emit_signal("receiveDamage", 10)

func _onEnemyDamageDown():
	emit_signal("giveDamage", 10)
