extends Control

export (String) var itemName
export (String) var description
export (int) var stackSize

export (bool) var animated
export (int) var numFrames

func _ready():
	pass

func setType(itemName, def):
	self.itemName = itemName
	self.description = def.ITEM_DESCS[itemName]
	
	if !animated:
		$Sprite.frame = def.ITEM_FRAMES[itemName]
