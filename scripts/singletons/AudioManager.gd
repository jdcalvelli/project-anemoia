extends Node

var mainBusIndex:int
var mainBusLowPass:AudioEffectLowPassFilter

func _ready():
	mainBusIndex = AudioServer.get_bus_index("Master")
	mainBusLowPass = AudioServer.get_bus_effect(mainBusIndex, 0)
	
func changeLowPassState(timerIndex:int):
	match timerIndex:
		0:
			mainBusLowPass.cutoff_hz = lerpf(
				mainBusLowPass.cutoff_hz,
				800,
				0.3
			)
		1: 
			mainBusLowPass.cutoff_hz = lerpf(
				mainBusLowPass.cutoff_hz,
				400,
				0.3
			)
		2:
			mainBusLowPass.cutoff_hz = lerpf(
				mainBusLowPass.cutoff_hz,
				100,
				0.3
			)
