extends Node2D
class_name memOneFatherController

### this is like management for just this scene

var fruitInHand:DraggableFruit
var fruitsOnBoard:Array[DraggableFruit]

var fruitOnBoard:DraggableFruit

func _physics_process(delta):
	if fruitInHand and !fruitOnBoard:
		print("fruit in hand")
	elif fruitInHand and fruitOnBoard:
		print("fruit in hand and on board")
	elif !fruitInHand and fruitOnBoard:
		print("fruit just on board")
		if fruitOnBoard.isCut:
			print("fruit cut too")
