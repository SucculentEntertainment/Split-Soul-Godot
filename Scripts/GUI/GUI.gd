extends Control

onready var vars = get_node("/root/PlayerVars")
var player

var isInDialog = false
var notSavedDiagSel = ""

func _ready():
	$BlurShader/AnimationPlayer.play("FadeOutInstant")
	
	$NotSavedDialog.connect("selected", self, "_onNotSavedDiagSel")
	$NotSavedDialog.mouse_filter = MOUSE_FILTER_IGNORE

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

func updateValues(maxHealth):
	$HealthBar.changeHealth(vars.health, maxHealth)
	$Coins.changeAmount(vars.coins)
	$SoulPoints.changeAmount(vars.soulpoints)

func createDialog(personName, dialogText):
	isInDialog = true
	player.disableIn = true
	$DialogBox.show()
	
	$DialogBox.setName(personName)
	$DialogBox.setText(dialogText)

func notSavedDialog():
	$NotSavedDialog.show()
	$NotSavedDialog.mouse_filter = MOUSE_FILTER_STOP
	
	yield($NotSavedDialog, "selected")
	
	$NotSavedDialog.mouse_filter = MOUSE_FILTER_IGNORE
	$NotSavedDialog.hide()
	
	return notSavedDiagSel


func _onNotSavedDiagSel(selection):
	notSavedDiagSel = selection
