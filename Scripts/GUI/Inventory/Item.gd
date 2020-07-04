extends Control

onready var def = get_node("/root/Definitions")

export (bool) var animated
export (int) var numFrames

func _ready():
	pass

func setType(itemName):
	$Tween.interpolate_property($Sprite, "frame", def.ITEM_START_FRAMES[itemName], def.ITEM_START_FRAMES[itemName] + (def.ITEM_NUM_FRAMES[itemName] - 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	$Tween.start()
