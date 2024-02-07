extends Node2D

var starting_angle := 0.0
var inverse_angle := 0.0
var current_angle := 0.0
var previous_angle := 0.0

var current_pos := Vector2(0,0)
var previous_pos := Vector2(0,0)

var current_rotationDir : ClockDirection
var previous_rotationDir : ClockDirection
var passedInverseCounter = false
var passedInverseClock = false

func _physics_process(delta):
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
