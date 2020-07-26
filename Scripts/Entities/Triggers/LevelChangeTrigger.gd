extends Position2D

onready var def = get_node("/root/Definitions")

export (bool) var needsInteract = false
export (String) var targetLevel = ""
export (String) var layer = ""
var triggered = false

func _ready():
	$Interaction.connect("body_entered", self, "_onEntered")
	$Interaction.connect("body_exited", self, "_onExited")

func initialize(_level, _player, layer):
	self.layer = layer

func changeDimension(dimension):
	if dimension == layer:
		$Interaction/CollisionShape2D.disabled = false
		
		var bodies = $Interaction.get_overlapping_bodies()
		for body in bodies:
			if "Player" in body.name:
				$E.show()
				body.interact = self
	else:
		$Interaction/CollisionShape2D.disabled = true

func _onEntered(body):
	if "Player" in body.name:
		if needsInteract:
			$E.show()
			body.interact = self
		else:
			interact(body)

func _onExited(body):
	if "Player" in body.name:
		if needsInteract:
			$E.hide()
			body.interact = null

func interact(player):
	if triggered: return
	
	triggered = true
	player.get_parent().emit_signal("changeLevel", targetLevel, layer)
