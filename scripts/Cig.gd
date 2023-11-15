extends Area2D

var canBeGrabbed:bool = false
var isHeld:bool = false

func _ready():
	input_event.connect(_on_input)
	
func _on_input(viewport : Node, event : InputEvent, shape_idx : int):
	if event.is_action_pressed("mouseClick"):
		if canBeGrabbed:
			isHeld = !isHeld
			# on pickup start a timer to send to next scene
			var sceneEndTimer = get_tree().create_timer(4)
			sceneEndTimer.timeout.connect(
				func():
					GameManager.changeScene("res://scenes/garden_outro.tscn")
			)
	
func _physics_process(delta):
	if isHeld:
		global_position = lerp(
			global_position,
			get_global_mouse_position(),
			20 * delta
		)
