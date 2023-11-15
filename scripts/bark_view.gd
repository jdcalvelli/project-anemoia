extends Panel

func _ready():
	# tween up to the top of the screen and on callback destroy self
	var tween = create_tween()
	tween.tween_property(
		self, 
		"position:y",
		-400,
		4
		)
	tween.tween_callback(
		func():
			self.queue_free()
	)
