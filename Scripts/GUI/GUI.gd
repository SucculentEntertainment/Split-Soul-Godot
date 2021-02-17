extends Control

onready var vars = get_node("/root/PlayerVars")
var player = null

var isInDialog = false

func _ready():
	$BlurShader/AnimationPlayer.play("FadeOutInstant")

func _input(_event):
	if Input.is_action_just_pressed("ctrl_attack_primary"):
		if isInDialog:
			isInDialog = false
			player.disableIn = false
			$DialogBox.hide()

func givePlayerReference(player):
	self.player = player
	$Console.givePlayerReference(player)
	$Inventory.givePlayerReference(player)
	$Debug.givePlayerReference(player)

func updateValues(maxHealth, maxMana, maxStamina):
	$HealthBar.changeValue(vars.health, maxHealth)
	$ManaStamina.changeValue(vars.health, maxHealth)
	$Coins.changeAmount(vars.coins)
	$SoulPoints.changeAmount(vars.soulpoints)

func createDialog(personName, dialogText):
	isInDialog = true
	player.disableIn = true
	$DialogBox.show()
	
	$DialogBox.setName(personName)
	$DialogBox.setText(dialogText)
