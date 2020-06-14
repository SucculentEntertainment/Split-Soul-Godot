extends Node

var ITEM_SCENES = [
	preload("res://Scenes/Items/Coin.tscn")
]

var ENEMY_SCENES = [
	preload("res://Scenes/Entities/Enemies/Slime.tscn")
]

var STRUCTURE_SCENES = [
	preload("res://Scenes/Structures/Altar.tscn")
]

const DIMENSION_STRINGS = {1: "Alive", 2: "Dead"}
const DIMENSION_ALIVE = 1; const DIMENSION_DEAD = 2
const NUM_DIMENSIONS = 2

func logB(x, b):
	var e = 0
	var ans = pow(b, e)
	while true:
		ans = pow(b, e)
		if ans == x:
			return e
		e += 1