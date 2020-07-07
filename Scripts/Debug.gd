extends Control

var player = null

func _ready():
	pass

func toggle():
	if visible:
		hide()
	else:
		show()

func givePlayerReference(player):
	self.player = player

func _process(delta):
	$PlayerPos.text = str(player.get_position())
