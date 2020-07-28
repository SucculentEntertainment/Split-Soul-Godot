extends CanvasLayer

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

func _ready():
	if enableRetroMode:
		$ColorRect.material.set_shader_param("enableCurve", enableCurve)
		$ColorRect.material.set_shader_param("curveIntensity", curveIntensity)
		$ColorRect.material.set_shader_param("zoomLevel", zoomLevel)
		
		$ColorRect.material.set_shader_param("enableChromaShift", enableChromaShift)
		$ColorRect.material.set_shader_param("redShift", redShift)
		$ColorRect.material.set_shader_param("greenShift", greenShift)
		$ColorRect.material.set_shader_param("blueShift", blueShift)
		
		$ColorRect.material.set_shader_param("enableScanlines", enableScanlines)
		$ColorRect.material.set_shader_param("numScanlines", numScanlines)
