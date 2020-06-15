extends Node

var PLAYER_SCENE = preload("res://Scenes/Entities/Player.tscn")

var ITEM_SCENES = [
	preload("res://Scenes/Items/Coin.tscn")
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
