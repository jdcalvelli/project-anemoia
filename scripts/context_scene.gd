extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	await get_tree().create_timer(2).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/garden_intro.tscn")
