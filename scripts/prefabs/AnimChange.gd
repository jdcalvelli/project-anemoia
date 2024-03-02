extends AnimatedSprite2D

var maxJitterVal:Vector2 = Vector2(2, 2)
var frameCounter:int = 0

var readyForNextSide = false

# update to be able to do the jitter animation
func _physics_process(delta):
	# every twelve frames do the jitter
	if frameCounter % 12 == 0:
		#print("twelve frame")
		# set the position of this image to some random value between 0 and maxjitterval
		position = Vector2(randi_range(0, maxJitterVal.x + 1), randi_range(0, maxJitterVal.y + 1))
	# increment frame counter
	frameCounter += 1

	if GameManager.currentShot.currentCharacter == GameManager.Characters.FATHER:
		_rotation_view()
	elif GameManager.currentShot.currentCharacter == GameManager.Characters.MOTHER:
		_rock_view()


### helper funcs

func _rotation_view():
	# this is the dumb way
	var checkVal = floori(InputManager.current_pos.y * 10)
	print(checkVal)
	# get position
	if sign(InputManager.current_pos.x) == -1:
		#print("1 to 6 happen here")
		if checkVal == -9 or checkVal == -8 or checkVal == -7:
			frame = 0
		elif checkVal == -6 or checkVal == -5 or checkVal == -4:
			frame = 1
		elif checkVal == -3 or checkVal == -2 or checkVal == -1:
			frame = 2
		elif checkVal == 0 or checkVal == 1 or checkVal == 2:
			frame = 3
		elif checkVal == 3 or checkVal == 4 or checkVal == 5:
			frame = 4
		elif checkVal == 6 or checkVal == 7 or checkVal == 8:
			frame = 5
			# this is also dumb
			readyForNextSide = true
	elif sign(InputManager.current_pos.x) == 1 and readyForNextSide:
		#print("7 to 12 happen here")
		if checkVal == 9 or checkVal == 8 or checkVal == 7:
			frame = 6
		elif checkVal == 6 or checkVal == 5 or checkVal == 4:
			frame = 7
		elif checkVal == 3 or checkVal == 2 or checkVal == 1:
			frame = 8
		elif checkVal == 0 or checkVal == -1 or checkVal == -2:
			frame = 9
		elif checkVal == -3 or checkVal == -4 or checkVal == -5:
			frame = 10
		elif checkVal == -6 or checkVal == -7 or checkVal == -8:
			frame = 11
			# equally dumb
			readyForNextSide = true
	
# this math is so much nicer lmao
func _rock_view():
	var checkVal = roundi(InputManager.current_pos.y * 6)
	#print(checkVal)
	if sign(checkVal) == -1:
		# catch -6 case
		if checkVal == -6:
			frame = 5
		elif !readyForNextSide:
			frame = abs(checkVal)
		# still dumb
		if checkVal == -6:
			readyForNextSide = true
	elif sign(checkVal) == 1 and readyForNextSide:
		frame = 6 + checkVal
		# once again, still dumb
		if checkVal == 5:
			readyForNextSide = false
