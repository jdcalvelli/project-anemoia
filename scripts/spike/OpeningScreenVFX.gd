extends Node


func _ready():
	# create the tween to bring them up
	# auto wait time needs to reflect this time too
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($TopScreen, "position:y", -1140, 5)
	tween.tween_property($BottomScreen, "position:y", 1140, 5)
