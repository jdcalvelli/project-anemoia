extends Node

enum Characters {
	FATHER,
	MOTHER,
	AUTO,
	CAMERA,
	BUMPER
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
	# this should be refactored to a pause when we do hard stop
	FMODRuntime.studio_system.get_bus("bus:/").set_paused(!Engine.time_scale)
	
	# IF THE CURRENT SHOT CHARACTER IS NOT AUTO, DONT CARE ABOUT TRIGGER
	if currentShot.currentCharacter == Characters.AUTO:
		# time scale check
		if InputManager.triggerHeld.any(func(e): return e == 1):
			Engine.time_scale = 1
		else:
			Engine.time_scale = 0
	
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
			await get_tree().create_timer(goNextWaitTime * 6).timeout
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

