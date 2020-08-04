extends Node

var health = 0
var coins = 0
var soulpoints = 0
var dead = false

var difficulty = 0

func initHealth(maxHealth):
	health = maxHealth

func resetVars():
	health = 0
	coins = 0
	soulpoints = 0
	dead = false
