extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('start_game'):
		get_tree().call_deferred("change_scene_to_file", 'res://scenes/main.tscn')
