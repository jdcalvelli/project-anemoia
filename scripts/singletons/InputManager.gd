extends Node

enum AnalogSticks {
	LEFT,
	RIGHT,
}

# needed for double stick click
var doubleClickScenario := false

# needed for rotate and flick
var input_vec:= Vector2(0,0)
var current_angle := 0.0
var previous_angle := 0.0
var current_pos := Vector2(0,0)
var previous_pos := Vector2(0,0)

# needed for rotate
var rotateFlags := [0,0,0,0,0,0]

# needed for rock
var rockFlags := [0,0,0,0,0,0]
var isRockingUp := false

# needed for trigger
var triggerHeld := [0,0] 

# process func for the analog stick motions
func _physics_process(_delta):

	# determine which stick we care about
	match GameManager.currentShot.currentCharacter:
		GameManager.Characters.FATHER:
			input_vec = Input.get_vector(
				"left-analog-left",
				"left-analog-right", 
				"left-analog-down", 
				"left-analog-up"
				)
		GameManager.Characters.MOTHER:
			input_vec = Input.get_vector(
				"right-analog-left",
				"right-analog-right",
				"right-analog-down",
				"right-analog-up"
				)

# input func for stick clicks ONLY
func _input(event):
	if event.is_action_pressed("right-bumper-press"):
		EventBus.rightBumperPress.emit()
	elif event.is_action_pressed("restart-button"):
		get_tree().change_scene_to_file("res://scenes/onboard/opening_scene.tscn")
	elif event.is_action_pressed("period-button"):
		# move to the next scene in the assigned shot counter
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(GameManager.currentShot.nextShot))
	elif event.is_action_pressed("comma-button"):
		# move to the next scene in the assigned shot counter
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(GameManager.currentShot.prevShot))

	# for trigger holding
	if event.is_action_pressed("left-trigger-press"):
		triggerHeld[0] = 1
	elif event.is_action_released("left-trigger-press"):
		triggerHeld[0] = 0
	if event.is_action_pressed("right-trigger-press"):
		triggerHeld[1] = 1
	elif event.is_action_released("right-trigger-press"):
		triggerHeld[1] = 0



# ### helper funcs ###

func joy_rotate(input_vec:Vector2):
	# mariokart flag method
	current_pos = input_vec
	
	current_angle = atan2(input_vec.y, input_vec.x)
	
	# need to have some sort of drop logic i think
	# if the vector distance is ever less than 0.9, reset rotate flags
	if Vector2(0,0).distance_to(input_vec) <= 0.7:
		# print("drop")
		rotateFlags = [0,0,0,0,0,0]
		return
		
	if current_angle < -2*PI/3 and previous_angle > -2*PI/3 and !rotateFlags[0]:
		#print("passed flag 1")
		rotateFlags[0] = 1
		# audio related
		EventBus.actionStarted.emit()
	elif current_angle > PI - 0.2 and previous_angle < PI - 0.2 and rotateFlags[0]:
		#print("passed flag 2")
		rotateFlags[0] = 0
		rotateFlags[1] = 1
	elif current_angle < 2*PI/3 and previous_angle > 2*PI/3 and rotateFlags[1]:
		#print("passed flag 3")
		rotateFlags[1] = 0
		rotateFlags[2] = 1
	elif current_angle < PI/3 and previous_angle > PI/3 and rotateFlags[2]:
		#print("passed flag 4")
		rotateFlags[2] = 0
		rotateFlags[3] = 1
	elif current_angle < 0 and previous_angle > 0 and rotateFlags[3]:
		#print("passed flag 5")
		rotateFlags[3] = 0
		rotateFlags[4] = 1
	elif current_angle < -PI/3 and previous_angle > -PI/3 and rotateFlags[4]:
		#print("passed flag 6")
		rotateFlags[4] = 0
		rotateFlags[5] = 1
		
	if rotateFlags[5]:
		# print("full rotation")
		rotateFlags = [0,0,0,0,0,0]
		match GameManager.currentShot.currentCharacter:
			GameManager.Characters.FATHER:
				# for audio
				EventBus.actionCompleted.emit()
				# for logic
				EventBus.analogRotate.emit(AnalogSticks.LEFT)
			GameManager.Characters.MOTHER:
				EventBus.actionCompleted.emit()
				EventBus.analogRotate.emit(AnalogSticks.RIGHT)
		
	# frame updates
	previous_angle = current_angle

func joy_rock(input_vec:Vector2):
	# this can be angleless
	current_pos = input_vec
	
	#print(current_pos.y)
	
	# should include an x check so that we stay within a box
	if current_pos.x >= 0.8 or current_pos.x <= -0.8:
		# print("reset bc too far on x")
		rockFlags = [0,0,0,0,0,0]
		isRockingUp = false
		return
	
	#print(current_pos.y * 100)
	#print(rockFlags)
	
	if !isRockingUp:
		if current_pos.y <= -0.9 and rockFlags[1]:
			# print("flag 3")
			rockFlags[2] = 1
			isRockingUp = true
		elif current_pos.y <= -0.5 and rockFlags[0]:
			# print("flag 2")
			rockFlags[1] = 1
		elif current_pos.y <= -0.1 and !rockFlags[0]:
			# print("flag 1")
			rockFlags[0] = 1
			EventBus.actionStarted.emit()
	elif isRockingUp:
		if current_pos.y >= 0.9 and rockFlags[4]:
			# print("flag 6")
			rockFlags[5] = 1
		elif current_pos.y >= 0.5 and rockFlags[3]:
			# print("flag 5")
			rockFlags[4] = 1
		elif current_pos.y >= 0.1 and rockFlags[2]:
			# print("flag 4")
			rockFlags[3] = 1
	
	if rockFlags[5]:
		# print("complete rock")
		rockFlags = [0,0,0,0,0,0]
		isRockingUp = false
		match GameManager.currentShot.currentCharacter:
			GameManager.Characters.FATHER:
				EventBus.actionCompleted.emit()
				EventBus.analogFlick.emit(AnalogSticks.LEFT)
			GameManager.Characters.MOTHER:
				EventBus.actionCompleted.emit()
				EventBus.analogFlick.emit(AnalogSticks.RIGHT)
	
	# prev/curr frame updates
	previous_pos = current_pos
