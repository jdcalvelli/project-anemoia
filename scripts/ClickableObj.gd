extends AnimatedSprite2D
class_name ClickableObject

@export var isGated : bool
@export var stitchName : String

signal isAccessed(emitter:ClickableObject)

func _ready():
	# internal signal connection
	$Area2D.input_event.connect(_on_input)
	

### signal callbacks
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_action_pressed("mouseClick"):
		# this should trigger dialogue state basically
		# getting handled in governing scene
		isAccessed.emit(self)
