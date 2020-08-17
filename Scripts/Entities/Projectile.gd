extends KinematicBody2D

export (String) var id
export (int) var speed
export (int) var lifetime

enum {
	CREATE,
	MOVE,
	DESTROY
}

var state = CREATE
var health = -1

var dir = Vector2()
var vel = Vector2()

var initiated = false

func _ready():
	$Timer.connect("timeout", self, "_onTimeout")
	$Timer.wait_time = lifetime

func init(dir):
	self.dir = dir
	look_at((get_transform().origin + dir) * Vector2(-1, -1))
	
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

func create(delta):
	$AnimationPlayer.play("Creation")
	yield($AnimationPlayer, "animation_finished")
	
	state = MOVE
	
	$Timer.start()
	$AnimationPlayer.play("Travel")

func move(delta):
	vel = dir * speed * delta
	vel = move_and_slide(vel)

func destroy(delta):
	$AnimationPlayer.play("Destruction")
	yield($AnimationPlayer, "animation_finished")
	
	queue_free()

func _onTimeout():
	state = DESTROY
