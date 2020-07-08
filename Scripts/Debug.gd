extends Control

var player = null
var spawnHelper = null

func _ready():
	pass

func toggle():
	if visible:
		hide()
	else:
		show()

func givePlayerReference(player):
	self.player = player
	spawnHelper = player.get_parent().get_node("SpawnHelper")

func _process(delta):
	$PlayerPos.text = str(player.get_position()) + "\n" + str(spawnHelper.posToCoords(player.get_position()))
