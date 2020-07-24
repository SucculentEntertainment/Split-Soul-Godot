extends Node2D

onready var def = get_node("/root/Definitions")

export (Vector2) var tileSize
export (Texture) var texture

func _ready():
	var sheetSize = texture.get_size()
	var numTiles = sheetSize / tileSize
	var droppedIDs = 0
	
	var tileSet = TileSet.new()
	var image = Image.new()
	var textureData = texture.get_data()
	
	for y in numTiles.y:
		for x in numTiles.x:
			image.create(tileSize.x, tileSize.y, textureData.has_mipmaps(), textureData.get_format())
			image.blit_rect(textureData, Rect2(x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y), Vector2())
			
			if image.is_invisible():
				droppedIDs += 1
				continue
			
			var cID = (y * numTiles.x + x) - droppedIDs
			
			tileSet.create_tile(cID)
			tileSet.tile_set_texture(cID, texture)
			tileSet.tile_set_region(cID, Rect2(x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y))
			
			tileSet.tile_set_name(cID, def.STRING_IDS["Tiles"][str(cID)])
	
	ResourceSaver.save("res://Resources/TileSet Creator Output/tileSet.tres", tileSet)
	get_tree().quit()
