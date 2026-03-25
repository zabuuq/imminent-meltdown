extends CharacterBody2D

var input_direction = Vector2.ZERO
var speed := 150

func _process(_delta: float) -> void:
	handle_movement()
	handle_collisions()

func handle_movement():
	input_direction.x = Input.get_axis("move_left","move_right")
	input_direction.y = Input.get_axis("move_up","move_down")
	
	if input_direction.length() > 0:
		velocity = input_direction * speed

	move_and_slide()
	set_animation()

func set_animation():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "vertical"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down" if velocity.y > 0 else "up"

func handle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMapLayer and collider.get_parent().name == "Map":
			#velocity = velocity.bounce(collision.get_normal())
			pass
