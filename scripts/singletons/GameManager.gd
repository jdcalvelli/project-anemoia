extends Node

enum Characters {
	FATHER,
	MOTHER
}

# current shot reference
var currentShot: Shot

func _ready():
	EventBus.analogClick.connect(_on_stick_click)
	EventBus.analogRotate.connect(_on_analog_rotate)
	EventBus.analogFlick.connect(_on_analog_flick)

func _on_stick_click(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentShot.currentCharacter == Characters.FATHER:
				if !currentShot.actionScene:
					get_tree().change_scene_to_file(currentShot.nextShot)
		InputManager.AnalogSticks.RIGHT:
			if currentShot.currentCharacter == Characters.MOTHER:
				if !currentShot.actionScene:
					get_tree().change_scene_to_file(currentShot.nextShot)
				
func _on_analog_rotate(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if !currentShot.reverseActions and currentShot.actionScene:
				print("father rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					get_tree().change_scene_to_file(currentShot.nextShot)
		InputManager.AnalogSticks.RIGHT:
			if currentShot.reverseActions and currentShot.actionScene:
				print("mother rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					get_tree().change_scene_to_file(currentShot.nextShot)
			
func _on_analog_flick(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentShot.reverseActions and currentShot.actionScene:
				print("father flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					get_tree().change_scene_to_file(currentShot.nextShot)
		InputManager.AnalogSticks.RIGHT:
			if !currentShot.reverseActions and currentShot.actionScene:
				print("mother flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					get_tree().change_scene_to_file(currentShot.nextShot)
	
