extends Area2D
class_name DraggableFruit

var isHeld:bool = false
var isCut:bool = false

var memoryController:memOneFatherController

func _ready():
	input_event.connect(_on_input)
	
	memoryController = get_tree().current_scene
	
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	# a lot of complex click logic going on here
	if event.is_action_pressed("mouseClick"):
		if !isHeld:
			# if theres already a fruit on board that isnt this one
			if  memoryController.fruitOnBoard != self and memoryController.fruitOnBoard != null:
				return
			# if no fruit in hand and no fruit on board
			elif (!memoryController.fruitInHand
			and !memoryController.fruitOnBoard):
				isHeld = true
				memoryController.fruitInHand = self
			# if fruit on board and fruit is cut
			elif(memoryController.fruitOnBoard 
			and memoryController.fruitOnBoard.isCut):
				isHeld = true
				memoryController.fruitInHand = self
		elif isHeld:
			# if in hand and over board, can be dropped
			if memoryController.fruitOnBoard == self:
				isHeld = false
				memoryController.fruitInHand = null
			elif memoryController.fruitOverBowl == self:
				isHeld = false
				memoryController.fruitInHand = null
	
func _physics_process(delta):
	# this handles the draggability of this particular object
	if isHeld:
		position = lerp(
			position,
			get_global_mouse_position(),
			20 * delta
		)
