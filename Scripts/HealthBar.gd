extends Control

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

func changeHealth(health):
	if $Normal.value != health:
		$Normal.value = health
		$Tween.interpolate_property($Effect, "value", $Effect.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
	
	if health < 25: $Normal.tint_progress = critical
	elif health < 50: $Normal.tint_progress = damaged
	else: $Normal.tint_progress = healthy
