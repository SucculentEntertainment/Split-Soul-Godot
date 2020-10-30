extends Control

onready var def = get_node("/root/Definitions")

func _ready():
	pass

func setType(itemName):
	$Sprite.frame = def.ITEM_STARTFRAMES[itemName]
	$Tween.interpolate_property($Sprite, "frame", def.ITEM_STARTFRAMES[itemName], def.ITEM_STARTFRAMES[itemName] + (def.ITEM_DATA[itemName].numFrames - 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1 / def.ITEM_DATA[itemName].numFrames)
	$Tween.start()
