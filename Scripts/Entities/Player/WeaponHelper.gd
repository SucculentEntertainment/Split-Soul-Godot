extends Node

onready var def = get_node("/root/Definitions")
var wpnNode = null

func _ready():
    pass

func init(weaponNode):
    wpnNode = weaponNode

func set(weapon):
    delWeapon()
    
    var wpn = def.SPAWNABLE_SCENES[weapon].instance()
    wpnNode.add_child(wpn)
    
    return wpn

func delWeapon():
    for w in wpnNode.get_children():
        wpnNode.removeChild(w)
        w.queue_free()