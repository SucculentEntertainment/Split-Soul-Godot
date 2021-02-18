extends Node

var health = 0
var mana = 0
var stamina = 0
var coins = 0
var soulpoints = 0
var dead = false

var difficulty = 0

func initVals(maxHealth, maxMana, maxStamina):
	health = maxHealth
	mana = maxMana
	stamina = maxStamina

func resetVars():
	health = 0
	coins = 0
	soulpoints = 0
	dead = false
