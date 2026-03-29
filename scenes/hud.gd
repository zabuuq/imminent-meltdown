extends CanvasLayer

signal game_won(items_fixed: int)

var damages := 0
var cooldowns := 0
var items_fixed := 0


func add_damage() -> void:
	damages += 1
	$DamagesContainer/VBoxContainer/HBoxContainer/DamagesLabel.text = str(damages)


func remove_damage() -> void:
	damages -= 1
	$DamagesContainer/VBoxContainer/HBoxContainer/DamagesLabel.text = str(damages)
	if damages == 0 and cooldowns == 0:
		game_won.emit(items_fixed)


func add_cooldown() -> void:
	cooldowns += 1
	items_fixed += 1
	$DamagesContainer/VBoxContainer/HBoxContainer2/CooldownLabel.text = str(cooldowns)
	$ScoreContainer/HBoxContainer/ScoreLabel.text = str(items_fixed)


func remove_cooldown() -> void:
	cooldowns -= 1
	$DamagesContainer/VBoxContainer/HBoxContainer2/CooldownLabel.text = str(cooldowns)
	if damages == 0 and cooldowns == 0:
		game_won.emit(items_fixed)


func set_meltdown_time(t: int) -> void:
	$TimerContainer/HBoxContainer/MeltdownDisplay.text = "%02d:%02d" % [int(t / 60.0), t % 60]


func _on_player_update_health(health: float) -> void:
	var child_num := 0.0

	for child in $LivesContainer.get_children():
		child_num += 1

		if health == child_num - 0.5:
			child.animation = 'half_life'
		elif health < child_num:
			child.animation = 'no_life'
		else:
			child.animation = 'default'
