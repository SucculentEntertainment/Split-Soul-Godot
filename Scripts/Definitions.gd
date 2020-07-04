extends Node

var PLAYER_SCENE = preload("res://Scenes/Entities/Player.tscn")

# ================================
# Tiles
# ================================

var TILE_NAMES = {
	"d_alive":
	[
		"t_grass_a",
		"t_sand_a",
		"t_gravel_a",
		"t_dirt_a",
		"t_snow_a",
	],
	
	"d_dead":
	[
		"t_grass_d",
		"t_sand_d",
		"t_gravel_d",
		"t_dirt_d",
		"t_snow_d"
	]
}

var TILE_FRAMES = {
	"t_grass_a": 0 * 54,
	"t_sand_a": 1 * 54,
	"t_gravel_a": 2 * 54,
	"t_dirt_a": 3 * 54,
	"t_snow_a": 4 * 54,
	
	"t_grass_d": 12 * 54,
	"t_sand_d": 13 * 54,
	"t_gravel_d": 14 * 54,
	"t_dirt_d": 15 * 54,
	"t_snow_d": 16 * 54
}

var TILE_VARIATIONS = {
	"t_grass_a": 4,
	"t_sand_a": 4,
	"t_gravel_a": 4,
	"t_dirt_a": 4,
	"t_snow_a": 4,
	
	"t_grass_d": 4,
	"t_sand_d": 4,
	"t_gravel_d": 4,
	"t_dirt_d": 4,
	"t_snow_d": 4
}

var TILE_COLLISIONS = [
	"t_gravel_a",
	"t_gravel_d"
]

var TILE_LAYERS = {
	"a": "d_alive",
	"d": "d_dead"
}

var TILE_SCENE = preload("res://Scenes/Environment/Tile.tscn")

var ENVIRONMENT_SCENES = [
	preload("res://Scenes/Environment/Objects/OakTree1.tscn"),
	preload("res://Scenes/Environment/Objects/PineTree.tscn"),
	preload("res://Scenes/Environment/Objects/BirchTree.tscn"),
	preload("res://Scenes/Environment/Objects/Bush.tscn"),
	preload("res://Scenes/Environment/Objects/OakTree2.tscn")
]

# ================================
# Objects
# ================================

var POWERUP_SCENES = [
	preload("res://Scenes/Powerups/Coin.tscn"),
	preload("res://Scenes/Powerups/SoulPoint.tscn")
]

var ENEMY_SCENES = [
	preload("res://Scenes/Entities/Enemies/Slime.tscn")
]

var INTERACTABLE_SCENES = [
	preload("res://Scenes/Interactables/Altar.tscn")
]

# ================================
# Dimensions
# ================================

var TRANSITION_SCENE = preload("res://Scenes/Effects/TransitionShader.tscn")

const DIMENSION_NAMES = {1: "d_alive", 2: "d_dead"}
const DIMENSION_ALIVE = 1; const DIMENSION_DEAD = 2
const NUM_DIMENSIONS = 2

var SPAWNABLE_ENEMIES = [0]

# ================================
# Items
# ================================

const ITEM_NAMES = [
	"i_test1",
	"i_test2"
]

const ITEM_START_FRAMES = {
	"i_test1": 0,
	"i_test2": 1
}

const ITEM_NUM_FRAMES = {
	"i_test1": 2,
	"i_test2": 1
}

const ITEM_DESCS = {
	"i_test1": "Test item 1",
	"i_test2": "Test item 2"
}

const ITEM_STACK_SIZES = {
	"i_test1": 64,
	"i_test2": 256
}

var ITEM_SCENE = preload("res://Scenes/GUI/Inventory/Item.tscn")

# ================================
# Util
# ================================

func logB(x, b):
	var e = 0
	var ans = pow(b, e)
	while true:
		ans = pow(b, e)
		if ans == x:
			return e
		e += 1
