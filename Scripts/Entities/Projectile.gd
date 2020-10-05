extends KinematicBody2D

export (String) var id
export (int) var speed
export (int) var lifetime

enum {
	CREATE,
	MOVE,
	DESTROY,
	DESPAWN
}

var state = CREATE
var health = -1

var dir = Vector2()
var vel = Vector2()

var initiated = false
var animationEnd = false

func _ready():
	$Timer.connect("timeout", self, "_onTimeout")
	$Timer.wait_time = lifetime

func init(dir):
	self.dir = dir
	$AnimationTree.set("parameters/Creation/blend_position", dir)
	$AnimationTree.set("parameters/Travel/blend_position", dir)
	$AnimationTree.set("parameters/Destruction/blend_position", dir)
	
	initiated = true

func _physics_process(delta):
	if !initiated:
		return
	
	match state:
		CREATE:
			create(delta)
		MOVE:
			move(delta)
		DESTROY:
			destroy(delta)
		DESPAWN:
			despawn(delta)

func create(delta):
	$AnimationTree.get("parameters/playback").travel("Creation")

func move(delta):
	vel = dir * speed * delta
	vel = move_and_slide(vel)

func destroy(delta):
	$AnimationTree.get("parameters/playback").travel("Destruction")

func despawn(delta):
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
