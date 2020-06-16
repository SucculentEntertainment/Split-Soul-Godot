extends Control

onready var vars = get_node("/root/PlayerVars")
var player

func _ready():
	pass

func givePlayerReference(player):
	self.player = player
	$Console.givePlayerReference(player)

func updateValues(maxHealth):
	$HealthBar.changeHealth(vars.health, maxHealth)
	$Coins.changeAmount(vars.coins)
	$SoulPoints.changeAmount(vars.soulpoints)
