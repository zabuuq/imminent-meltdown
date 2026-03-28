extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$TimerMargin/HBoxContainer/MeltdownDisplay.text = str(ceili($MeltdownTimer.time_left))


func _on_player_update_health(health: float) -> void:
	var child_num := 0.0

	for child in $LivesMargin.get_children():
		child_num += 1

		if health == child_num - 0.5:
			child.animation = 'half_life'
		elif health < child_num:
			child.animation = 'no_life'
		else:
			child.animation = 'default'


func _on_meltdown_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
