extends Control

var player

func _ready():
	pass

func givePlayerReference(player):
	self.player = player
	$Console.givePlayerReference(player)

func updateValues(health, coins):
	$HealthBar.changeHealth(health)
	$Coins.changeAmount(coins)
