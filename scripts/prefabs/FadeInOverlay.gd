extends Sprite2D

# export the image we need
@export var fadeImage:Texture2D

func _ready():
	# first establish what the correct image should be
	match GameManager.currentShot.sceneFadeIn:
		false:
			# no fade desired
			pass
		true:
			# fade from whatever image passed in is
			texture = fadeImage
			# do a tween fade out
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property(self, "modulate:a", 0, 6)
