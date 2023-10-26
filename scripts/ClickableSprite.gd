extends AnimatedSprite2D

func _ready():
	# internal signal connection
	$Area2D.input_event.connect(_on_input)

### signal callbacks
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_action_pressed("mouseClick"):
		print("mouse clicked")
		# this should trigger dialogue state basically
