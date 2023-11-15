extends Control

@onready var dialogueResource:DialogueResource = preload("res://dialogues/memory_1_father.dialogue")
@onready var barkPrefab:PackedScene = preload("res://prefabs/bark_view.tscn")

# this right now has to be hard coded based on the number in the dialogue
var numBarks = 4
var barkToDisplay:DialogueLine

# this is internal
func _getBark(barkNum:int):
	barkToDisplay = await DialogueManager.get_next_dialogue_line(
		dialogueResource,
		"bark_{barkNum}".format({"barkNum": barkNum})
		)

# this is external, will be called by scene management
func displayBark(barkNum:int):
	_getBark(barkNum)
	var newBarkView = barkPrefab.instantiate()
	# put text in
	newBarkView.get_node("Label").text = barkToDisplay.text
	# set bark x and y randomly within range
	newBarkView.position = Vector2(
		randi_range(-600, 600), 
		0
	)
	add_child(newBarkView)
