extends Node2D

onready var def = get_node("/root/Definitions")

export (Array, Vector2) var dirOffset = [Vector2(), Vector2(), Vector2(), Vector2()]
export (ParticlesMaterial) var particles
export (Color) var lightColor

func _ready():
	$Particles2D.process_material = particles
	$Light2D.color = lightColor

func updateDir(dir):
	$Particles2D.position = dirOffset[dir]
	$Light2D.position = dirOffset[dir]

func setEffects(enableLight, enableParticles, color, particles):
	setLight(enableLight)
	setParticles(enableParticles)
	updateColor(color)
	updateParticles(particles)

func setLight(state):
	if state: $Light2D.show()
	else: $Light2D.hide()

func setParticles(state):
	if state: $Particles2D.show()
	else: $Particles2D.hide()

func updateColor(color):
	lightColor = color
	$Light2D.color = lightColor

func updateParticles(res):
	particles = res
	$Particles2D.process_material = particles
