extends Node2D

onready var def = get_node("/root/Definitions")

export (Vector2) var tileSize
export (Texture) var texture

var descriptor = null
var varCount = 0
var ids = {}
var collisions = []
var tiles = {}

var cID = 0

func _ready():
	loadDescriptor()
	createTileset()

func loadDescriptor():
	var file = File.new()
	
	file.open("res://Data/tileSetDescriptor.json", file.READ)
	descriptor = parse_json(file.get_as_text())
	file.close()

func saveIDs():
	var file = File.new()
	
	file.open("res://Data/Generated/generatedTileIDs.json", file.WRITE)
	var jstr = JSON.print(ids, "\t")
	file.store_string(jstr)
	file.close()

func saveTiles():
	var file = File.new()
	
	file.open("res://Data/Generated/generatedTiles.json", file.WRITE)
	var jstr = JSON.print(tiles, "\t")
	file.store_string(jstr)
	file.close()

func createTileset():
	var sheetSize = texture.get_size()
	var numTiles = sheetSize / tileSize
	var droppedIDs = 0
	
	var tileSet = TileSet.new()
	var image = Image.new()
	var textureData = texture.get_data()
	
	for group in descriptor:
		for i in range(group.variations):
			var strID = group.id
			if i > 0:
				var ending = strID.substr(strID.length() - 2)
				strID = strID.substr(0, strID.length() - 2)
				strID += str(i) + ending
			
			ids[str(cID)] = strID
			collisions.append(group.collision)
			cID += 1
	
	saveIDs()
	
	for y in numTiles.y:
		for x in numTiles.x:
			image.create(tileSize.x, tileSize.y, textureData.has_mipmaps(), textureData.get_format())
			image.blit_rect(textureData, Rect2(x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y), Vector2())
			
			if image.is_invisible():
				droppedIDs += 1
				continue
			
			cID = (y * numTiles.x + x) - droppedIDs
			
			tileSet.create_tile(cID)
			tileSet.tile_set_texture(cID, texture)
			tileSet.tile_set_region(cID, Rect2(x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y))
			
			tileSet.tile_set_name(cID, ids[str(cID)])
			
			tiles[ids[str(cID)]] = {"hasCollision": collisions[cID], "startFrame": (y * numTiles.x + x)}
	
	saveTiles()
	
	ResourceSaver.save("res://Resources/TileSet Creator Output/tileSet.tres", tileSet)
	get_tree().quit()
