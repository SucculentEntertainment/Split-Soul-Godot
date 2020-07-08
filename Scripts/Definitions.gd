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

# ================================
# Objects
# ================================

var STRING_IDS = {
	"Tiles":
	{
		"d_alive": 
		{
			0: "t_grass_a",
			1: "t_sand_a",
			2: "t_gravel_a",
			3: "t_dirt_a",
			4: "t_snow_a"
		},
		
		"d_dead": 
		{
			0: "t_grass_d",
			1: "t_sand_d",
			2: "t_gravel_d",
			3: "t_dirt_d",
			4: "t_snow_d"
		}
	},
	
	"Environment":
	{
		0: "o_oakTree1",
		1: "o_pineTree",
		2: "o_birchTree",
		3: "o_bush",
		4: "o_oakTree2"
	},
	
	"Powerups":
	{
		0: "p_coin",
		1: "p_soulPoint"
	},
	
	"Enemies":
	{
		0: "e_slime"
	},
	
	"Interactables":
	{
		0: "n_altar"
	}
}

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

var TILE_SCALE = Vector2(2, 2)

# ================================
# Dimensions
# ================================

var TRANSITION_SCENE = preload("res://Scenes/Effects/TransitionShader.tscn")

const DIMENSION_NAMES = {1: "d_alive", 2: "d_dead"}
const DIMENSION_ALIVE = 1; const DIMENSION_DEAD = 2
const NUM_DIMENSIONS = 2

var SPAWNABLE_ENEMIES = ["e_slime"]

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
