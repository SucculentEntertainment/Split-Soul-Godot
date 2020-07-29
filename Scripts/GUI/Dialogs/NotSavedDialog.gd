extends Control

signal selected
var selection = ""

func _ready():
	$Panel/VBoxContainer/HBoxContainer/Yes.connect("button_down", self, "_onYes")
	$Panel/VBoxContainer/HBoxContainer/No.connect("button_down", self, "_onNo")
	$Panel/VBoxContainer/HBoxContainer/Cancel.connect("button_down", self, "_onCancel")

func toggle():
	if visible:
		hide()
		mouse_filter = MOUSE_FILTER_IGNORE
	else:
		show()
		mouse_filter = MOUSE_FILTER_STOP

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		_onCancel()

func _onYes():
	selection = "yes"
	emit_signal("selected")
	hide()

func _onNo():
	selection = "no"
	emit_signal("selected")
	hide()

func _onCancel():
	selection = "cancel"
	emit_signal("selected")
	hide()
