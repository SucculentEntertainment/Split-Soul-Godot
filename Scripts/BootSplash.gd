extends ColorRect

onready var def = get_node("/root/Definitions")
export (bool) var skipLogo = false
export (bool) var forceAlt = false
export (bool) var darkMode = false

export (Texture) var altIcon
export (Texture) var altLogo

export (Color)   var darkModeBG
export (Texture) var darkModeText
export (Texture) var darkModeAltLogo

var rng = RandomNumberGenerator.new()

func _ready():
	OS.window_fullscreen = def.CONFIG.get_value("video", "fullscreen")
	
	if darkMode:
		color = darkModeBG
		$Logo.texture = darkModeText
		altLogo = darkModeAltLogo
	
	rng.randomize()
	var a = rng.randi_range(0, 100)
	print(a)
	
	if a == 32 or forceAlt:
		$Logo.texture = altLogo
		$Icon.texture = altIcon
	
	if !skipLogo:
		$AnimationPlayer.play("BootAnim")
		yield($AnimationPlayer, "animation_finished")
	
	$TransitionShader/AnimationPlayer.play("Close")
	yield($TransitionShader/AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://Scenes/Main.tscn")
	queue_free()
