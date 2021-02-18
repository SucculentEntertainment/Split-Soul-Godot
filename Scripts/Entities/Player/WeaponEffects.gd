extends Node2D

onready var def = get_node("/root/Definitions")

export (int) var dir

func _ready():
	pass

func updateDir(dir):
	self.dir = dir

func setEffects(enableLight, enableParticles, colors, particles):
	if enableLight: $Light2D.show()
	else: $Light2D.hide()
	
	if enableParticles: $Particles2D.show()
	else: $Particles2D.hide()
	
	var tmp = []
	for p in particles: tmp.append(load(p))
	
	get_parent().lightColors = colors
	get_parent().particles = tmp

# ================================
# Animation Stuff
# ================================

func playAnim(anim, type):
	var dirStr = ""
	
	match dir:
		0: dirStr = "down"
		1: dirStr = "up"
		2: dirStr = "right"
		3: dirStr = "left"
	
	var animName = anim + "_" + type + "_" + dirStr
	$AnimationPlayer.play(animName)
