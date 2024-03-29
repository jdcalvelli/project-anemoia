extends AnimatedSprite2D

var maxJitterVal:Vector2 = Vector2(2, 2)
var frameCounter:int = 0

var flipSide:bool = false

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
		if GameManager.currentShot.actionScene:
			_rotation_view()
	elif GameManager.currentShot.currentCharacter == GameManager.Characters.MOTHER:
		if GameManager.currentShot.actionScene:
			_rock_view()


### helper funcs

func _rotation_view():
	# this is the dumb way
	var checkVal = floori(InputManager.current_pos.y * 10)
	# maybe we have to just cut this in the event that all rotateflags are 0
	if InputManager.rotateFlags.all(func(element): return element == 0):
		if frame != 0 and frame != 11:
			frame -= 1
		return
	elif sign(InputManager.current_pos.x) == -1:
		# print("1 to 6 happen here")
		# should also check based on current flag status
		if checkVal <= -7:
			frame = 0
		elif checkVal <= -4:
			frame = 1
		elif checkVal <= -1 and InputManager.rotateFlags[0]:
			frame = 2
		elif checkVal <= 2 and InputManager.rotateFlags[0]:
			frame = 3
		elif checkVal <= 5 and InputManager.rotateFlags[1]:
			frame = 4
		elif checkVal <= 8 and InputManager.rotateFlags[1]:
			frame = 5
	elif sign(InputManager.current_pos.x) == 1:
		#print("7 to 12 happen here")
		if checkVal >= 7 and InputManager.rotateFlags[2]:
			frame = 6
		elif checkVal >= 4 and InputManager.rotateFlags[2]:
			frame = 7
		elif checkVal >= 1 and InputManager.rotateFlags[3]:
			frame = 8
		elif checkVal >= -2 and InputManager.rotateFlags[3]:
			frame = 9
		elif checkVal >= -5 and InputManager.rotateFlags[4]:
			frame = 10
		elif checkVal >= -8 and InputManager.rotateFlags[4]:
			frame = 11
	
func _rock_view():
	# need some sort of reset to rock back to zero
	
	# print(InputManager.current_pos)
	if InputManager.rockFlags.all(func(element): return element == 0) and GameManager.currentShot.numRequiredActions > 1:
		frame = 1
	elif InputManager.current_pos.y < 0:
		if !InputManager.rockFlags[3]:
			if frame <= 5:
				frame += 1
	elif InputManager.current_pos.y > 0:
		if !InputManager.rockFlags[4]:
			if frame <= 10:
				frame += 1
	elif InputManager.current_pos.y == 0 and InputManager.previous_pos.y == 0:
		if frame != 0:
			frame -= 1
