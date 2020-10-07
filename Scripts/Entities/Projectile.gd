extends KinematicBody2D

export (String) var id
export (int) var speed
export (int) var lifetime

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

func _ready():
	$Timer.connect("timeout", self, "_onTimeout")
	$Timer.wait_time = lifetime
	
	$Creation.connect("timeout", self, "_onCreated")
	$Creation.start()
	
	$Hitbox.connect("body_entered", self, "_onBodyEntered")

func init(dir):
	self.dir = dir
	$AnimationTree.set("parameters/Creation/blend_position", dir)
	$AnimationTree.set("parameters/Travel/blend_position", dir)
	$AnimationTree.set("parameters/Destruction/blend_position", dir)
	
	state = CREATE

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
	$Hitbox/CollisionShape2D.disabled = false

func create(delta):
	$AnimationTree.get("parameters/playback").travel("Creation")

func move(delta):
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
	state = MOVE
	
	$Timer.start()
	$AnimationTree.get("parameters/playback").travel("Travel")

func destructionEnd():
	state = DESPAWN

func changeDimension(dimension):
	pass

func _onBodyEntered(body):
	if "EnemySlime" in body.name:
		body.changeType("e_fireSlime")
	state = DESTROY
