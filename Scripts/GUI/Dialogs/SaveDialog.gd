extends Control

export (String, "Save", "Load") var type

signal finished

var dir = Directory.new()
var file = File.new()
var fileButtonScene = load("res://Scenes/GUI/Dialogs/FileButton.tscn")

var gui = null
var selection = ""

var buttons = []

func _ready():
	$BlurShader/AnimationPlayer.play("FadeOutInstant")
	
	$Panel/Content/Navigation/Cancel.connect("button_down", self, "toggle")
	$Panel/Content/Navigation/Action.connect("button_down", self, "_onAction")

func init(gui):
	self.gui = gui

func loadSaves():
	$BlurShader/AnimationPlayer.play("FadeInFast")
	yield($BlurShader/AnimationPlayer, "animation_finished")
	$LoadingAnim.show()
	
	for b in buttons:
		b.queue_free()
	
	buttons = []
	
	if !dir.dir_exists("user://saves/"):
		dir.make_dir("user://saves/")
	
	dir.open("user://saves/")
	
	dir.list_dir_begin(true, true)
	var fileName = ""
	fileName = dir.get_next()
	
	while fileName != "":
		var fileButton = fileButtonScene.instance()
		$Panel/Content/Savenames/Buttons.add_child(fileButton)
		
		file.open("user://saves/" + fileName, File.READ)
		
		var date = file.get_var()
		file.close()
		
		fileName = fileName.substr(0, (fileName.length() - 4))
		
		fileButton.create(fileName, date)
		fileButton.connect("selected", self, "_onSelect")
		
		buttons.append(fileButton)
		
		fileName = dir.get_next()
	
	dir.list_dir_end()
	
	$BlurShader/AnimationPlayer.play("FadeOutFast")
	$LoadingAnim.hide()
	yield($BlurShader/AnimationPlayer, "animation_finished")

func saveGame(name):
	file.open("user://saves/" + name + ".sss", File.WRITE)
	file.store_var(OS.get_datetime())
	
	gui.get_parent().get_parent().saveGame(file) #GUI -> CanvasLayer -> Main -> saveGame()
	
	file.close()
	toggle()

func loadGame(name):
	file.open("user://saves/" + name + ".sss", File.READ)
	
	gui.get_parent().get_parent().loadGame(file) #GUI -> CanvasLayer -> Main -> loadGame()
	
	file.close()
	toggle()

func _onAction():
	if type == "Save":
		var textBox = $Panel/Content/TextBox/LineEdit.text
		
		if textBox == "":
			if selection == "":
				return
			
			textBox = selection
		saveGame(textBox)
	else:
		if selection == "":
			return
		
		loadGame(selection)

func _onSelect(btn, name):
	selection = name
	
	for b in buttons:
		if b == btn:
			continue
		
		b.deselect()

func toggle():
	if visible:
		hide()
		mouse_filter = MOUSE_FILTER_IGNORE
		emit_signal("finished")
	else:
		show()
		mouse_filter = MOUSE_FILTER_STOP
		loadSaves()
