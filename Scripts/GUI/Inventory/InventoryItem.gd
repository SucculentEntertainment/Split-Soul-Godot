extends Node2D

export (String) var itemName
export (String) var description
export (Texture) var itemTexture
export (int) var stackSize

func _ready():
	$Sprite.texture = itemTexture
