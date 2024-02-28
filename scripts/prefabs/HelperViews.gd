extends Node2D

# this is for the purpose of tweening up the correct helper view after
# a certain amount of time

@export var helperTimeToWait = 5
@export var helperTweenDuration = 4

var ambienceInstance : EventInstance

func _ready():
	# play shutter click sound
	FMODRuntime.play_one_shot_path("event:/SFX/shutterClick")
	# calling change_ambience
	AudioManager.change_ambience($Shot.desiredAmbience)
	
	# wait for timeout
	await get_tree().create_timer(helperTimeToWait).timeout
	# then do the tween for the right object
	_create_helper_tween(GameManager.currentShot.currentCharacter, GameManager.currentShot.actionScene)
	

# helper func
func _create_helper_tween(currentChar:GameManager.Characters, actionScene:bool):
	var tween = create_tween()
	if currentChar == GameManager.Characters.FATHER:
		if actionScene:
			tween.tween_property(
				$"RAA-Helper", 
				"modulate:a",
				1, 
				helperTweenDuration)
		else:
			tween.tween_property(
				$"Father-Click-Helper", 
				"modulate:a", 
				1, 
				helperTweenDuration)
	elif currentChar == GameManager.Characters.MOTHER:
		if actionScene:
			tween.tween_property(
				$"VAA-Helper", 
				"modulate:a",
				1, 
				helperTweenDuration)
		else:
			tween.tween_property(
				$"Mother-Click-Helper",
				"modulate:a",
				1, 
				helperTweenDuration)
	elif currentChar == GameManager.Characters.BOTH:
		if actionScene:
			pass
		else:
			tween.set_parallel(true)
			tween.tween_property(
				$"Mother-Click-Helper",
				"modulate:a",
				1, 
				helperTweenDuration)
			tween.tween_property(
				$"Father-Click-Helper",
				"modulate:a",
				1,
				helperTweenDuration
			)
