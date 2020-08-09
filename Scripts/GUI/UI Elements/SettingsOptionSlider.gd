extends Control

func _ready():
	pass

func init(text, minVal, maxVal, stepSize):
	$Content/Text/Title.text = text
	
	$Content/Slider.min_value = minVal
	$Content/Slider.max_value = maxVal
	$Content/Slider.step = stepSize

func _process(_delta):
	$Content/Text/Value.text = str($Content/Slider.value)
