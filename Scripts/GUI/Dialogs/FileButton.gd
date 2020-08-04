extends Button

signal selected(btn, name)

func _ready():
	connect("button_down", self, "_onBtnDown")

func formatDate(date):
	var dateStr = "%02d.%02d.%04d %02d:%02d"
	
	if date != null:
		dateStr = dateStr % [date.day, date.month, date.year, date.hour, date.minute]
	else:
		dateStr = "Failed to load Date"
	
	return dateStr

func create(name, date):
	$Content/Data/Name.text = name
	$Content/Data/Timestamp/Timestamp.text = formatDate(date)

func _onBtnDown():
	emit_signal("selected", self, $Content/Data/Name.text)
	$Content/SelectIndicator.show()

func deselect():
	$Content/SelectIndicator.hide()
