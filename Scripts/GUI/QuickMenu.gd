extends Control

signal exitToMenu
signal saveFinished

var savedPos = Vector2()
var gui = null

func _ready():
	gui = get_parent()
	
	$VBoxContainer/Continue.connect("button_down", self, "_onContinue")
	$VBoxContainer/Save.connect("button_down", self, "_onSave")
	$VBoxContainer/Load.connect("button_down", self, "_onLoad")
	$VBoxContainer/Settings.connect("button_down", self, "_onSettings")
	$VBoxContainer/Exit.connect("button_down", self, "_onExit")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		_onContinue()

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
	var diag = gui.get_node("Dialogs/SaveDialog")
	diag.init(gui)
	diag.toggle()
	
	savedPos = get_parent().player.global_position
	
	yield(diag, "finished")
	emit_signal("saveFinished")

func _onLoad():
	var diag = gui.get_node("Dialogs/LoadDialog")
	diag.init(gui)
	diag.toggle()
	
	yield(diag, "finished")

func _onSettings():
	pass

func _onExit():
	if savedPos != get_parent().player.global_position:
		var diag = gui.get_node("Dialogs/NotSavedDialog")
		diag.toggle()
		
		yield(diag, "selected")
		var sel = diag.selection
		
		diag.toggle()
		
		match sel:
			"cancel":
				return
			"yes":
				_onSave()
				yield(self, "saveFinished")
			"no":
				pass
	
	get_tree().paused = false
	emit_signal("exitToMenu")
