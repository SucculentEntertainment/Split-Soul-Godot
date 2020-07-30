extends Control

signal menuClosed

onready var def = get_node("/root/Definitions")
onready var main = get_parent().get_parent()

func _ready():
	$BlurShader/AnimationPlayer.play("FadeInInstant")
	$TransitionShader/AnimationPlayer.play("Open")
	
	$UI/Continue.connect("button_down", self, "_onContinue")
	$UI/NewGame.connect("button_down", self, "_onNewGame")
	$UI/LoadGame.connect("button_down", self, "_onLoadGame")
	$UI/Options.connect("button_down", self, "_onOptions")
	$UI/Credits.connect("button_down", self, "_onCredits")
	$UI/Exit.connect("button_down", self, "_onExit")

func _onContinue():
	quitMenu()

func _onNewGame():
	main.loadLevel("l_test", "d_alive", false, true)
	quitMenu()

func _onLoadGame():
	$LoadDialog.init(main)
	$LoadDialog.toggle()
	
	yield($LoadDialog, "finished")
	quitMenu()

func _onOptions():
	pass

func _onCredits():
	pass

func _onExit():
	get_tree().quit()

func quitMenu():
	$BlurShader/AnimationPlayer.play("FadeOutInstant")
	yield($BlurShader/AnimationPlayer, "animation_finished")
	emit_signal("menuClosed")
