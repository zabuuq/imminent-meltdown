extends Control

const MAIN_SCENE = preload('res://scenes/main.tscn')

func _ready() -> void:
	if has_node('DeathSound'):
		$DeathSound.play()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('start_game'):
		get_tree().change_scene_to_packed(MAIN_SCENE)
