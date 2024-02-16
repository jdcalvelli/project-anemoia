extends Node
class_name Shot

# data class for each shot

@export var currentCharacter:GameManager.Characters
@export var reverseActions:bool = false

@export var actionScene:bool = false
@export var numRequiredActions:int = 0
var numActionsTaken:int = 0

@export var nextShot:String

func _ready():
	# pass the shot up to the gamemanager
	GameManager.currentShot = self
	# pass the next scene up as preload
	GameManager.nextScene = load(nextShot)
	
	# make sure not can go next
	GameManager.canGoNext = false
	print("cant go next")
	# wait two seconds before interactable
	await get_tree().create_timer(GameManager.goNextWaitTime).timeout
	GameManager.canGoNext = true
	print("can go next")
