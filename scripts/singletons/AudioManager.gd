extends Node

var ambienceInstances:Array[EventInstance] = []
var sceneAudioInstances:Array[EventInstance] = []

func _ready():
	# NEED TO ADD WHATEVER AMBIENCES WE WANT TO THIS ARRAY
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/schoolAmbience")
		)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/headphoneAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/trainAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/babyCryAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/movieTheaterAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/outsideAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/cafeAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/sophieCafeAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/sophieDJAmbience")
	)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/hvacAmbience")
	)
	# constant background rolling shutter
	FMODRuntime.play_one_shot_path("event:/Ambience/rollingShutterAmbience")

func play_scene_audio(eventPath:String):
	# if any instances already have this path do nothing
	if sceneAudioInstances.any(func(element): return element.get_description().get_path() == eventPath):
		# print("already exists once")
		pass
	else:
		# create an instance
		sceneAudioInstances.push_back(FMODRuntime.create_instance_path(eventPath))
	
	# play logic
	for sceneAudioInstance in sceneAudioInstances:
		if sceneAudioInstance.get_description().get_path() == eventPath:
			if sceneAudioInstance.get_playback_state() != FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING:
				sceneAudioInstance.start()

func cleanup_scene_audio(eventPath:String):
	for sceneAudioInstance in sceneAudioInstances:
		if sceneAudioInstance.get_description().get_path() == eventPath:
			sceneAudioInstance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
			sceneAudioInstance.release()

func update_ambience_param(eventPath:String, param:String, value:float):
	for ambienceInstance in ambienceInstances:
		if ambienceInstance.get_description().get_path() == eventPath:
			ambienceInstance.set_parameter_by_name(param, value)

func change_ambience(eventPath:String):
	for ambienceInstance in ambienceInstances:
		# check if we're talking about the right one
		if ambienceInstance.get_description().get_path() == eventPath:
			# if it isnt already playing, play it
			if ambienceInstance.get_playback_state() != FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING:
				ambienceInstance.start()
		else:
			# stop the instance
			# this also works in the cases where the path is null
			ambienceInstance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
