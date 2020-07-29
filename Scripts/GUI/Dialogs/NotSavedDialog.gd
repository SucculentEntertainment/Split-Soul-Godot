extends Control

signal selected(selection)

func _ready():
	$Panel/VBoxContainer/HBoxContainer/Yes.connect("button_down", self, "_onYes")
	$Panel/VBoxContainer/HBoxContainer/No.connect("button_down", self, "_onNo")
	$Panel/VBoxContainer/HBoxContainer/Cancel.connect("button_down", self, "_onCancel")

func _onYes():
	emit_signal("selected", "yes")
	hide()

func _onNo():
	emit_signal("selected", "no")
	hide()

func _onCancel():
	emit_signal("selected", "cancel")
	hide()
