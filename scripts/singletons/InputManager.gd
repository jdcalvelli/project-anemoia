extends Node

enum AnalogSticks {
	LEFT,
	RIGHT,
	BOTH
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

# process func for the analog stick motions
func _physics_process(delta):
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
	# if we're in a double click , stop listening for events here
	if doubleClickScenario:
		return
	
	if event.is_action_pressed("left-stick-click"):
		# wait and see if the second click happens
		await wait_for_second_stick(AnalogSticks.RIGHT)
		# should the post wait for second click be here?
	elif event.is_action_pressed("right-stick-click"):
		# wait and see if the second click happens
		await wait_for_second_stick(AnalogSticks.LEFT)
		# should the post wait for second click be here?
	else:
		# if its anything else, dont do anything
		return

# ### helper funcs ###

func wait_for_second_stick(secondStick:AnalogSticks):
	doubleClickScenario = true
	var timer = 0
	
	match secondStick:
		AnalogSticks.RIGHT:
			# quarter sec to click both
			while timer < 15:
				if Input.is_action_just_pressed("right-stick-click"):
					#print("BOTH")
					EventBus.analogClick.emit(AnalogSticks.BOTH)
					doubleClickScenario = false
					return
				timer += 1
				await get_tree().create_timer(1/60).timeout
			# else print just left
			print("KEEP JUST LEFT")
			EventBus.analogClick.emit(AnalogSticks.LEFT)
			doubleClickScenario = false
		AnalogSticks.LEFT:
			# quarter sec to click both
			while timer < 15:
				if Input.is_action_just_pressed("left-stick-click"):
					# print("BOTH")
					EventBus.analogClick.emit(AnalogSticks.BOTH)
					doubleClickScenario = false
					return
				timer += 1
				await get_tree().create_timer(1/60).timeout
			#else just print right
			print("KEEP JUST RIGHT")
			EventBus.analogClick.emit(AnalogSticks.RIGHT)
			doubleClickScenario = false

func joy_rotate(input_vec:Vector2):
	# mariokart flag method
	current_pos = input_vec
	
	current_angle = atan2(input_vec.y, input_vec.x)
	
	# need to have some sort of drop logic i think
	# if the vector distance is ever less than 0.9, reset rotate flags
	if Vector2(0,0).distance_to(input_vec) <= 0.9:
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
		rotateFlags[2] = 2
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
		print("full rotation")
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
	
	# should include an x check so that we stay within a box
	
	if current_pos.y < -0.25 and previous_pos.y > -0.25 and !rockFlags[0]:
		#print("first flag")
		rockFlags[0] = 1
		EventBus.actionStarted.emit()
		EventBus.changeAnimState.emit(1)
	if current_pos.y < -0.50 and previous_pos.y > -0.50 and rockFlags[0]:
		#print("second flag")
		rockFlags[1] = 1
		EventBus.changeAnimState.emit(2)
	if current_pos.y < -0.75 and previous_pos.y > -0.75 and rockFlags[1]:
		#print("third flag")
		rockFlags[2] = 1
		EventBus.changeAnimState.emit(3)
	if current_pos.y > 0.25 and previous_pos.y < 0.25 and rockFlags[2]:
		#print("fourth flag")
		rockFlags[3] = 1
		EventBus.changeAnimState.emit(4)
	if current_pos.y > 0.50 and previous_pos.y < 0.50 and rockFlags[3]:
		#print("fifth flag")
		rockFlags[4] = 1
		EventBus.changeAnimState.emit(5)
	if current_pos.y > 0.75 and previous_pos.y < 0.75 and rockFlags[4]:
		#print("sixth flag")
		rockFlags[5] = 1
		EventBus.changeAnimState.emit(6)
	
	if rockFlags[5]:
		print("complete rock")
		rockFlags = [0,0,0,0,0,0]
		match GameManager.currentShot.currentCharacter:
			GameManager.Characters.FATHER:
				EventBus.actionCompleted.emit()
				EventBus.analogFlick.emit(AnalogSticks.LEFT)
			GameManager.Characters.MOTHER:
				EventBus.actionCompleted.emit()
				EventBus.analogFlick.emit(AnalogSticks.RIGHT)
	
	# prev/curr frame updates
	previous_pos = current_pos
