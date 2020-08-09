extends Control

func _ready():
	pass

func init(text, entries):
	$HBoxContainer/Label.text = text
	
	for e in entries:
		$HBoxContainer/OptionButton.add_item(e)
