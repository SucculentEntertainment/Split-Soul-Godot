extends Control

signal exitToMenu

var savedPos = Vector2()

func _ready():
	$VBoxContainer/Continue.connect("button_down", self, "_onContinue")
	$VBoxContainer/Save.connect("button_down", self, "_onSave")
	$VBoxContainer/Load.connect("button_down", self, "_onLoad")
	$VBoxContainer/Settings.connect("button_down", self, "_onSettings")
	$VBoxContainer/Exit.connect("button_down", self, "_onExit")

func toggle():
	if visible:
		hide()
		get_parent().get_node("BlurShader/AnimationPlayer").play("FadeOutFast")
	else:
		show()
		get_parent().get_node("BlurShader/AnimationPlayer").play("FadeInFast")

func _onContinue():
	Input.action_press("ui_cancel")
	yield(get_tree().create_timer(0.01), "timeout")
	Input.action_release("ui_cancel")

func _onSave():
	pass

func _onLoad():
	pass

func _onSettings():
	pass

func _onExit():
	if savedPos != get_parent().player.global_position:
		var sel = get_parent().notSavedDialog()
		print(sel)
	
	get_tree().paused = false
	emit_signal("exitToMenu")
