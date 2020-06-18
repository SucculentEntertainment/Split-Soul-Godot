extends KinematicBody2D

onready var vars = get_node("/root/PlayerVars")

signal changeDimension(dimension)

signal initGUI(maxHealth)
signal updateGUI(health, coins)

export (int) var speed = 10000
export (int) var maxHealth = 100
export (Array, Texture) var textures

onready var def = get_node("/root/Definitions")

var interact = null
var disableIn = false

var gui = null

var moving = false
var prevDir = Vector2()

var dir = Vector2()
var vel = Vector2()

# ================================
# Utility
# ================================

func _ready():
	$AnimationTree.get("parameters/playback").start("Idle")

func initGUI(gui):
	self.gui = gui
	gui.givePlayerReference(self)
	gui.updateValues(maxHealth)

func _physics_process(delta):
	if !disableIn: 
		getInput()
		move(delta)

# ================================
# Movement
# ================================

func getMoveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()

func move(delta):
	prevDir = dir
	getMoveInput()
	
	if dir == Vector2(): vel = Vector2()
	else: vel = dir * speed * delta
	
	changeAnimation()
	vel = move_and_slide(vel)

func changeAnimation():
	if dir != Vector2():
		$AnimationTree.set("parameters/Idle/blend_position", dir)
		$AnimationTree.set("parameters/Walk/blend_position", dir)
		$AnimationTree.get("parameters/playback").travel("Walk")
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")

# ================================
# Items
# ================================

func itemAction(item):
	if item.itemName == "Coin":
		vars.coins += 1
	elif item.itemName == "SoulPoint":
		vars.soulpoints += 1
	
	gui.updateValues(maxHealth)

# ================================
# Actions
# ================================

func changeDimension(dimension):
	var transition = def.TRANSITION_SCENE.instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("Close")
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	
	emit_signal("changeDimension", dimension)
	$CollisionShape2D.disabled = false;
	
	if textures.size() > def.logB(dimension, 2):
		$Sprite.texture = textures[def.logB(dimension, 2)]
	
	transition.get_node("AnimationPlayer").play("Open")
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	transition.queue_free()

func getInput():
	if Input.is_action_just_pressed("ctrl_interact"):
		if interact != null: interact.interact(self)
	if Input.is_action_just_pressed("ctrl_console"):
		if gui != null: gui.get_node("Console").toggle()

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	vars.health -= damage
	gui.updateValues(maxHealth)
	$Camera2D.shake(0.2, 500, 16)
	if vars.health <= 0:
		if !vars.dead: die()
		else: get_tree().change_scene("res://Scenes/GameOver.tscn")

func _onGiveDamage(damage):
	pass

func die():
	vars.dead = true
	changeDimension(def.DIMENSION_DEAD)
	vars.health = maxHealth
	gui.updateValues(maxHealth)
