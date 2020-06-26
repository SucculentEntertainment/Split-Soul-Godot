extends Control

var player = null

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if visible: toggle()

func givePlayerReference(player):
	self.player = player

func toggle():
	if visible:
		visible = false
		player.disableIn = false
	else:
		visible = true
		player.disableIn = true
