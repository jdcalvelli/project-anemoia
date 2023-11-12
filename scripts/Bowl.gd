extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area:Area2D):
	# this is an incredible cheat
	# this means get the topmost node in the scene which is huge
	if area is DraggableFruit:
		get_tree().current_scene.fruitOverBowl = area
	
func _on_area_exited(area:Area2D):
	if area is DraggableFruit:
		get_tree().current_scene.fruitOverBowl= null
		
# this seems kind of a bad way to do this?
func _input(event):
	if event.is_action_pressed("mouseClick"):
		if get_tree().current_scene.fruitOverBowl and get_tree().current_scene.fruitOverBowl.isCut:
			match get_tree().current_scene.fruitOverBowl.fruitType:
				"apple":
					$AppleInBowl.visible = true
				"cantaloupe":
					$CantaloupeInBowl.visible = true
				"pear":
					$PearInBowl.visible = true
				"pineapple":
					$PineappleInBowl.visible = true
			get_tree().current_scene.fruitOverBowl.queue_free()
			get_tree().current_scene.fruitInHand = null
			get_tree().current_scene.fruitOnBoard = null
