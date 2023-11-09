extends Area2D
class_name DraggableFruit

var isHeld : bool = false

func _ready():
	input_event.connect(_on_input)
	
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	# a lot of complex click logic going on here
	if event.is_action_pressed("mouseClick"):
		# you can only click on a fruit if theres nothing in hand
		# and nothing on the board
		if (!isHeld 
		and get_tree().current_scene.fruitInHand == null
		and get_tree().current_scene.fruitOnBoard == null):
			isHeld = true
			get_tree().current_scene.fruitInHand = self
		# only in the event that this frut is on the board
		# can you put it down, at which point
		# you cant pick up another fruit - logic stops here
		if (isHeld 
		and get_tree().current_scene.fruitOnBoard == self):
			isHeld = false
			get_tree().current_scene.fruitInHand = null
	
func _physics_process(delta):
	# this handles the draggability of this particular object
	if isHeld:
		position = lerp(
			position,
			get_global_mouse_position(),
			20 * delta
		)
