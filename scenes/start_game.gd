extends Control

var start_level: PackedScene = load("res://scenes/game.tscn")

func _ready() -> void:
	if has_node("DeathSound"):
		$DeathSound.play()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game"):
		get_tree().change_scene_to_packed(start_level)
