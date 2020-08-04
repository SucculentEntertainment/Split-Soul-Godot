extends Control

signal exitToMenu
signal saveFinished

var savedTime = OS.get_datetime()
var gui = null

func _ready():
	gui = get_parent()
	
	$VBoxContainer/Continue.connect("button_down", self, "_onContinue")
	$VBoxContainer/Save.connect("button_down", self, "_onSave")
	$VBoxContainer/Load.connect("button_down", self, "_onLoad")
	$VBoxContainer/Settings.connect("button_down", self, "_onSettings")
	$VBoxContainer/Exit.connect("button_down", self, "_onExit")

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		toggle()

func toggle(noBlur = false):
	if visible:
		hide()
		get_tree().paused = false
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		if gui.player != null:
			gui.player.disableIn = false
			gui.player.disableAllIn = false
		
		if !noBlur:
			get_parent().get_node("BlurShader/AnimationPlayer").play("FadeOutFast")
	else:
		show()
		get_tree().paused = true
		
		if gui.player != null:
			gui.player.disableIn = true
			gui.player.disableAllIn = true
		
		if !noBlur:
			get_parent().get_node("BlurShader/AnimationPlayer").play("FadeInFast")

func _onContinue():
	toggle()

func _onSave():
	var diag = gui.get_node("Dialogs/SaveDialog")
	diag.init(gui.get_parent().get_parent())
	diag.toggle()
	
	yield(diag, "finished")
	if diag.saved:
		savedTime = OS.get_datetime()
	
	emit_signal("saveFinished")

func _onLoad():
	var diag = gui.get_node("Dialogs/LoadDialog")
	diag.init(gui.get_parent().get_parent())
	diag.toggle()
	
	yield(diag, "finished")
	get_tree().paused = false

func _onSettings():
	pass

func _onExit():
	if savedTime.minute != OS.get_datetime().minute:
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
	
	toggle(true)
	emit_signal("exitToMenu")
