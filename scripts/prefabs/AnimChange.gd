extends AnimatedSprite2D

# this needs to receive the signal for anim change
func _ready():
	EventBus.changeAnimState.connect(_on_change_anim_state)

# if number of frames on the frameresource is bigger than 1
# then change the frame to equal whatever the frame signal number is
func _on_change_anim_state(animState: int):
	# six gates, but twelve frames devinne makes
	
	# if we havent reached the end of the animation, move it forward
	if self.frame != self.sprite_frames.get_frame_count("default") - 1:
		self.frame += 1
		await get_tree().create_timer(0.1).timeout
		self.frame += 1
		print(self.frame)
	else:
		# if we have reached the end of the animation
		# and if we havent reached the end of required actions
		if GameManager.currentShot.numActionsTaken != GameManager.currentShot.numRequiredActions:
			# reset the frame
			# so that it we can repeat the animation
			self.frame = 1
