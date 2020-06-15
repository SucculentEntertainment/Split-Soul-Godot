extends Control

export (SpriteFrames) var icon

func _ready():
	$Icon.frames = icon

func changeAmount(amount):
	$Amount.text = str(amount)
