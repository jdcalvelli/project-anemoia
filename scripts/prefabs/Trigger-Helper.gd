extends AnimatedSprite2D

var frameCounter = 0
var interFrameCounter = 0

# DEAD SPACE FRAME NUMBER CALCULATOR NECESSARY

func _physics_process(_delta):
	frameCounter += 1

	# DONT DO ANY OF THE VISUALS IF THE CHARACTER IS NOT AUTO
	if GameManager.currentShot.currentCharacter != GameManager.Characters.AUTO:
		return

	if InputManager.triggerHeld.all(func(e): return e == 0):
		interFrameCounter += 1
		# LOWER THE COLOR OF THE ENTIRE SCENE
		# checking just the r bc all elements are changed
		if get_tree().current_scene.get("modulate").r >= 0.5:
			# every so often, drop color by 0.1
			if frameCounter % 3 == 0:
				get_tree().current_scene.set(
					"modulate",
					lerp(
						get_tree().current_scene.get("modulate"),
						Color(0.4, 0.4, 0.4, 1),
						0.05
					)
				)

		# TRIGGER HELPER VISUAL
		# 4 sec hold before image comes back
		# 60 frames per second lock
		if interFrameCounter < 240:
			return
		
		self.modulate.a = lerpf(self.modulate.a, 1, 0.005)
		if self.modulate.a >= 0.65 and frameCounter % 3 == 0:
			frame = frame + 1
		elif self.modulate.a <= 0.05:
			frame = 0
	else:
		# RAISE COLOR OF WHOLE SCREEN
		if get_tree().current_scene.get("modulate").r <= 1:
			# every so often, drop color by 0.1
			if frameCounter % 3 == 0:
				get_tree().current_scene.set(
					"modulate",
					lerp(
						get_tree().current_scene.get("modulate"),
						Color(1, 1, 1, 1),
						0.05
					)
				)


		# TRIGGER HELPER VISUAL
		self.modulate.a = lerpf(self.modulate.a, 0, 0.05)
		if frameCounter % 3 == 0:
			frame = frame + 1
		if self.modulate.a <= 0.05:
			interFrameCounter = 0

		
