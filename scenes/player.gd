extends CharacterBody2D

var direction_x := 0
var direction_y := 0
var speed := 150

func _process(delta: float) -> void:
	direction_x = Input.get_axis("move_left","move_right")
	direction_y = Input.get_axis("move_up","move_down")
	
	velocity.x = direction_x * speed
	velocity.y = direction_y * speed
	move_and_slide()
