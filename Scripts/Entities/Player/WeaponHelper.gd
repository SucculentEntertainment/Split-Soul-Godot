extends Node

onready var def = get_node("/root/Definitions")
var wpnNode = null

func _ready():
	pass

func init(weaponNode):
	wpnNode = weaponNode

func setWeapon(weapon):
	if wpnNode == null: return
	delWeapon()
	
	var wpn = def.SPAWNABLE_SCENES[weapon].instance()
	wpnNode.add_child(wpn)
	
	return wpn

func delWeapon():
	if wpnNode == null: return
	
	for w in wpnNode.get_children():
		wpnNode.remove_child(w)
		w.queue_free()
