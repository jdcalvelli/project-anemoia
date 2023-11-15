extends Node2D
class_name memOneFatherController

### this is like management for just this scene

var fruitInHand:DraggableFruit
var fruitOnBoard:DraggableFruit
var fruitOverBowl:DraggableFruit

# timers for camera tweens
var waitTime: int = 60
var timers:Array[Timer]

func _ready():
	$barkTimer.timeout.connect(_on_bt_timeout)
	
	timers = [Timer.new(), Timer.new(), Timer.new()]
	
	# create the timers
	for timer in timers:
		timer.one_shot = true
		timer.wait_time = waitTime
		timer.timeout.connect(func(): _on_timer_timeout(timers.find(timer)))
		add_child(timer)
	
	timers[0].start()

func _on_bt_timeout():
	# display a random bark
	$BarkManager.displayBark(randi_range(1, $BarkManager.numBarks))
	# change timer length to be a random amount
	$barkTimer.wait_time = randi_range(3, 6)

func _on_timer_timeout(index:int):
	match index:
		0:
			print("start done")
			# tween camera a bit
			_tweenCamTowardCigs(1)
			$Cigs.tweenCigs()
		1:
			print("mid done")
			_tweenCamTowardCigs(2)
			$Cigs.tweenCigs()
		2:
			print("end done")
			_tweenCamTowardCigs(3)
			$Cigs.tweenCigs()
			$Cigs/Cig.canBeGrabbed = true

func _tweenCamTowardCigs(nextTimerID:int):
	var tweenCam = create_tween()
	tweenCam.tween_property(
		$memory_1_father_cam,
		"position",
		Vector2($memory_1_father_cam.position + Vector2(20, 20)),
		1
	)
	tweenCam.tween_callback(
		func():
			if nextTimerID < timers.size():
				timers[nextTimerID].start()
	)

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
	
	# pause the timers so that in the event that cam is tweening
	# the other thing doesnt start
	if $memory_1_father_cam.isCamTweening:
		for timer in timers:
			timer.paused = true
	else:
		for timer in timers:
			timer.paused = false
