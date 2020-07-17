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

var SPAWNABLE_SCENES = {
	"t_tile": preload("res://Scenes/Entities/Tile.tscn"),
	
	"o_oakTree1": preload("res://Scenes/Entities/Objects/OakTree1.tscn"),
	"o_pineTree": preload("res://Scenes/Entities/Objects/PineTree.tscn"),
	"o_birchTree": preload("res://Scenes/Entities/Objects/BirchTree.tscn"),
	"o_bush": preload("res://Scenes/Entities/Objects/Bush.tscn"),
	"o_oakTree2": preload("res://Scenes/Entities/Objects/OakTree2.tscn"),
	
	"e_slime": preload("res://Scenes/Entities/Enemies/Slime.tscn"),
	
	"n_altar": preload("res://Scenes/Entities/Interactables/Altar.tscn"),
	
	"p_coin": preload("res://Scenes/Entities/Powerups/Coin.tscn"),
	"p_soulPoint": preload("res://Scenes/Entities/Powerups/SoulPoint.tscn"),
	"p_itemStack": preload("res://Scenes/Entities/Powerups/ItemStack.tscn")
}

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
