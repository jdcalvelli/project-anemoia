extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area:Area2D):
	# this is an incredible cheat
	# this means get the topmost node in the scene which is huge
	if area is DraggableFruit:
		get_tree().current_scene.fruitOnBoard = area
		print("fruit saved")
	
func _on_area_exited(area:Area2D):
	if area is DraggableFruit:
		get_tree().current_scene.fruitOnBoard = null
		print("fruit removed")
