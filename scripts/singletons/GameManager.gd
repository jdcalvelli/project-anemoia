extends Node

func changeScene(scenePath:String) -> void:
	get_tree().change_scene_to_file(scenePath)
