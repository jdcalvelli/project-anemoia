extends Node2D

@export var PACLocationDialogue : Resource

var numClickables : int
var ClickedObjects : Array

func _ready():
	for child in get_children():
		if child is ClickableObject:
			numClickables += 1
			child.isAccessed.connect(_onClickHandle)

func _onClickHandle(emitter:ClickableObject):	

	# if the current object is the last to be clicked
	if ClickedObjects.size() == numClickables - 1:
		# ungate it
		emitter.isGated = false
	
	# if the current object isn't gated
	if !emitter.isGated:
		# append it to the array
		ClickedObjects.append(emitter)
		# call the dialogue
		# right now utilizing the example dialogue balloon, could change later
		DialogueManager.show_example_dialogue_balloon(
			PACLocationDialogue, 
			emitter.stitchName
		)
