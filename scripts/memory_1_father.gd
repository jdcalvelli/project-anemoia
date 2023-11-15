extends Node2D
class_name memOneFatherController

### this is like management for just this scene

var fruitInHand:DraggableFruit
var fruitOnBoard:DraggableFruit
var fruitOverBowl:DraggableFruit

func _ready():
	$barkTimer.timeout.connect(_on_bt_timeout)

func _on_bt_timeout():
	# display a random bark
	$BarkManager.displayBark(randi_range(1, $BarkManager.numBarks))
	# change timer length to be a random amount
	$barkTimer.wait_time = randi_range(3, 6)

func _physics_process(delta):
	if fruitInHand:
		print("fruit in hand")
		if fruitOnBoard:
			print("fruit over board")
		elif fruitOverBowl:
			print("fruit in hand and over bowl")
	elif !fruitInHand:
		if fruitOnBoard:
			print("fruit on board")
			if fruitOnBoard.isCut:
				print("fruit cut too")
