extends Control

func _ready():
	$UI/Continue.connect("button_down", self, "_onContinue")
	$UI/NewGame.connect("button_down", self, "_onNewGame")
	$UI/LoadGame.connect("button_down", self, "_onLoadGame")
	$UI/Options.connect("button_down", self, "_onOptions")
	$UI/Credits.connect("button_down", self, "_onCredits")
	$UI/Exit.connect("button_down", self, "_onExit")

func _onContinue():
	pass

func _onNewGame():
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()

func _onLoadGame():
	pass

func _onOptions():
	pass

func _onCredits():
	pass

func _onExit():
	get_tree().quit()
