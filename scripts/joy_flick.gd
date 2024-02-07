extends Node2D

var current_angle := 0.0
var previous_angle := 0.0

var current_y := 0.0
var previous_y := 0.0

var hitTop := false
var hitBottom := false

func _physics_process(delta):
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
		current_y = input_vector.y
		
		if current_y == previous_y and current_y <= -0.9:
			hitBottom = true
		
		previous_y = current_y
		
	elif current_angle >= deg_to_rad(60) and current_angle <= deg_to_rad(100) and hitBottom:
		current_y = input_vector.y
		
		if current_y == previous_y and current_y >= 0.9:
			hitTop = true
		
		previous_y = current_y
		
	if hitBottom and hitTop:
		print("flick registered")
		hitTop = false
		hitBottom = false
		current_angle = 0.0
		previous_angle = 0.0
		current_y = 0.0
		previous_y = 0.0
