extends Node2D

onready var def = get_node("/root/Definitions")

export (int) var dir
export (ParticlesMaterial) var particles
export (Color) var lightColor

func _ready():
	$Particles2D.process_material = particles
	$Light2D.color = lightColor

func updateDir(dir):
	self.dir = dir

func setEffects(enableLight, enableParticles, color, particles):
	if enableLight: $Light2D.show()
	else: $Light2D.hide()
	
	if enableParticles: $Particles2D.show()
	else: $Particles2D.hide()
	
	lightColor = color
	$Light2D.color = lightColor
	
	self.particles = particles
	$Particles2D.process_material = self.particles

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
