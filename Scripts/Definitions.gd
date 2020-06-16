extends Node

var PLAYER_SCENE = preload("res://Scenes/Entities/Player.tscn")

var TILE_SCENES = [
	[
		preload("res://Scenes/Environment/Tiles/Alive/Grass.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Sand.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Stone.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Dirt.tscn"),
		preload("res://Scenes/Environment/Tiles/Alive/Snow.tscn")
	],
	[
		preload("res://Scenes/Environment/Tiles/Dead/Grass.tscn")
	]
]

var ENVIRONMENT_SCENES = [
	
]

var ITEM_SCENES = [
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

func logB(x, b):
	var e = 0
	var ans = pow(b, e)
	while true:
		ans = pow(b, e)
		if ans == x:
			return e
		e += 1
