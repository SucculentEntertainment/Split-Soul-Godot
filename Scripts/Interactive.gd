extends StaticBody2D

export (String) var interactableName

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
		body.interact = self

func _onExited(body):
	if "Player" in body.name:
		$E.hide()
		body.interact = null

func interact():
	if interactableName == "Altar":
		print("<Insert Dimension change here>")
