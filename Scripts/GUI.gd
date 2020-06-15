extends Control

var player

func _ready():
	pass

func updateValues(health, coins):
	$HealthBar.changeHealth(health)
	$Coins.changeAmount(coins)
