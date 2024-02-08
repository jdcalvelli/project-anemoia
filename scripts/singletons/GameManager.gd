extends Node

enum Characters {
	FATHER,
	MOTHER
}

# game state
# set by the scene itself
var currentCharacter: Characters = Characters.FATHER
var currentDay: int
var currentShot: int

var reverseActions = false

func _ready():
	EventBus.analogClick.connect(_on_stick_click)
	EventBus.analogRotate.connect(_on_analog_rotate)
	EventBus.analogFlick.connect(_on_analog_flick)

func _on_stick_click(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentCharacter == Characters.FATHER:
				print("advance father story")
		InputManager.AnalogSticks.RIGHT:
			if currentCharacter == Characters.MOTHER:
				print("advance mother story")
				
func _on_analog_rotate(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if !reverseActions:
				print("father rotate")
		InputManager.AnalogSticks.RIGHT:
			if reverseActions:
				print("mother rotate")
			
func _on_analog_flick(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if reverseActions:
				print("father flick")
		InputManager.AnalogSticks.RIGHT:
			if !reverseActions:
				print("mother flick")
	
