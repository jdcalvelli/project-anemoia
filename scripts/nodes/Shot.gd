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

func _enter_tree():
	
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
	# pass the shot up to the gamemanager
	GameManager.currentShot = self
		
	# FMOD
	# calling change_ambience
	AudioManager.change_ambience(sceneAmbiencePath)
	# change ambience param
	AudioManager.update_ambience_param(sceneAmbiencePath, sceneAmbienceParam, sceneAmbienceVal)
	# play the scene audio if 0
	if sceneAudioPlaybackPoint == 0:
		AudioManager.play_scene_audio(sceneAudioPath)

func _on_action_started_audio():
	if sceneAudioPlaybackPoint == 1:
		AudioManager.play_scene_audio(sceneAudioPath)

func _on_action_completed_audio():
	if sceneAudioPlaybackPoint == 2:
		AudioManager.play_scene_audio(sceneAudioPath)

func _exit_tree():
	# cleanup audio when we leave the tree
	AudioManager.cleanup_scene_audio(sceneAudioPath)
