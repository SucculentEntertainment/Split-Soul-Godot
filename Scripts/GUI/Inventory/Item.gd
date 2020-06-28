extends Control

export (bool) var animated
export (int) var numFrames

func _ready():
	pass

func setType(itemName, def):
	if !animated:
		$Sprite.frame = def.ITEM_FRAMES[itemName]
