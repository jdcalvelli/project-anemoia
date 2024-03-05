extends Node

enum Characters {
	FATHER,
	MOTHER,
	BOTH,
	AUTO,
}

# current shot reference
var currentShot: Shot
var nextScene: PackedScene
# this will be refactored out?
var goNextWaitTime: float = 1.5
# another example of should be a new class for each character
var autoRunOnce = false

func _ready():
	EventBus.analogClick.connect(_on_stick_click)
	EventBus.analogRotate.connect(_on_analog_rotate)
	EventBus.analogFlick.connect(_on_analog_flick)

func _physics_process(delta):
	# if we're over the num shots
	if currentShot.numActionsTaken >= currentShot.numRequiredActions and currentShot.numRequiredActions != 0:
		return
	
	# listen for the right kind of input depending on char
	if currentShot.currentCharacter == Characters.FATHER:
		if currentShot.actionScene and !currentShot.reverseActions:
			InputManager.joy_rotate(InputManager.input_vec)
		elif currentShot.actionScene and currentShot.reverseActions:
			InputManager.joy_rock(InputManager.input_vec)
	elif currentShot.currentCharacter == Characters.MOTHER:
		if currentShot.actionScene and !currentShot.reverseActions:
			InputManager.joy_rock(InputManager.input_vec)
		elif currentShot.actionScene and currentShot.reverseActions:
			InputManager.joy_rotate(InputManager.input_vec)
	elif currentShot.currentCharacter == Characters.AUTO:
		# do a wait for a period of time, then execute the move to the next scene
		await get_tree().create_timer(currentShot.autoCharacterWaitTime).timeout
		if !autoRunOnce:
			# this should only happen once!
			print("test")
			# also the loading next scene logic is going to fundamentally change
			get_tree().change_scene_to_packed(nextScene)
			autoRunOnce = true
	# both is handled in inputmanager input function - should that move?

func _on_stick_click(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentShot.currentCharacter == Characters.FATHER:
				if !currentShot.actionScene:
					get_tree().change_scene_to_packed(nextScene)
		InputManager.AnalogSticks.RIGHT:
			if currentShot.currentCharacter == Characters.MOTHER:
				if !currentShot.actionScene:
					get_tree().change_scene_to_packed(nextScene)
		InputManager.AnalogSticks.BOTH:
			if currentShot.currentCharacter == Characters.BOTH:
				if !currentShot.actionScene:
					get_tree().change_scene_to_packed(nextScene)

func _on_analog_rotate(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if !currentShot.reverseActions and currentShot.actionScene:
				print("father rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(nextScene)
		InputManager.AnalogSticks.RIGHT:
			if currentShot.reverseActions and currentShot.actionScene:
				print("mother rotate")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(nextScene)
			
func _on_analog_flick(stick:InputManager.AnalogSticks):
	match stick:
		InputManager.AnalogSticks.LEFT:
			if currentShot.reverseActions and currentShot.actionScene:
				print("father flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(nextScene)
		InputManager.AnalogSticks.RIGHT:
			if !currentShot.reverseActions and currentShot.actionScene:
				print("mother flick")
				currentShot.numActionsTaken += 1
				if currentShot.numActionsTaken == currentShot.numRequiredActions:
					# adding wait on scene change
					await get_tree().create_timer(goNextWaitTime).timeout
					get_tree().change_scene_to_packed(nextScene)
	
