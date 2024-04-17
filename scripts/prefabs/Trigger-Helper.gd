extends AnimatedSprite2D

var frameCounter = 0
var interFrameCounter = 0

# DEAD SPACE FRAME NUMBER CALCULATOR NECESSARY

func _physics_process(delta):
	frameCounter += 1
	
	if !InputManager.triggerHeld:
		interFrameCounter += 1
		
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
		self.modulate.a = lerpf(self.modulate.a, 0, 0.05)
		if frameCounter % 3 == 0:
			frame = frame + 1
		if self.modulate.a <= 0.05:
			interFrameCounter = 0
