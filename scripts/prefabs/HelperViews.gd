extends Node2D

# this is for the purpose of tweening up the correct helper view after
# a certain amount of time

@export var helperTimeToWait = 5
@export var helperTweenDuration = 4

var tween : Tween

func _ready():
	# connect to signal rightBumperPress
	EventBus.rightBumperPress.connect(_on_right_bumper_press)
	
	# connect to signal when all actions completed
	EventBus.totalActionsCompleted.connect(_on_total_actions_completed)
	
	# wait for timeout
	await get_tree().create_timer(helperTimeToWait).timeout
	# then do the tween for the right object
	_create_helper_tween(GameManager.currentShot.currentCharacter)
	

# helper func

func _on_right_bumper_press():
	$"Camera-Helper".hide()
	if GameManager.currentShot.numActionsTaken != GameManager.currentShot.numRequiredActions:
		# play shutter click sound
		FMODRuntime.play_one_shot_path("event:/SFX/shutterClick")
		# tween the shutter
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property($ShutterVFX, "position:y", 0, 0.075)
		tween.tween_property($ShutterVFX, "position:y", -1140, 0.075)
		tween.tween_callback(func(): EventBus.shutterComplete.emit())

func _on_total_actions_completed():
	# kill the tween and hide all helper object
	if tween:
		tween.kill()
	$"RAA-Helper".hide()
	$"VAA-Helper".hide()
	$"Camera-Helper".hide()
	pass

func _create_helper_tween(currentChar:GameManager.Characters):
	if currentChar == GameManager.Characters.FATHER:
		tween = create_tween()
		tween.tween_property(
			$"RAA-Helper", 
			"modulate:a",
			1,
			helperTweenDuration)
	elif currentChar == GameManager.Characters.MOTHER:
		tween = create_tween()
		tween.tween_property(
			$"VAA-Helper", 
			"modulate:a",
			1, 
			helperTweenDuration)
	elif currentChar == GameManager.Characters.CAMERA:
		tween = create_tween()
		tween.tween_property(
			$"Camera-Helper",
			"modulate:a",
			1, 
			helperTweenDuration)
