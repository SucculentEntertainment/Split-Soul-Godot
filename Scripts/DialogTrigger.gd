extends Area2D

onready var vars = get_node("/root/PlayerVars")
export (String) var personName
export (String) var dialogText

func _ready():
	connect("body_entered", self, "_onBodyEntered")

func _onBodyEntered(body):
	if "Player" in body.name:
		body.gui.createDialog(personName, dialogText)
