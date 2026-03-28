extends CanvasLayer


func set_meltdown_time(t: int) -> void:
	$TimerMargin/HBoxContainer/MeltdownDisplay.text = "%02d:%02d" % [int(t / 60.0), t % 60]


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
