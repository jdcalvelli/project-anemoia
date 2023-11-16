extends Node2D

@export var introDialogue : DialogueResource
@export var stitchName : String

func _ready():
	set_physics_process(false)
	await get_tree().create_timer(5).timeout
	$BG3Days.hide()
	set_physics_process(true)
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
