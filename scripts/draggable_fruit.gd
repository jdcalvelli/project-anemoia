extends Area2D

var isHeld : bool = false

func _ready():
	input_event.connect(_on_input)
	
func _on_input(viewport : Node, event : InputEvent, shape_idx : int):
	if event.is_action_pressed("mouseClick"):
		isHeld = true
	elif event.is_action_released("mouseClick"):
		isHeld = false
	
func _physics_process(delta):
	if isHeld:
		position = lerp(
			position,
			get_global_mouse_position(),
			20 * delta
		)
