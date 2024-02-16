extends AnimatedSprite2D

# this needs to receive the signal for anim change
func _ready():
	if self.sprite_frames.get_frame_count("default") > 1:
		EventBus.changeAnimState.connect(_on_change_anim_state)

# if number of frames on the frameresource is bigger than 1
# then change the frame to equal whatever the frame signal number is
func _on_change_anim_state(animState: int):
	self.frame += 1
	await get_tree().create_timer(0.15).timeout
	self.frame += 1
