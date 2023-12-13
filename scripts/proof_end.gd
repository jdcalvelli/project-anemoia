extends Node2D

var spaceLock = false
# Called when the node enters the scene tree for the first time.
func _ready():
	cutFade()
	$Background.hide()
	$LabelSpace.hide()
	$LabelSpace2.hide()
	await get_tree().create_timer(3).timeout
	$LabelSpace.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept") && spaceLock == false:
		spaceLock = true
		await get_tree().create_timer(.5).timeout
		$LabelSpace.hide()
		$Background.show()
		await get_tree().create_timer(9).timeout
		$LabelSpace2.show()
	if Input.is_action_pressed("ui_accept") && $Background.visible == true: 
		get_tree().change_scene_to_file("res://scenes/garden_intro.tscn")


func cutFade():
	var tween = get_tree().create_tween()
	tween.tween_property($Cut, "modulate", Color (1,1,1,0),4)
