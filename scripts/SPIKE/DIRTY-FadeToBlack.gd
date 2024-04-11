extends Sprite2D

func _ready():
	# create timer
	await get_tree().create_timer(3).timeout
	# create tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(
		self, 
		"modulate:a",
		1,
		5
	)