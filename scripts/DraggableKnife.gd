extends Area2D
class_name DraggableKnife

@export var CutFactor:int
@onready var knifeInstruct = $"../memory_1_father_cam/KnifeInstruct"
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
		#display knifeInstruct 
		knifeInstruct.show()
		var tween = get_tree().create_tween()
		tween.tween_property(knifeInstruct,"rotation_degrees",-60,1).set_ease(Tween.EASE_OUT_IN)
		tween.parallel().tween_property(knifeInstruct,"position:y",-630,1).set_ease(Tween.EASE_OUT_IN)
		#tween.tween_property(knifeInstruct,"rotation_degrees",60,.5).as_relative().set_ease(Tween.EASE_OUT_IN)
		#tween.parallel().tween_property(knifeInstruct,"position:y",-200,.5).as_relative().set_ease(Tween.EASE_OUT_IN)
		# lerp position to mouse position
		$AnimatedSprite2D.frame = 1
		position = lerp(
			position,
			get_global_mouse_position(),
			get_tree().current_scene.lerpFactor * delta
		)
		# lerp rotation based on y position of mouse
		print(get_global_mouse_position().y)
		rotation = lerp(
			rotation,
			-deg_to_rad(maxf(-100, get_global_mouse_position().y) / 8),
			get_tree().current_scene.lerpFactor * delta
		)
	elif !isHeld:
		$AnimatedSprite2D.frame = 0
		knifeInstruct.hide()
		
		var tween = get_tree().create_tween()
		#tween.tween_property(knifeInstruct,"rotation_degrees",-60,.7).set_ease(Tween.EASE_OUT_IN)
		#tween.parallel().tween_property(knifeInstruct,"position:y",-530,.7).set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(knifeInstruct,"rotation_degrees",60,.7).as_relative().set_ease(Tween.EASE_OUT_IN)
		tween.parallel().tween_property(knifeInstruct,"position:y",-200,.7).as_relative().set_ease(Tween.EASE_OUT_IN)
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
			var spriteOfFruitOnBoardRef = get_tree().current_scene.fruitOnBoard.get_node("AnimatedSprite2D")
			spriteOfFruitOnBoardRef.frame += 1
			#Devinne's attempt at knife audio, the last frame doesn't play but it's literally not that important it gets the idea across
			if spriteOfFruitOnBoardRef.frame + 1  < spriteOfFruitOnBoardRef.sprite_frames.get_frame_count("default"):
				$KnifeChop.play()
			if spriteOfFruitOnBoardRef.frame + 1 >= spriteOfFruitOnBoardRef.sprite_frames.get_frame_count("default"):
				get_tree().current_scene.fruitOnBoard.isCut = true
			isCutting = false
		
# helper funcs
func _on_knife_edge_entered(area:Area2D):
	# this is a check just to make sure that youre cutting from the
	# right side - ie knife is on the right, apple on left
	# add an offset to make sure we're cutting from the left side?
	if (area.global_position.x - 200
	< global_position.x):
		if isHeld and area is DraggableFruit:
			if get_tree().current_scene.fruitOnBoard:
				isCutting = true
				print("is cutting")
		
		
func _on_knife_edge_exited(area:Area2D):
	if isHeld and area is DraggableFruit:
		isCutting = false
		print("we out")
