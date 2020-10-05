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
var disableIn = false
var disableAllIn = false

var gui = null

var moving = false
var prevDir = Vector2()

var dir = Vector2()
var vel = Vector2()

var prevPos = Vector2()

var invincibility = false

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var isInGUI = false
var currGUI = ""

var inventory = null
var hotbar = null

var hasAttacked = false

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

func _physics_process(delta):
	getInput()
	
	if !disableIn: 
		match state:
			MOVE:
				move(delta)
			ATTACK:
				attack(delta)

# ================================
# Movement
# ================================

func getMoveInput():
	dir.x = int(Input.is_action_pressed("ctrl_right")) - int(Input.is_action_pressed("ctrl_left"))
	dir.y = int(Input.is_action_pressed("ctrl_down")) - int(Input.is_action_pressed("ctrl_up"))
	dir = dir.normalized()

func move(delta):
	prevPos = global_position
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
	if !hasAttacked:
		if hotbar.items[0] != "":
			if $Weapon.get_child_count() == 0:
				# Write SpawnHelper for this
				var weapon = load("res://Scenes/Items/Weapons/FireWand.tscn").instance()
				$Weapon.add_child(weapon)
			
			$Weapon.get_children()[0].attack(self)
		
		hasAttacked = true
	
	$AnimationTree.get("parameters/playback").travel("Attack")

func attackEnd():
	state = MOVE
	hasAttacked = false

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

func getInput():
	#Temporary Code
	if hotbar.items[0] != "":
		useCustomCursor = true
		$CursorAnimation.play("Cursor")
	else:
		useCustomCursor = false
		$CursorAnimation.stop()
	
	if !disableAllIn:
		if Input.is_action_just_pressed("ctrl_interact"):
			if interact != null and !disableIn: interact.interact(self)
		
		if Input.is_action_just_pressed("ctrl_attack_primary"):
			if !disableIn: state = ATTACK
		
		if Input.is_action_just_pressed("ctrl_console") and !isInGUI:
			if gui != null:
				gui.get_node("Console").toggle()
				isInGUI = !isInGUI
				currGUI = "console"
			
		if Input.is_action_just_pressed("ctrl_inventory") and (!isInGUI or (isInGUI and currGUI == "inventory")):
			if gui != null:
				gui.get_node("Inventory").toggle()
				isInGUI = !isInGUI
				currGUI = "inventory"
				
		if Input.is_action_just_pressed("debug_toggle"):
			if gui != null:
				gui.get_node("Debug").toggle()
		
		if Input.is_action_just_pressed("ui_cancel"):
			if gui != null:
				if isInGUI:
					match currGUI:
						"console":
							gui.get_node("Console").toggle()
						"inventory":
							gui.get_node("Inventory").toggle()
					
					isInGUI = false
				else:
					gui.get_node("QuickMenu").toggle()
					yield(get_tree().create_timer(0.1), "timeout")

func enableGlow():
	$Light2D.show()

func disableGlow():
	$Light2D.hide()

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
		
		Input.set_custom_mouse_cursor(cursor, 0, Vector2(32, 32))
	else: Input.set_custom_mouse_cursor(null)
