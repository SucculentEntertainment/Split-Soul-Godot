extends Control

onready var def = get_node("/root/Definitions")

onready var chatlog = get_node("VBoxContainer/Panel/RichTextLabel")
onready var input = get_node("VBoxContainer/HBoxContainer/LineEdit")

var player = null

# ================================
# Util
# ================================

func _ready():
	input.connect("text_entered", self, "text_entered")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if visible: toggle()

func givePlayerReference(player):
	self.player = player

func toggle():
	if visible:
		hide()
		player.disableIn = false
		input.grab_focus()
	else:
		show()
		player.disableIn = true
		input.release_focus()

func sendCommand(command):
	chatlog.bbcode_text += "[color=#999999]> " + command + "[/color]\n" 

	if player != null: parseCommand(command)


func text_entered(text):
	if text != "":
		sendCommand(text)
		input.text = ""

# ================================
# Commands
# ================================

func parseCommand(rawCommand):
	var command = rawCommand.split(" ", false)
	
	if command[0] == "/help":
		chatlog.bbcode_text += "Help Page\n" 
		
	elif command[0] == "/dimension":
		if command.size() != 2:
			chatlog.bbcode_text += "[color=#FF001D]Invalid arguments[/color]\n"
		else:
			if def.DIMENSION_NAMES.has(command[1]):
				player.changeDimension(pow(2, def.DIMENSION_NAMES.find(command[1])))
				chatlog.bbcode_text += "Changed Dimension to: " + command[1] + "\n"
			else:
				chatlog.bbcode_text += "[color=#FF001D]Invalid dimension: " + command[1] + "[/color]\n"
				
	elif command[0] == "/kill":
		player._onReceiveDamage(999)
		chatlog.bbcode_text += "Killed Player \n"
		
	elif command[0] == "/damage":
		if command.size() != 2:
			chatlog.bbcode_text += "[color=#FF001D]Invalid arguments[/color]\n"
		else:
			if command[1].is_valid_integer():
				player._onReceiveDamage(int(command[1]))
				chatlog.bbcode_text += "Dealt " + command[1] + " Damage to Player \n"
			else:
				chatlog.bbcode_text += "[color=#FF001D]Inavlid amount: " + command[1] + "[/color]\n"
				
	else:
		chatlog.bbcode_text += "[color=#FF001D]Command not found[/color]\n"
