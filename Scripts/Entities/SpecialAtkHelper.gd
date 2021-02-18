extends Node

onready var p = self.get_parent()
onready var id = p.id
onready var damage = p.damage

var move = false

# ================================================================
# AI
# ================================================================

func checkUsefull():
	match id:
		"e_slime":
			if p.player != null and p.global_position.distance_to(p.player.global_position) > p.interestRange:
				return true
	
	return false

# ================================================================
# Attack
# ================================================================

func init():
	p.state = 6   # p.state = ATTACK_SPECIAL

func attack(delta):
	p.get_node("AnimationTree").get("parameters/playback").travel("Attack_Special")
	
	match id:
		"e_slime":
			p.damage = damage * 2
			
			if !move:
				p.dir = p.global_position.direction_to(p.player.global_position)
			
			if move:
				p.vel = p.dir * p.speed * delta * 2.5
				p.vel = p.move_and_slide(p.vel)
			
			p.damage = damage

func finish():
	p.state = 0   # p.state = IDLE
	p.specialCooldown = true
	p.get_node("SpecialCooldown").start()

# ================================================================
# Functions called by Animations
# ================================================================

func sj_startMovement():
	move = true

func sj_endMovement():
	move = false
