extends CanvasLayer

var damages := 0
var cooldowns := 0


func add_damage() -> void:
	damages += 1
	$DamagesMargin/VBoxContainer/HBoxContainer/DamagesLabel.text = str(damages)


func remove_damage() -> void:
	damages -= 1
	$DamagesMargin/VBoxContainer/HBoxContainer/DamagesLabel.text = str(damages)


func add_cooldown() -> void:
	cooldowns += 1
	$DamagesMargin/VBoxContainer/HBoxContainer2/CooldownLabel.text = str(cooldowns)


func remove_cooldown() -> void:
	cooldowns -= 1
	$DamagesMargin/VBoxContainer/HBoxContainer2/CooldownLabel.text = str(cooldowns)


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
