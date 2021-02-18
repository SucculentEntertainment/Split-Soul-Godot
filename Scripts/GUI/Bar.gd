extends Control

export (Color) var high
export (Color) var mid
export (Color) var low

export (bool) var disableEffect = false
export (bool) var enableText = false

func changeValue(value, maxValue):
	$Normal.max_value = maxValue
	$Effect.max_value = maxValue
	
	if enableText: 
		$Label.show()
		$Label.text = str(value) + " / " + str(maxValue)
	else:
		$Label.hide()
	
	if $Normal.value != value:
		$Normal.value = value
		if !disableEffect:
			$Tween.interpolate_property($Effect, "value", $Effect.value, value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
	
	if float(value) / float(maxValue) <= 0.25: $Normal.tint_progress = low
	elif float(value) / float(maxValue) <= 0.5: $Normal.tint_progress = mid
	else: $Normal.tint_progress = high
