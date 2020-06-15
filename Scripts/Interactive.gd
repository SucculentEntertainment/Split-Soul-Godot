extends StaticBody2D

onready var def = get_node("/root/Definitions")
onready var vars = get_node("/root/PlayerVars")

export (String) var interactableName
export (int, FLAGS, "Alive", "Dead") var layer
export (Array, SpriteFrames) var textures
export (int, FLAGS, "Alive", "Dead") var canInteract

var currentDimension = 0

# ================================
# Util
# ================================

func _ready():
	$Interaction.connect("body_entered", self, "_onEntered")
	$Interaction.connect("body_exited", self, "_onExited")

# ================================
# Actions
# ================================

func changeDimension(dimension):
	if dimension & layer != 0:
		show()
		$CollisionShape2D.disabled = false;
		if dimension & canInteract != 0: 
			$Interaction/CollisionShape2D.disabled = false;
		else:
			$Interaction/CollisionShape2D.disabled = true;
		
		if textures.size() > def.logB(dimension, 2):
			$AnimatedSprite.frames = textures[def.logB(dimension, 2)]
	else:
		hide()
		$CollisionShape2D.disabled = true;
		$Interaction/CollisionShape2D.disabled = true;

# ================================
# Interaction
# ================================

func _onEntered(body):
	if "Player" in body.name:
		$E.show()
		body.interact = self

func _onExited(body):
	if "Player" in body.name:
		$E.hide()
		body.interact = null

func interact(player):
	if interactableName == "Altar":
		player.changeDimension(def.DIMENSION_ALIVE)
		vars.dead = false
