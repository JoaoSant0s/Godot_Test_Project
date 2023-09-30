extends Node

class_name BootScene

func _ready():
	get_tree().change_scene_to_file(BootConfig.Instance.nextScene())
