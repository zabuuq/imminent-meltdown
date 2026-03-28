extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
