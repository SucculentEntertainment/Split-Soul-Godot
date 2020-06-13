extends StaticBody2D

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
	pass

# ================================
# Interaction
# ================================

func _onEntered(body):
	if "Player" in body.name:
		$E.show()

func _onExited(body):
	if "Player" in body.name:
		$E.hide()
