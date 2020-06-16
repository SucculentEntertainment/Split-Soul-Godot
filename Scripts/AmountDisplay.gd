extends Control

export (SpriteFrames) var icon

func _ready():
	$Icon.frames = icon
	$Icon.playing = true

func changeAmount(amount):
	$Amount.text = str(amount)
