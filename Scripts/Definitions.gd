extends Node

var PLAYER_SCENE = preload("res://Scenes/Entities/Player.tscn")

var TILE_SCENES = [
	[
		preload("res://Scenes/Environment/Tiles/Alive/Grass.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Sand.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Gravel.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Dirt.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Snow.tscn")
	],
	[
		preload("res://Scenes/Environment/Tiles/Dead/Grass.tscn"),
		preload("res://Scenes/Environment/Tiles/Dead/Sand.tscn"),
		preload("res://Scenes/Environment/Tiles/Dead/Gravel.tscn"),
		preload("res://Scenes/Environment/Tiles/Dead/Dirt.tscn"),
		preload("res://Scenes/Environment/Tiles/Dead/Snow.tscn")
	]
]

var ENVIRONMENT_SCENES = [
	preload("res://Scenes/Environment/Objects/OakTree1.tscn"),
	preload("res://Scenes/Environment/Objects/PineTree.tscn"),
	preload("res://Scenes/Environment/Objects/BirchTree.tscn"),
	preload("res://Scenes/Environment/Objects/Bush.tscn"),
	preload("res://Scenes/Environment/Objects/OakTree2.tscn")
]

var POWERUP_SCENES = [
	preload("res://Scenes/Items/Coin.tscn"),
	preload("res://Scenes/Items/SoulPoint.tscn")
]

var ENEMY_SCENES = [
	preload("res://Scenes/Entities/Enemies/Slime.tscn")
]

var INTERACTABLE_SCENES = [
	preload("res://Scenes/Interactables/Altar.tscn")
]

var TRANSITION_SCENE = preload("res://Scenes/Effects/TransitionShader.tscn")

const DIMENSION_STRINGS = {1: "Alive", 2: "Dead"}
const DIMENSION_ALIVE = 1; const DIMENSION_DEAD = 2
const NUM_DIMENSIONS = 2
const DIMENSION_NAMES = ["d_alive", "d_dead"]

var SPAWNABLE_ENEMIES = [0]

const ITEMS = [
	"i_test1",
	"i_test2"
]

var ITEM_SCENES = [
	
]

func logB(x, b):
	var e = 0
	var ans = pow(b, e)
	while true:
		ans = pow(b, e)
		if ans == x:
			return e
		e += 1
