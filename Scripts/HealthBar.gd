extends Control

export (Color) var healthy
export (Color) var damaged
export (Color) var critical

export (bool) var disableEffect = false

func changeHealth(health, maxHealth):
	$Normal.max_value = maxHealth
	$Effect.max_value = maxHealth
	
	if $Normal.value != health:
		$Normal.value = health
		if !disableEffect:
			$Tween.interpolate_property($Effect, "value", $Effect.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
	
	if float(health / maxHealth) < 0.25: $Normal.tint_progress = critical
	elif float(health / maxHealth) < 0.5: $Normal.tint_progress = damaged
	else: $Normal.tint_progress = healthy
