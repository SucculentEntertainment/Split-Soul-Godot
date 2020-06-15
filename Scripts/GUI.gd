extends Control

var player

func _ready():
	pass

func givePlayerReference(player):
	self.player = player
	$Console.givePlayerReference(player)

func updateValues(health, maxHealth, coins):
	$HealthBar.changeHealth(health, maxHealth)
	$Coins.changeAmount(coins)
