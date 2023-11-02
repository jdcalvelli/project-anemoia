extends Node2D

@export var introDialogue : DialogueResource
@export var stitchName : String

func _ready():
	# start the intro dialogue
	DialogueManager.show_example_dialogue_balloon(
		introDialogue, 
		stitchName
	)
	
func _physics_process(delta):
	$L1_1_Background.position = lerp(
		$L1_1_Background.position, 
		Vector2(0,0), 
		ease(0.08 * delta, -1.05)
	)
	$L1_1_Character.position = lerp(
		$L1_1_Character.position,
		Vector2(0,0),
		ease(0.08 * delta, -1.05)
	)
