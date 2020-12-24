extends KinematicBody2D

export (String) var id
export (String) var element
export (int) var speed
export (int) var lifetime
export (int) var damage

enum {
	UNINIT,
	CREATE,
	MOVE,
	DESTROY,
	DESPAWN
}

var state = UNINIT
var health = -1

var dir = Vector2()
var vel = Vector2()

var animationEnd = false
var allowMovement = true

var eat = false
var created = false

var creator = null

func _ready():
	$Timer.connect("timeout", self, "_onTimeout")
	$Timer.wait_time = lifetime
	
	$Creation.connect("timeout", self, "_onCreated")
	$Hitbox.connect("area_entered", self, "_onAreaEntered")

func init(dir, allowMovement = true):
	self.dir = dir
	$AnimationTree.set("parameters/Creation/blend_position", dir)
	$AnimationTree.set("parameters/Travel/blend_position", dir)
	$AnimationTree.set("parameters/Destruction/blend_position", dir)
	
	self.allowMovement = allowMovement
	state = CREATE

func changeDir(dir):
	self.dir = dir
	$AnimationTree.set("parameters/Creation/blend_position", dir)
	$AnimationTree.set("parameters/Travel/blend_position", dir)
	$AnimationTree.set("parameters/Destruction/blend_position", dir)

func enableMovement():
	allowMovement = true
	$Timer.start()
	$Creation.start()

func _physics_process(delta):
	match state:
		UNINIT:
			return
		CREATE:
			create(delta)
		MOVE:
			move(delta)
		DESTROY:
			destroy(delta)
		DESPAWN:
			despawn(delta)

func _onCreated():
	created = true

func create(delta):
	$AnimationTree.get("parameters/playback").travel("Creation")

func move(delta):
	if !allowMovement: return
	vel = dir * speed * delta
	vel = move_and_slide(vel)

func destroy(delta):
	$AnimationTree.get("parameters/playback").travel("Destruction")

func despawn(delta):
	get_parent().remove_child(self)
	queue_free()

func _onTimeout():
	state = DESTROY

func createEnd():
	for a in $Hitbox.get_overlapping_areas():
		if "Hurtbox" in a.name:
			creator = a.get_parent()
			break
	
	state = MOVE
	
	if allowMovement:
		$Timer.start()
		$Creation.start()
	
	$AnimationTree.get("parameters/playback").travel("Travel")

func destructionEnd():
	state = DESPAWN

func changeDimension(dimension):
	pass

func _onAreaEntered(area):
	var body = area.get_parent()
	if !created and (creator == body or creator == null): return
	
	if "Eatbox" in area.name:
		if "EnemySlime" in body.name:
			body.state = 4             # state = TRANS_INIT
			body.transTarget = element
		
		eat = true
	
	if "Consumebox" in area.name and eat:
		state = DESTROY
	
	elif "Hurtbox" in area.name and !eat:
		if "Player" in body.name:
			body._onReceiveDamage(damage)
		state = DESTROY
