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
