extends KinematicBody2D

onready var vars = get_node("/root/PlayerVars")
onready var def = get_node("/root/Definitions")

signal changeDimension(dimension)

signal initGUI(maxHealth)
signal updateGUI(health, coins)

export (int) var speed = 20000
export (int) var maxHealth = 100
export (Array, int) var dimensionOffsets
export (Array, int) var directionOffsets

export (int) var directionState = 0

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
	DOWN,
	UP,
	RIGHT,
	LEFT
}

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

var prevWeapon = "none"
var currWeapon = "none"
var currWeaponGroup = "none"
var currDimension = "d_alive"
var wpn = null

# ================================
# Utility
# ================================

func _ready():
	$AnimationTree.active = true
	$AnimationTree.get("parameters/playback").start("Idle")
	$InvincibilityTimer.connect("timeout", self, "_onInvincibilityEnd")
	$HitboxPivot/Hitbox.connect("area_entered", self, "_onGiveDamage")
	
	$WeaponHelper.init($Weapon)

func initGUI(gui):
	self.gui = gui
	gui.givePlayerReference(self)
	gui.updateValues(maxHealth)
	
	inventory = gui.get_node("Inventory")
	hotbar = inventory.get_node("Hotbar")
	
	hotbar.connect("mouse_entered", self, "_onGUIEntered")
	hotbar.connect("mouse_exited", self, "_onGUIExited")

func _physics_process(delta):
	if inputState == IN_DISABLED: return
	getInput()
	updateWeapon()
	
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
		if wpn != null: wpn.updateState("Walk")
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.get("parameters/Walk/playback").travel(currWeaponGroup)
	else:
		if wpn != null: wpn.updateState("Idle")
		$AnimationTree.get("parameters/playback").travel("Idle")
		$AnimationTree.get("parameters/Idle/playback").travel(currWeaponGroup)

# ================================
# Attack
# ================================

func _onGiveDamage(area):
	if "Hurtbox" in area.name:
		var body = area.get_parent()
		if body != null and "Enemy" in body.name:
			body.receiveDamage(damage)

func attack(delta):
	$AnimationTree.get("parameters/playback").travel("Attack")
	$AnimationTree.get("parameters/Attack/playback").travel(currWeaponGroup)
	var anim = $AnimationTree.get("parameters/Attack/" + currWeaponGroup + "/playback")
	
	match attackState:
		ATK_INIT:
			attackInit(anim)
		ATK_HOLD:
			attackHold(anim)
		ATK_RELEASE:
			attackRelease(anim)

func attackInit(anim):
	if wpn != null: wpn.updateState("ATK_Init")
	anim.travel("Init")

func attackHold(anim):
	if wpn != null and !wpn.canHold:
		attackState = ATK_RELEASE
		return
	
	anim.travel("Hold")
	
	if wpn != null: wpn.charge(self)

	if Input.is_mouse_button_pressed(BUTTON_LEFT) == false:
		attackState = ATK_RELEASE

func attackRelease(anim):
	anim.travel("Release")
	
	if !hasAttacked:
		hasAttacked = true
		if wpn != null: wpn.attack(self)

func attackInitDone():
	attackState = ATK_HOLD

func attackEnd():
	hasAttacked = false
	state = MOVE
	inputState = IN_MOVE
	attackState = ATK_INIT

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

func updateWeapon():
	var slot = 0
	
	if currDimension == "d_dead":
		slot = 1
		useCustomCursor = true
		$CursorAnimation.play("Cursor")
	else:
		useCustomCursor = false
		$CursorAnimation.stop()

	if inventory.hotbar[slot].amount == 0 or inventory.hotbar[slot].item == "": currWeapon = "none"
	else: currWeapon = inventory.hotbar[slot].item
	
	if prevWeapon == currWeapon: return
	prevWeapon = currWeapon
	
	if currWeapon != "none":
		currWeaponGroup = def.ITEM_DATA[currWeapon].subType
		wpn = $WeaponHelper.setWeapon(currWeapon)
	else:
		currWeaponGroup = "none"
		$WeaponHelper.delWeapon()
		wpn = null

# ================================
# Actions
# ================================

func changeDimension(dimension):
	currDimension = dimension

	var transition = def.TRANSITION_SCENE.instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("Close")
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	
	emit_signal("changeDimension", dimension)
	$CollisionShape2D.disabled = false;
	
	if dimension == "d_dead": enableGlow()
	else: disableGlow()
	
	$Sprite.region_rect.position.x = dimensionOffsets[def.getDimensionIndex(dimension)] + directionOffsets[directionState]
	
	transition.get_node("AnimationPlayer").play("Open")
	yield(transition.get_node("AnimationPlayer"), "animation_finished")
	transition.get_parent().remove_child(transition)
	transition.queue_free()

func enableGlow():
	$Light2D.show()

func disableGlow():
	$Light2D.hide()

# ================================
# Input
# ================================

func getInput():
	match inputState:
		IN_DISABLED:
			pass
		IN_MOVE:
			moveInput()
			openGUI()
			miscInput()
		IN_ATTACK:
			attackInput()
		IN_FULLGUI:
			fullGUIInput()
		IN_GUI:
			moveInput()
			openGUI()

func openGUI():
	if Input.is_action_just_pressed("ctrl_console"):
		currGUI = "Console"
	if Input.is_action_just_pressed("ctrl_inventory"):
		currGUI = "Inventory"
	if Input.is_action_just_pressed("ui_cancel"):
		currGUI = "QuickMenu"
	
	if currGUI == "": return
	
	gui.get_node(currGUI).toggle()
	inputState = IN_FULLGUI
	fullGUIOpen = true
	dir = Vector2()

func miscInput():
	if Input.is_action_just_pressed("ctrl_interact"):
		if interact != null: interact.interact(self)
		
	if Input.is_action_just_pressed("ctrl_attack_primary"):
		hasAttacked = false
		state = ATTACK
		inputState = IN_ATTACK
		dir = Vector2()

func moveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()
	
	if dir != Vector2():
		$DirectionTree.set("parameters/blend_position", dir)
		$Sprite.region_rect.position.x = dimensionOffsets[def.getDimensionIndex(currDimension)] + directionOffsets[directionState]
		$Punchwave.region_rect.position.y = directionState * 32
		if wpn != null: wpn.updateDir(directionState)

func attackInput():
	if Input.is_action_just_pressed("ctrl_attack_primary"):
		hasAttacked = false

func fullGUIInput():
	if (Input.is_action_just_pressed("ui_cancel") or
	   (Input.is_action_just_pressed("ctrl_inventory") and currGUI == "Inventory")):
		
		gui.get_node(currGUI).toggle()
		currGUI = ""
		if guiHover: inputState = IN_GUI
		else: inputState = IN_MOVE
		fullGUIOpen = false

func _onGUIEntered():
	guiHover = true
	if fullGUIOpen: inputState = IN_FULLGUI
	else: inputState = IN_GUI

func _onGUIExited():
	guiHover = false
	if fullGUIOpen: inputState = IN_FULLGUI
	else: inputState = IN_MOVE

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
