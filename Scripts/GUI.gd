extends Control

signal receiveDamage(damage)
signal giveDamage(damage)

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

func _ready():
	$Damage.connect("button_down", self, "_onDamageDown")
	$EnemyDmg.connect("button_down", self, "_onEnemyDamageDown")

func updateValues(health, coins):
	if $HealthBar.value != health:
		$HealthBar.value = health
		$HealthEase.interpolate_property($HealthBarWhite, "value", $HealthBarWhite.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$HealthEase.start()
	
	if health < 25: $HealthBar.tint_progress = critical
	elif health < 50: $HealthBar.tint_progress = damaged
	else: $HealthBar.tint_progress = healthy
	
	$Coins/Label.text = str(coins)

func _onDamageDown():
	emit_signal("receiveDamage", 10)

func _onEnemyDamageDown():
	emit_signal("giveDamage", 10)
