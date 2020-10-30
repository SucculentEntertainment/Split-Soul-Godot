extends CanvasLayer

onready var def = get_node("/root/Definitions")

export (bool) var enableRetroMode

export (bool) var enableCurve
export (float, 0.0, 9.0) var curveIntensity
export (float, 1.0, 2.0) var zoomLevel

export (bool) var enableChromaShift
export (float, -10.0, 10.0) var redShift
export (float, -10.0, 10.0) var greenShift
export (float, -10.0, 10.0) var blueShift

export (bool) var enableScanlines
export (float, 0.0, 720.0) var numScanlines

var settings = false

func _ready():
	def.connect("settingsUpdateStart", self, "toggleSettings")
	def.connect("settingsUpdateStop", self, "toggleSettings")
	
	updateConfig()
	updateShader()

func updateShader():
	if enableRetroMode:
		$ColorRect.show()
		
		$ColorRect.material.set_shader_param("enableCurve", enableCurve)
		$ColorRect.material.set_shader_param("curveIntensity", curveIntensity)
		$ColorRect.material.set_shader_param("zoomLevel", zoomLevel)
		
		$ColorRect.material.set_shader_param("enableChromaShift", enableChromaShift)
		$ColorRect.material.set_shader_param("redShift", redShift)
		$ColorRect.material.set_shader_param("greenShift", greenShift)
		$ColorRect.material.set_shader_param("blueShift", blueShift)
		
		$ColorRect.material.set_shader_param("enableScanlines", enableScanlines)
		$ColorRect.material.set_shader_param("numScanlines", numScanlines)
	else:
		$ColorRect.hide()

func toggleSettings():
	settings = !settings

func _process(_delta):
	if !settings:
		return
	
	updateConfig()
	updateShader()

func updateConfig():
	enableRetroMode = def.CONFIG.get_value("video", "retroMode")
	
	enableCurve = def.CONFIG.get_value("video", "retroModeCurve")
	curveIntensity = def.CONFIG.get_value("video", "retroModeCurveIntensity")
	zoomLevel = def.CONFIG.get_value("video", "retroModeZoomLevel")
	
	enableChromaShift = def.CONFIG.get_value("video", "retroModeChroma")
	redShift = def.CONFIG.get_value("video", "retroModeChromaRed")
	greenShift = def.CONFIG.get_value("video", "retroModeChromaGreen")
	blueShift = def.CONFIG.get_value("video", "retroModeChromaBlue")
	
	enableScanlines = def.CONFIG.get_value("video", "retroModeScanlines")
	numScanlines = def.CONFIG.get_value("video", "retroModeScanlinesAmount")
