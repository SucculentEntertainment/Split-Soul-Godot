extends KinematicBody2D

onready var vars = get_node("/root/PlayerVars")
onready var def = get_node("/root/Definitions")

signal changeDimension(dimension)

signal initGUI(maxHealth)
signal updateGUI(health, coins)

export (int) var speed = 20000
export (int) var maxHealth = 100
export (Array, int) var dimensionOffsets

export (Texture) var aimCursor
var cursorCounter = 0
var cursorFrames = 2
var useCustomCursor = false

var damage = 2

var interact = null
var gui = null

var moving = false
var prevDir = Vector2()

var dir = Vector2()
var vel = Vector2()

var prevPos = Vector2()

var invincibility = false
var hasAttacked = false

enum {
	MOVE,
	ATTACK
}

enum {
	IN_DISABLED,
	IN_MOVE,
	IN_ATTACK,
	IN_FULLGUI,
	IN_GUI
}

enum {
	ATK_INIT,
	ATK_HOLD,
	ATK_RELEASE
}

var state = MOVE
var inputState = IN_MOVE
var attackState = ATK_INIT

var currGUI = ""
var guiHover = false
var fullGUIOpen = false

var inventory = null
var hotbar = null

var currWeapon = ""

# ================================
# Utility
# ================================

func _ready():
	$AnimationTree.active = true
	$AnimationTree.get("parameters/playback").start("Idle")
	$InvincibilityTimer.connect("timeout", self, "_onInvincibilityEnd")
	$HitboxPivot/Hitbox.connect("area_entered", self, "_onGiveDamage")

func initGUI(gui):
	self.gui = gui
	gui.givePlayerReference(self)
	gui.updateValues(maxHealth)
	
	inventory = gui.get_node("Inventory")
	hotbar = inventory.get_node("Hotbar")
	
	hotbar.connect("mouse_entered", self, "_onGUIEnter")
	hotbar.connect("mouse_exited", self, "_onGUIExited")

func _physics_process(delta):
	if inputState == IN_DISABLED: return
	getInput()
	
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack(delta)

# ================================
# Movement
# ================================

func move(delta):
	prevPos = global_position
	prevDir = dir
	
	if dir == Vector2(): vel = Vector2()
	else: vel = dir * speed * delta
	
	changeAnimation()
	vel = move_and_slide(vel)

func changeAnimation():
	if dir != Vector2():
		$AnimationTree.set("parameters/Idle/blend_position", dir)
		$AnimationTree.set("parameters/Walk/blend_position", dir)
		$AnimationTree.set("parameters/Attack/blend_position", dir)
		$AnimationTree.get("parameters/playback").travel("Walk")
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")

# ================================
# Attack
# ================================

func _onGiveDamage(area):
	if "Hurtbox" in area.name:
		var body = area.get_parent()
		if body != null and "Enemy" in body.name:
			body.receiveDamage(damage)

func attack(delta):
	if hasAttacked: return
	
	match attackState:
		ATK_INIT:
			attackInit()
		ATK_HOLD:
			attackHold()
		ATK_RELEASE:
			attackRelease()
	
	hasAttacked = true
	if hotbar.items[0] != "":
		if $Weapon.get_child_count() == 0:
			# Write SpawnHelper for this
			var weapon = load("res://Scenes/Items/Weapons/FireWand.tscn").instance()
			$Weapon.add_child(weapon)
			
		$Weapon.get_children()[0].attack(self)
	
	$AnimationTree.get("parameters/playback").travel("Attack")

func attackInit():
	$AnimationTree.get("parameters/attack/playback").travel("Init")

func attackHold():
	pass

func attackRelease():
	pass

func attackEnd():
	hasAttacked = false
	state = MOVE	inputState = IN_MOVE

# ================================
# Items
# ================================

func itemAction(item):
	if item.id == "p_coin":
		vars.coins += 1
	elif item.id == "p_soulPoint":
		vars.soulpoints += 1
	elif item.id == "p_itemStack":
		gui.get_node("Inventory").insertItem(item.itemName, item.amount)
	
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
	
	if dimension == "d_dead": enableGlow()
	else: disableGlow()
	
	$Sprite.region_rect.position.y = dimensionOffsets[def.getDimensionIndex(dimension)]
	
	transition.get_node("AnimationPlayer").play("Open")
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	transition.queue_free()

func enableGlow():
	$Light2D.show()

func disableGlow():
	$Light2D.hide()

# ================================
# Input
# ================================

func getInput():
	if guiHover: inputState = IN_GUI
	elif fullGUIOpen: inputState = IN_FULLGUI
	
	match inputState:
		IN_DISABLED:
			pass
		IN_MOVE:
			moveInput()
		IN_ATTACK:
			attackInput()
		IN_FULLGUI:
			fullGUIInput()
		IN_GUI:
			guiInput()

func openGUI():
	if Input.is_action_just_pressed("ctrl_console"):
		currGUI = "Console"
	if Input.is_action_just_pressed("ctrl_inventory"):
		currGUI 	= "Inventory"
	if Input.is_action_just_pressed("ui_cancel"):
		currGUI = "QuickMenu"
		
	gui.get_node(currGUI).toggle()
	inputState = IN_FULLGUI
	fullGUIOpen = true
	dir = Vector2()

func oldInput():
	#Temporary Code
	if hotbar.items[0] != "":
		useCustomCursor = true
		$CursorAnimation.play("Cursor")
	else:
		useCustomCursor = false
		$CursorAnimation.stop()

func moveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()
	
	if Input.is_action_just_pressed("ctrl_interact"):
		if interact != null: interact.interact(self)
		
	if Input.is_action_just_pressed("ctrl_attack_primary"):
		hasAttacked = false
		state = ATTACK
		inputState = IN_ATTACK
		dir = Vector2()
	
	openGUI()

func attackInput():
	if Input.is_action_just_pressed("ctrl_attack_primary"):
		hasAttacked = false

func fullGUIInput():
	if (Input.is_action_just_pressed("ui_cancel") or
	   (Input.is_action_just_pressed("ctrl_console") and currGUI == "Console") or
	   (Input.is_action_just_pressed("ctrl_inventory") and currGUI == "Inventory")):
		
		gui.get_node(currGUI).toggle()
		currGUI = ""
		inputState = IN_MOVE
		fullGUIOpen = false

func guiInput():
	openGUI()

func _onGUIEntered():
	guiHover = true
	inputState = IN_GUI

func _onGUIExited():
	guiHover = false
	inputState = IN_MOVE

# ================================
# Damage
# ================================

func _onReceiveDamage(damage):
	if !invincibility:
		vars.health -= damage
		gui.updateValues(maxHealth)
		$Camera2D.shake(0.2, 500, 16)
		if vars.health <= 0:
			if !vars.dead: die()
			else: get_tree().change_scene("res://Scenes/GameOver.tscn")

func die():
	vars.dead = true
	changeDimension("d_dead")
	vars.health = maxHealth
	gui.updateValues(maxHealth)
	
	invincibility = true
	$InvincibilityTimer.start()

func _onInvincibilityEnd():
	invincibility = false

# ================================
# Heal
# ================================

func _onHealReceived(heal):
	vars.health += heal
	if vars.health > maxHealth: vars.health = maxHealth
	gui.updateValues(maxHealth)

# ================================
# Cursor
# ================================

func advanceCursor():
	if useCustomCursor:
		cursorCounter += 1
		if cursorCounter >= cursorFrames: cursorCounter = 0
		
		var cursorImg = Image.new()
		var cursor = ImageTexture.new()
		cursorImg.create(64, 64, false, Image.FORMAT_RGBA8)
		cursorImg.blit_rect(aimCursor.get_data(), Rect2(64 * cursorCounter, 0, 64, 64), Vector2())
		cursor.create_from_image(cursorImg)
		
		Input.set_custom_mouse_cursor(cursor, 0, Vector2(64, 64))
	else: Input.set_custom_mouse_cursor(null)
