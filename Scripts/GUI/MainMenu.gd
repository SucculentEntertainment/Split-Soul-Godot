extends Control

onready var def = get_node("/root/Definitions")

func _ready():
	$BlurShader/AnimationPlayer.play("FadeInFast")
	$TransitionShader/AnimationPlayer.play("Open")
	
	$UI/Continue.connect("button_down", self, "_onContinue")
	$UI/NewGame.connect("button_down", self, "_onNewGame")
	$UI/LoadGame.connect("button_down", self, "_onLoadGame")
	$UI/Options.connect("button_down", self, "_onOptions")
	$UI/Credits.connect("button_down", self, "_onCredits")
	$UI/Exit.connect("button_down", self, "_onExit")

func _onContinue():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")

func _onNewGame():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()

func _onLoadGame():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")

func _onOptions():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")

func _onCredits():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")

func _onExit():
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	get_tree().quit()
