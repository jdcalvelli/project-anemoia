extends AnimatedSprite2D

# this needs to receive the signal for anim change
func _ready():
	EventBus.changeAnimState.connect(_on_change_anim_state)

# if number of frames on the frameresource is bigger than 1
# then change the frame to equal whatever the frame signal number is
func _on_change_anim_state(animState: int):
	# six gates, but twelve frames devinne makes
	
	# first check if the if we've taken the correct num actions at least, and do nothing
	if GameManager.currentShot.numActionsTaken >= GameManager.currentShot.numRequiredActions:
		print("correct num actions taken - view")
		return
	else:
		if self.frame == self.sprite_frames.get_frame_count("default") - 1:
			self.frame = 1
			await get_tree().create_timer(0.05).timeout
			self.frame += 1
		else:
			# increase anim
			self.frame += 1
			await get_tree().create_timer(0.05).timeout
			self.frame += 1
			
	# normalize angle / pos of analog stick to be between zero and one
	# use that to calculate where in the total number of frames you should be
	# absolute value under the x axis, then not
