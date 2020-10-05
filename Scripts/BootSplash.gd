extends ColorRect

onready var def = get_node("/root/Definitions")
export (bool) var skipLogo = false
export (bool) var forceAlt = false
export (bool) var forceDarkMode = false
export (bool) var delayStart = false

export (Texture) var altLogo
export (Texture) var darkModeText
export (Texture) var darkModeAltLogo

export (AudioStreamOGGVorbis) var altSound

var rng = RandomNumberGenerator.new()
var anim = "BootAnim"
var darkMode = false

func _ready():
	if delayStart:
		OS.delay_msec(5000)
	
	OS.window_fullscreen = def.CONFIG.get_value("video", "fullscreen")
	darkMode = def.CONFIG.get_value("game", "darkMode")
	
	if forceDarkMode: darkMode = true
	
	if darkMode:
		$Logo.texture = darkModeText
		altLogo = darkModeAltLogo
	
	rng.randomize()
	var a = rng.randi_range(0, 100)
	print(a)
	
	if a == 32 or forceAlt:
		$Logo.texture = altLogo
		$AudioStreamPlayer.stream = altSound
		anim = "BootAnimAlt"
	
	if darkMode: anim += "Dark"
	
	if !skipLogo:
		$AnimationPlayer.play(anim)
		yield($AnimationPlayer, "animation_finished")
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()
