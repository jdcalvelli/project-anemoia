extends Camera2D

func _process(delta):
	_cameraSway(delta)

### helper funcs

func _cameraSway(delta:float):
	# when i try to roll this into one vector 2 based call it doesnt work
	# probably because if it breaks clamp on one of the vector 2 it stops the whole thing
	# could rewrite into an on input + tween combination later
	position.x = lerp(
		position.x, 
		clamp(
			get_local_mouse_position().x,
			-1 * get_viewport_rect().size.x / 20,
			get_viewport_rect().size.x / 20
		),
		6 * delta
	)
	position.y = lerp(
		position.y,
		clamp(
			get_local_mouse_position().y,
			-1 * get_viewport_rect().size.y / 20,
			get_viewport_rect().size.y / 20
		),
		6 * delta
	)
