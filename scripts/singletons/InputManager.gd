extends Node

enum AnalogSticks {
	LEFT,
	RIGHT
}

# needed for rotate and flick
var current_angle := 0.0
var previous_angle := 0.0
var current_pos := Vector2(0,0)
var previous_pos := Vector2(0,0)

# needed for rotate
var starting_angle := 0.0
var inverse_angle := 0.0
var current_rotationDir : ClockDirection
var previous_rotationDir : ClockDirection
var passedInverseCounter = false
var passedInverseClock = false

# needed for flick
var hitTop := false
var hitBottom := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	joy_rotate(GameManager.currentCharacter)
	joy_flick(GameManager.currentCharacter)



# ### helper funcs ###

func joy_rotate(char:GameManager.Characters):
		# get the coords of the left joystick
	# make this specific joystick independent
	var input_vector = Input.get_vector(
		"left-analog-left",
		"left-analog-right",
		"left-analog-down",
		"left-analog-up"
		)
	
	# keep reference to current input vector
	current_pos = input_vector
	
	# if the joystick is at coord (0,0), break out of the update
	if current_pos == Vector2(0,0):
		passedInverseCounter = false
		passedInverseClock = false
		return
	
	# get current angle based on atan2 - which means the angle based on pos x axis
	current_angle = atan2(input_vector.y, input_vector.x)
	
	# establish starting angle and inverse
	if previous_pos == Vector2(0,0):
		starting_angle = current_angle
		inverse_angle = starting_angle - PI
		
	if current_angle > previous_angle:
		# moving counter
		current_rotationDir = COUNTERCLOCKWISE
	if current_angle < previous_angle:
		# moving clockwise
		current_rotationDir = CLOCKWISE
	
	# on the frame that you change directions, set the starting angle and inverse again
	# to whatever the angle was when you changed directions
	
	# if sign of starting angle is positive
	if sign(starting_angle) == 1:
		if current_rotationDir == COUNTERCLOCKWISE and previous_rotationDir == COUNTERCLOCKWISE:
			passedInverseClock = false
			if current_angle > inverse_angle and current_angle < 0:
				passedInverseCounter = true
			elif current_angle > starting_angle and passedInverseCounter:
				print("full rotation counter")
				passedInverseCounter = false
		if current_rotationDir == CLOCKWISE and previous_rotationDir == CLOCKWISE:
			passedInverseCounter = false
			if current_angle < inverse_angle and current_angle > -PI:
				passedInverseClock = true
			elif current_angle < starting_angle and passedInverseClock:
				print("full rotation clock")
				passedInverseClock = false
	
	# frame updates
	previous_pos = current_pos
	previous_angle = current_angle
	previous_rotationDir = current_rotationDir

func joy_flick(char:GameManager.Characters):
		# get input vector for right joystick
	# make this specific joystick independent
	var input_vector = Input.get_vector(
		"right-analog-left",
		"right-analog-right", 
		"right-analog-down", 
		"right-analog-up"
		)
	
	current_angle = atan2(input_vector.y, input_vector.x)
	
	if current_angle >= deg_to_rad(-100) and current_angle <= deg_to_rad(-60):
		current_pos = input_vector
		
		if current_pos.y == previous_pos.y and current_pos.y <= -0.9:
			hitBottom = true
		
		previous_pos = current_pos
		
	elif current_angle >= deg_to_rad(60) and current_angle <= deg_to_rad(100) and hitBottom:
		current_pos = input_vector
		
		if current_pos.y == previous_pos.y and current_pos.y >= 0.9:
			hitTop = true
		
		previous_pos = current_pos
		
	if hitBottom and hitTop:
		print("flick registered")
		hitTop = false
		hitBottom = false
		current_angle = 0.0
		previous_angle = 0.0
		current_pos = Vector2(0,0)
		previous_pos = Vector2(0,0)
