extends CharacterBody2D

var direction_x := 0
var direction_y := 0
var speed := 150

func _process(delta: float) -> void:
	get_input()
	
	if direction_x != 0:
		velocity.x = direction_x * speed
		velocity.y = 0
		
	if direction_y != 0:
		velocity.y = direction_y * speed
		velocity.x = 0
	
	move_and_slide()
	set_animation()

func get_input():
	direction_x = Input.get_axis("move_left","move_right")
	direction_y = Input.get_axis("move_up","move_down")

func set_animation():
	if velocity:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "vertical"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down" if velocity.y > 0 else "up"
