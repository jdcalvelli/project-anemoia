extends AnimatedSprite2D

func _physics_process(_delta):
	if GameManager.currentShot.currentCharacter == GameManager.Characters.FATHER:
		_rotation_view()
	elif GameManager.currentShot.currentCharacter == GameManager.Characters.MOTHER:
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
