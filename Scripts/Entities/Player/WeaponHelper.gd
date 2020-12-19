extends Node

onready var def = get_node("/root/Definitions")
export (int) var dir = 0
export (String) var item = ""

var wpn = null
var wpnSpr = null
var wpnCool = null
var wpnFx = null

func _ready():
	wpn = get_parent().get_node("Weapon")
	wpnSpr = get_parent().get_node("Weapon/WeaponSprite")
	wpnCool = get_parent().get_node("Weapon/Cooldown")
	wpnFx = wpn.get_node("Effects")

func setWeapon(weapon):
	item = weapon
	wpn.itemName = item
	
	setFx()
	setOffsets()

func changeDir(dir):
	self.dir = dir
	setOffsets()

func setFx():
	if item == "none" or !def.ITEM_DATA[item].canHold: return
	wpnFx.setEffects(def.ITEM_DATA[item].light, def.ITEM_DATA[item].particles, def.ITEM_DATA[item].lightColor, load(def.ITEM_DATA[item].particleResource))

func setOffsets():
	if item == "none" or item == "":
		wpn.hide()
		wpn.canCharge = true
		return

	if !def.ITEM_DATA[item].canHold:
		wpn.hide()
		return

	wpn.show()
	wpnSpr.region_rect.size = Vector2(def.ITEM_DATA[item].offsets["dir"], 160)
	wpnSpr.region_rect.position = Vector2(dir * def.ITEM_DATA[item].offsets["dir"], def.ITEM_DATA[item].offsets["type"])

	wpnSpr.hframes = def.ITEM_DATA[item].numFrames
	wpnCool.wait_time = def.ITEM_DATA[item].cooldown

	wpn.canCharge = def.ITEM_DATA[item].canCharge
