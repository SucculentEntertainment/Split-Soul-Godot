extends Control

signal menuClosed

onready var def = get_node("/root/Definitions")
onready var main = get_parent().get_parent()

var dir = Directory.new()
var file = File.new()

var saves = {}

func _ready():
	$BlurShader/AnimationPlayer.play("FadeInInstant")
	$TransitionShader/AnimationPlayer.play("Open")
	
	$UI/Continue.connect("button_down", self, "_onContinue")
	$UI/NewGame.connect("button_down", self, "_onNewGame")
	$UI/LoadGame.connect("button_down", self, "_onLoadGame")
	$UI/Options.connect("button_down", self, "_onOptions")
	$UI/Credits.connect("button_down", self, "_onCredits")
	$UI/Exit.connect("button_down", self, "_onExit")
	
	if !dir.dir_exists("user://saves/"):
		dir.make_dir("user://saves/")
	
	dir.open("user://saves/")
	
	dir.list_dir_begin(true, true)
	var fileName = ""
	fileName = dir.get_next()
	
	while fileName != "":
		file.open("user://saves/" + fileName, File.READ)
		var timestamp = OS.get_unix_time_from_datetime(file.get_var())
		file.close()
		
		fileName = fileName.substr(0, (fileName.length() - 4))
		saves[timestamp] = fileName
		
		fileName = dir.get_next()
	
	dir.list_dir_end()
	
	if saves.size() == 0:
		$UI/Continue.disabled = true
		$UI/LoadGame.disabled = true

func _onContinue():
	var times = saves.keys()
	times.sort()
	
	file.open("user://saves/" + saves[times[times.size() - 1]] + ".sss", File.READ)
	file.get_var()
	
	main.loadGame(file)
	yield(main, "loadComplete")
	
	file.close()
	quitMenu()

func _onNewGame():
	main.newGame()
	quitMenu()

func _onLoadGame():
	$LoadDialog.init(main)
	$LoadDialog.toggle()
	
	yield($LoadDialog, "finished")
	if $LoadDialog.loaded: quitMenu()

func _onOptions():
	pass

func _onCredits():
	pass

func _onExit():
	get_tree().quit()

func quitMenu():
	$BlurShader/AnimationPlayer.play("FadeOutInstant")
	yield($BlurShader/AnimationPlayer, "animation_finished")
	emit_signal("menuClosed")
