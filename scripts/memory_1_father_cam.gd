extends Camera2D

enum FatherPerspectives
{
	CUTTING_BOARD,
	PANTRY,
	KIDS,
	BOWL,
}

enum CameraDirections 
{
	LEFT,
	RIGHT,
	UP,
	DOWN
}

@export var camLimit:int

var isCamTweening:bool = false

var currentPerspective:FatherPerspectives = FatherPerspectives.CUTTING_BOARD
var allowedCamDirections:Array

func _process(delta):
	
	# establishing camera limits based on margin camLimit
	var rightCamLimit = (get_viewport_rect().size.x / 2) - camLimit
	var leftCamLimit = -rightCamLimit
	var lowerCameraLimit = (get_viewport_rect().size.y / 2) - camLimit
	var upperCameraLimit = -lowerCameraLimit
	
	# allow movement directions based on current state
	match currentPerspective:
		FatherPerspectives.CUTTING_BOARD:
			allowedCamDirections = [
				CameraDirections.LEFT, 
				CameraDirections.UP, 
				CameraDirections.RIGHT
			]
		FatherPerspectives.PANTRY:
			allowedCamDirections = [
				CameraDirections.RIGHT
			]
		FatherPerspectives.KIDS:
			allowedCamDirections = [
				CameraDirections.DOWN
			]
		FatherPerspectives.BOWL:
			allowedCamDirections = [
				CameraDirections.LEFT
			]
	
	# control flow for actually sending camera
	if !isCamTweening:
		if (get_local_mouse_position().y <= upperCameraLimit 
		and allowedCamDirections.has(CameraDirections.UP)):
			isCamTweening = true
			_createCameraTween(CameraDirections.UP, 1)
			_changePerspective(CameraDirections.UP)
		elif (get_local_mouse_position().y >= lowerCameraLimit
		and allowedCamDirections.has(CameraDirections.DOWN)):
			isCamTweening = true
			_createCameraTween(CameraDirections.DOWN, 1)
			_changePerspective(CameraDirections.DOWN)
		elif (get_local_mouse_position().x >= rightCamLimit
		and allowedCamDirections.has(CameraDirections.RIGHT)):
			isCamTweening = true
			_createCameraTween(CameraDirections.RIGHT, 1)
			_changePerspective(CameraDirections.RIGHT)
		elif (get_local_mouse_position().x <= leftCamLimit
		and allowedCamDirections.has(CameraDirections.LEFT)):
			isCamTweening = true
			_createCameraTween(CameraDirections.LEFT, 1)
			_changePerspective(CameraDirections.LEFT)

# helper function for creating a tween in the right direction
func _createCameraTween(direction:CameraDirections, timing:float):
	# this is less disgusting
	var property:String
	var finalValue:int
	
	match direction:
		CameraDirections.LEFT:
			property = "position:x"
			finalValue = position.x-1920
		CameraDirections.RIGHT:
			property = "position:x"
			finalValue = position.x+1920
		CameraDirections.UP:
			property = "position:y"
			finalValue = position.y-1080
		CameraDirections.DOWN:
			property = "position:y"
			finalValue = position.y+1080
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		self,
		property,
		finalValue,
		timing
	)
	tween.tween_callback(
		func():
			print("test")
			await get_tree().create_timer(2).timeout
			print("test 2")
			isCamTweening = false
	)

# helper function for determining what the new state is
func _changePerspective(movementDirection:CameraDirections):
	match movementDirection:
		CameraDirections.LEFT:
			match currentPerspective:
				FatherPerspectives.CUTTING_BOARD:
					currentPerspective = FatherPerspectives.PANTRY
				FatherPerspectives.BOWL:
					currentPerspective = FatherPerspectives.CUTTING_BOARD
		CameraDirections.RIGHT:
			match currentPerspective:
				FatherPerspectives.PANTRY:
					currentPerspective = FatherPerspectives.CUTTING_BOARD
				FatherPerspectives.CUTTING_BOARD:
					currentPerspective = FatherPerspectives.BOWL
		CameraDirections.UP:
			match currentPerspective:
				FatherPerspectives.CUTTING_BOARD:
					currentPerspective = FatherPerspectives.KIDS
		CameraDirections.DOWN:
			match currentPerspective:
				FatherPerspectives.KIDS:
					currentPerspective = FatherPerspectives.CUTTING_BOARD
