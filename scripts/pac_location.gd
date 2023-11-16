extends Node2D

@export var PACLocationDialogue : DialogueResource

var numClickables : int
var ClickedObjects : Array

# called at the end of the dialogue
signal sceneOver

func _ready():
	for child in get_children():
		if child is ClickableObject:
			numClickables += 1
			child.isAccessed.connect(_onClickHandle)
	
	sceneOver.connect(_on_last_item_end)

func _onClickHandle(emitter:ClickableObject):	

	# if the current object is the last to be clicked
	if ClickedObjects.size() == numClickables - 1:
		# ungate it
		emitter.isGated = false
	
	# if the current object isn't gated
	if !emitter.isGated:
		# append it to the array if it isn't already there
		if !ClickedObjects.has(emitter) : ClickedObjects.append(emitter)
		# call the dialogue
		# right now utilizing the example dialogue balloon, could change later
		await DialogueManager.show_example_dialogue_balloon(
			PACLocationDialogue, 
			emitter.stitchName
		)

func _on_last_item_end():
	$BackgroundAudio.stop()
	$BG2833Days.visible = true
	$BG2833Days.play("default")
	await get_tree().create_timer(5).timeout
	GameManager.changeScene("res://scenes/memory_1_father.tscn")
