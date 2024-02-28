extends Node

var ambienceInstances : Array[EventInstance] = []

func _ready():
	# NEED TO ADD WHATEVER AMBIENCES WE WANT TO THIS ARRAY
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/schoolAmbience")
		)
	ambienceInstances.push_back(
		FMODRuntime.create_instance_path("event:/Ambience/testAmbience")
	)

func play_scene_audio(eventPath:String):
	# should probably change this into instance based
	if eventPath != null:
		FMODRuntime.play_one_shot_path(eventPath)

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
