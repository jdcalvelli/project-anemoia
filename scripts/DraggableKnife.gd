extends Area2D
class_name DraggableKnife

@export var CutFactor:int

var isHeld:bool = false
var isCutting:bool = false

func _ready():
	input_event.connect(_on_input)
	
	$KnifeEdgeArea2D.area_entered.connect(_on_knife_edge_entered)
	$KnifeEdgeArea2D.area_exited.connect(_on_knife_edge_exited)
	
func _on_input(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_action_pressed("mouseClick"):
		isHeld = !isHeld
	
func _physics_process(delta):
	# holding logic
	if isHeld:
		$AnimatedSprite2D.frame = 1
		position = lerp(
			position,
			get_global_mouse_position(),
			20 * delta
		)
	elif !isHeld:
		$AnimatedSprite2D.frame = 0
		
	# cutting logic
	if isCutting:
		var knifeYPosFactored = (
			get_viewport_rect().size.y - 
			get_global_mouse_position().y
		)
		var fruitYPosFactored = (
			get_viewport_rect().size.y -
			get_tree().current_scene.fruitOnBoard.position.y
		)
		# once the x value is a certain factor below the bottom of
		# the dookie
		if  knifeYPosFactored <= fruitYPosFactored - CutFactor:
			print("cut should occur")
			get_tree().current_scene.fruitOnBoard.get_node("AnimatedSprite2D").frame += 1
			isCutting = false
		
# helper funcs
func _on_knife_edge_entered(area:Area2D):
	if isHeld and area is DraggableFruit:
		isCutting = true
		print("is cutting")
		
		
func _on_knife_edge_exited(area:Area2D):
	if isHeld and area is DraggableFruit:
		isCutting = false
		print("we out")
