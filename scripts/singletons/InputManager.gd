extends Node

enum AnalogSticks {
	LEFT,
	RIGHT
}

# needed for rotate and flick
var input_vec:= Vector2(0,0)
var current_angle := 0.0
var previous_angle := 0.0
var current_pos := Vector2(0,0)
var previous_pos := Vector2(0,0)

# needed for rotate
var rotateFlags := [0,0,0,0,0,0]

# needed for rock
var hitTop := false
var hitBottom := false

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
	
	# if can go next isnt true, break
	if !GameManager.canGoNext:
		return
	
	joy_rotate(input_vec)
	joy_rock(input_vec)

# input func for stick clicks ONLY
func _input(event):
	# if can go next isnt true, break
	if !GameManager.canGoNext:
		return
	
	if event.is_action_pressed("left-stick-click"):
		EventBus.analogClick.emit(AnalogSticks.LEFT)
	elif event.is_action_pressed("right-stick-click"):
		EventBus.analogClick.emit(AnalogSticks.RIGHT)
	else:
		return

# ### helper funcs ###

func joy_rotate(input_vec:Vector2):
	# mariokart flag method
	current_pos = input_vec
	
	current_angle = atan2(input_vec.y, input_vec.x)
	
	# need to have some sort of drop logic i think
	
	if current_angle < -2*PI/3 and previous_angle > -2*PI/3:
		#print("passed flag 1")
		rotateFlags[0] = 1
		EventBus.changeAnimState.emit(0)
	elif current_angle > PI - 0.2 and previous_angle < PI - 0.2 and rotateFlags[0]:
		#print("passed flag 2")
		rotateFlags[1] = 1
		EventBus.changeAnimState.emit(1)
	elif current_angle < 2*PI/3 and previous_angle > 2*PI/3 and rotateFlags[1]:
		#print("passed flag 3")
		rotateFlags[2] = 1
		EventBus.changeAnimState.emit(2)
	elif current_angle < PI/3 and previous_angle > PI/3 and rotateFlags[2]:
		#print("passed flag 4")
		rotateFlags[3] = 1
		EventBus.changeAnimState.emit(3)
	elif current_angle < 0 and previous_angle > 0 and rotateFlags[3]:
		#print("passed flag 5")
		rotateFlags[4] = 1
		EventBus.changeAnimState.emit(4)
	elif current_angle < -PI/3 and previous_angle > -PI/3 and rotateFlags[4]:
		#print("passed flag 6")
		rotateFlags[5] = 1
		EventBus.changeAnimState.emit(5)
		
	if rotateFlags[5]:
		print("full rotation")
		rotateFlags = [0,0,0,0,0,0]
		match GameManager.currentShot.currentCharacter:
			GameManager.Characters.FATHER:
				EventBus.analogRotate.emit(AnalogSticks.LEFT)
			GameManager.Characters.MOTHER:
				EventBus.analogRotate.emit(AnalogSticks.RIGHT)
		
	# frame updates
	previous_angle = current_angle

func joy_rock(input_vec:Vector2):
	current_angle = atan2(input_vec.y, input_vec.x)
	
	if current_angle >= deg_to_rad(-100) and current_angle <= deg_to_rad(-60):
		current_pos = input_vec
		
		if current_pos.y == previous_pos.y and current_pos.y <= -0.9:
			hitBottom = true
		
		previous_pos = current_pos
		
	elif current_angle >= deg_to_rad(60) and current_angle <= deg_to_rad(100) and hitBottom:
		current_pos = input_vec
		
		if current_pos.y == previous_pos.y and current_pos.y >= 0.9:
			hitTop = true
		
		previous_pos = current_pos
		
	if hitBottom and hitTop:
		match GameManager.currentShot.currentCharacter:
			GameManager.Characters.FATHER:
				EventBus.analogFlick.emit(AnalogSticks.LEFT)
			GameManager.Characters.MOTHER:
				EventBus.analogFlick.emit(AnalogSticks.RIGHT)
			
		hitTop = false
		hitBottom = false
		current_angle = 0.0
		previous_angle = 0.0
		current_pos = Vector2(0,0)
		previous_pos = Vector2(0,0)
