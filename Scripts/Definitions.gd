extends Node

# ================================
# Data
# ================================

var TILE_DATA = {}
var STRING_IDS = {}
var ITEM_DATA = {}

# ================================
# Scenes
# ================================

var PLAYER_SCENE = preload("res://Scenes/Entities/Player.tscn")
var ITEM_SCENE = preload("res://Scenes/GUI/Inventory/Item.tscn")
var TRANSITION_SCENE = preload("res://Scenes/Effects/TransitionShader.tscn")

# ================================
# Dimensions
# ================================

const DIMENSIONS = {1: "d_alive", 2: "d_dead"}

func getDimensionLayer(dimension):
	return DIMENSIONS.keys()[DIMENSIONS.values().find(dimension)]

func getDimensionIndex(dimension):
	return DIMENSIONS.values().find(dimension)

# ================================
# Util
# ================================

func _ready():
	var file = File.new()
	
	file.open("res://Data/tiles.json", file.READ)
	TILE_DATA = parse_json(file.get_as_text())
	
	file.open("res://Data/stringIDs.json", file.READ)
	STRING_IDS = parse_json(file.get_as_text())
	
	file.open("res://Data/items.json", file.READ)
	ITEM_DATA = parse_json(file.get_as_text())
