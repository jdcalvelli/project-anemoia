extends Node2D

@export var outroDialogue : DialogueResource
@export var stitchName : String

signal WaterChange

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	DialogueManager.show_example_dialogue_balloon(
	outroDialogue, 
	stitchName
	)
	WaterChange.connect(change_image)

#temp way to change the background images once certain point is hit in dialogue
func change_image():
	$L1_1EndBackground.hide()
	$L1_1EndCharacter.hide()
	$L1_xEndBackground.show()
	$L1_xEndObject.show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$L1_1EndBackground.position = lerp(
		$L1_1EndBackground.position, 
		Vector2(0,0), 
		ease(0.08 * delta, -1.05)
	)
	$L1_1EndCharacter.position = lerp(
		$L1_1EndCharacter.position,
		Vector2(0,0),
		ease(0.08 * delta, -1.05)
	)
