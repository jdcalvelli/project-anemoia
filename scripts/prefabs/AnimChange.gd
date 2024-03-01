extends AnimatedSprite2D

var maxJitterVal:Vector2 = Vector2(2, 2)
var frameCounter:int = 0

# this needs to receive the signal for anim change
func _ready():
	EventBus.changeAnimState.connect(_on_change_anim_state)

# update to be able to do the jitter animation
func _physics_process(delta):
	# every twelve frames do the jitter
	if frameCounter % 12 == 0:
		print("twelve frame")
		# set the position of this image to some random value between 0 and maxjitterval
		position = Vector2(randi_range(0, maxJitterVal.x + 1), randi_range(0, maxJitterVal.y + 1))
	# increment frame counter
	frameCounter += 1

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
