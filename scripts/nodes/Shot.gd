extends Node
class_name Shot

# data class for each shot

@export_category("FMOD Event Refs")
@export var sceneAmbiencePath:String
@export var sceneAmbienceParam:String
@export var sceneAmbienceVal:float
@export var sceneAudioPath:String
# if 0, play at ready, if 1, play at start of action, if 2, play at end of action
# make this an enum eventually prob
@export var sceneAudioPlaybackPoint:int

@export_category("Pre Scene Options")
# 0 = no fade in, 1 = fade from last image
@export var sceneFadeIn:bool

@export_category("Shot Logic")
@export var currentCharacter:GameManager.Characters
@export var reverseActions:bool = false
@export var numRequiredActions:int = 0
var numActionsTaken:int = 0

# this is only going to be used in the auto character case
# this is a strong case of i should refactor this all into shot and shot subclasses
@export var autoCharacterWaitTime: float
@export var prevShot:String
#added a previous shot variable for developmental purposes
@export var nextShot:String

# for jitter shot
var shouldJitter:bool = true
var maxJitterVal:Vector2 = Vector2(2, 2)
var frameCounter:int = 0

func _enter_tree():
	# pass the shot up to the gamemanager
	GameManager.currentShot = self
	
	# async loading next and prev shots
	ResourceLoader.load_threaded_request(nextShot)
	ResourceLoader.load_threaded_request(prevShot)
	# this is for the auto character
	# nill at this point
	await get_tree().create_timer(autoCharacterWaitTime).timeout
	if currentCharacter == GameManager.Characters.AUTO:
		# print("AUTOMOVE")
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(nextShot))

func _ready():
	# subscribe to events
	EventBus.actionStarted.connect(_on_action_started_audio)
	EventBus.actionCompleted.connect(_on_action_completed_audio)
	EventBus.shutterComplete.connect(_on_shutter_complete)
		
	# FMOD
	# calling change_ambience
	AudioManager.change_ambience(sceneAmbiencePath)
	# change ambience param
	AudioManager.update_ambience_param(sceneAmbiencePath, sceneAmbienceParam, sceneAmbienceVal)
	# play the scene audio if 0
	if sceneAudioPlaybackPoint == 0:
		AudioManager.play_scene_audio(sceneAudioPath)

	# FOR TIMED ACTION SCENES
	# check if the numRequiredActions is 999
	if numRequiredActions == 999:
		# start a timer for 60 seconds
		await get_tree().create_timer(60).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(nextShot))

# for jitter
func _physics_process(delta):
	# if we shouldnt jitter, break out
	if !shouldJitter:
		return
	# every twelve frames do the jitter
	if frameCounter % 12 == 0 and get_node("../AnimatedSprite2D"):
		#print("twelve frame")
		# set the position of this image to some random value between 0 and maxjitterval
		get_node("../AnimatedSprite2D").position = Vector2(randi_range(0, maxJitterVal.x + 1), randi_range(0, maxJitterVal.y + 1))
	# increment frame counter using delta
	frameCounter += delta * 60

func _on_action_started_audio():
	if sceneAudioPlaybackPoint == 1:
		AudioManager.play_scene_audio(sceneAudioPath)

func _on_action_completed_audio():
	if sceneAudioPlaybackPoint == 2:
		AudioManager.play_scene_audio(sceneAudioPath)

func _on_shutter_complete():
		# turn should jitter off
	shouldJitter = false
	# now do the slight pan out and rotate
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		get_node("../AnimatedSprite2D"),
		"rotation_degrees",
		-45,
		50
	)
	tween.tween_property(
		get_node("../AnimatedSprite2D"),
		"scale",
		Vector2(1, 1),
		50
	)

func _exit_tree():
	# cleanup audio when we leave the tree
	AudioManager.cleanup_scene_audio(sceneAudioPath)
