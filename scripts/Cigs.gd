extends Node2D

var canBeDragged:bool = false

# function to tween the cigs up a bit on every camear movement
func tweenCigs():
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		position + Vector2(-20, -20),
		0.5
	)
