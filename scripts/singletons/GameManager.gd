extends Node

enum Characters {
	FATHER,
	MOTHER,
	AUTO,
	CAMERA,
}

# current shot reference
var currentShot: Shot
# this will be refactored out?
var goNextWaitTime: float = 1.5

func _ready():
	EventBus.analogRotate.connect(_on_analog_rotate)
	EventBus.analogFlick.connect(_on_analog_flick)
	EventBus.shutterComplete.connect(_on_shutter_complete)

func _physics_process(_delta):
	# if we're over the num shots
	if currentShot.numActionsTaken >= currentShot.numRequiredActions and currentShot.numRequiredActions != 0:
		return
	
	# listen for the right kind of input depending on char
	if currentShot.currentCharacter == Characters.FATHER:
		if !currentShot.reverseActions:
			InputManager.joy_rotate(InputManager.input_vec)
		else:
			InputManager.joy_rock(InputManager.input_vec)
	elif currentShot.currentCharacter == Characters.MOTHER:
		if !currentShot.reverseActions:
			InputManager.joy_rock(InputManager.input_vec)
		else:
			InputManager.joy_rotate(InputManager.input_vec)
	# both is handled in inputmanager input function - should that move?

func _on_shutter_complete():
	# handle logic	
	currentShot.numActionsTaken += 1
	if currentShot.currentCharacter == Characters.CAMERA:
		if currentShot.numActionsTaken == currentShot.numRequiredActions:
			await get_tree().create_timer(goNextWaitTime * 10).timeout
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentShot.nextShot))

func _on_analog_rotate(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if !currentShot.reverseActions:
				# print("father rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# emit total actions completed
					EventBus.totalActionsCompleted.emit()
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentShot.nextShot))
		InputManager.AnalogSticks.RIGHT:
			if currentShot.reverseActions:
				# print("mother rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# emit total actions completed
					EventBus.totalActionsCompleted.emit()
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentShot.nextShot))

func _on_analog_flick(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentShot.reverseActions:
				# print("father flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# emit total actions completed
					EventBus.totalActionsCompleted.emit()
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentShot.nextShot))
		InputManager.AnalogSticks.RIGHT:
			if !currentShot.reverseActions:
				# print("mother flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# emit total actions completed
					EventBus.totalActionsCompleted.emit()
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentShot.nextShot))

