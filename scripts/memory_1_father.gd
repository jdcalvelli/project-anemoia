extends Node2D
class_name memOneFatherController

### this is like management for just this scene

var fruitInHand:DraggableFruit
var fruitOnBoard:DraggableFruit
var fruitOverBowl:DraggableFruit

# timers for camera tweens
var waitTime: int = 10
var timers:Array[Timer]

#lerp factor
var lerpFactor = 20

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
			# call the change lowpass
			AudioManager.changeLowPassState(0)
			
			var col = get_tree().create_tween()
			col.tween_property($memory_1_father_cam/Blur, "modulate", Color(.411765,0.411765,0.411765),15).set_ease(Tween.EASE_OUT_IN)
			
			#creating a tween for the blur that will decrease in scale and hover
			var tween = get_tree().create_tween().set_loops(3)
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.62,0.969), 5).set_ease(Tween.EASE_OUT_IN)
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.67,1.047), 5).set_ease(Tween.EASE_OUT_IN)
			
		1:
			#blur color shift 
			$memory_1_father_cam/Blur.self_modulate = Color (.411765,0.411765,0.411765)
			var col = get_tree().create_tween()
			col.tween_property($memory_1_father_cam/Blur, "modulate", Color(0.184314, 0.309804, 0.309804),15).set_ease(Tween.EASE_OUT_IN)
			
			print("mid done")
			_tweenCamTowardCigs(2)
			$Cigs.tweenCigs()
			# call the change lowpass
			AudioManager.changeLowPassState(1)
			
		
			var tween = get_tree().create_tween().set_loops(3)
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.62,0.969), 4.5).set_ease(Tween.EASE_OUT_IN)
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.57,0.891), 4.5).set_ease(Tween.EASE_OUT_IN)
		2:
			#blur color shift 2
			$memory_1_father_cam/Blur.self_modulate = Color (0.184314, 0.309804, 0.309804)
			
			print("end done")
			_tweenCamTowardCigs(3)
			$Cigs.tweenCigs()
			# call the change lowpass
			AudioManager.changeLowPassState(2)
			# the changing of the cig picture
			$Cigs/CigClosed.visible = false
			$Cigs/CigBack.visible = true
			$Cigs/Cig.visible = true
			$Cigs/Cig.canBeGrabbed = true
			
			var tween = get_tree().create_tween().set_loops()
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.57,0.891), 3).set_ease(Tween.EASE_OUT_IN)
			tween.tween_property($memory_1_father_cam/Blur, "scale", Vector2(0.62,0.969), 3).set_ease(Tween.EASE_OUT_IN)

func _tweenCamTowardCigs(nextTimerID:int):
	var tweenCam = create_tween()
	tweenCam.set_ease(Tween.EASE_IN_OUT)
	tweenCam.set_trans(Tween.TRANS_CUBIC)
	tweenCam.tween_property(
		$memory_1_father_cam,
		"position",
		Vector2($memory_1_father_cam.position + Vector2(50, 50)),
		1
	)
	tweenCam.tween_callback(
		func():
			if nextTimerID < timers.size():
				timers[nextTimerID].start()
			# increase lerp factor by 20
			lerpFactor -= 6.5
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
