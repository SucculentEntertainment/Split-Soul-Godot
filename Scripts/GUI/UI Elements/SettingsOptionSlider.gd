extends Control

onready var def = get_node("/root/Definitions")

var category = ""
var key = ""

var programChanged = false

func _ready():
	$Content/Slider.connect("value_changed", self, "_onSliderChanged")
	$Content/Text/Value.connect("text_changed", self, "_onTextChanged")

func init(categoryName, text, minVal, maxVal, stepSize, key):
	$Content/Text/Title.text = text
	
	category = categoryName
	self.key = key
	
	$Content/Slider.min_value = minVal
	$Content/Slider.max_value = maxVal
	$Content/Slider.step = stepSize
	
	$Content/Slider.value = def.CONFIG.get_value(category, key)

func _onSliderChanged(value):
	if programChanged:
		return
	
	programChanged = true
	$Content/Text/Value.text = str(value)
	programChanged = false
	
	updateConfig(value)

func _onTextChanged(text):
	if programChanged or text == "":
		return
	
	var caretPos = $Content/Text/Value.caret_position
	programChanged = true
	
	if not text.is_valid_float():
		$Content/Text/Value.text = str(float(text))
	
	if float(text) > $Content/Slider.max_value:
		$Content/Text/Value.text = str($Content/Slider.max_value)
	
	$Content/Text/Value.caret_position = caretPos
	$Content/Slider.value = float(text)
	
	programChanged = false
	updateConfig(float(text))

func updateConfig(value):
	def.CONFIG.set_value(category, key, value)
