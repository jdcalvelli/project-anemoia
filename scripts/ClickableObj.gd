extends AnimatedSprite2D

@export var stitchName : String
var dialogueResource : Resource

func _ready():
	# internal signal connection
	$Area2D.input_event.connect(_on_input)
	# grab the current dialogue resource from PACLocation
	# should be a signal? signal up, reference down?
	dialogueResource = get_parent().PACLocationDialogue
	

### signal callbacks
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_action_pressed("mouseClick"):
		# this should trigger dialogue state basically
		# right now utilizing the example dialogue balloon, could change later
		DialogueManager.show_example_dialogue_balloon(dialogueResource, stitchName)
