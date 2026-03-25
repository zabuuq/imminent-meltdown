extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	add_to_group("player")
	$BlueCircle.hide()
#	
#func _process(delta: float) -> void:
#	pass
	
func start():
	position = $StartPosition.position
	
signal hit

@export var speed = 400

var input_direction = Vector2.ZERO # The player's movement vector. Use this when you want the player always move

func _physics_process(delta):
	#var input_direction = Vector2.ZERO # The player's movement vector. Use this when you want the player to stop when not pressing a button
	
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
		input_direction.y = 0
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
		input_direction.y = 0
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
		input_direction.x = 0
	if Input.is_action_pressed("move_up"):
		input_direction.y -= 1
		input_direction.x = 0

	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		velocity = input_direction * speed
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	move_and_slide()

	# Check collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		
		if body.is_in_group("hazard"):
			die()
		elif body.is_in_group("wall"):
			#velocity = -velocity
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal)
			input_direction = velocity.normalized()
			move_and_slide()
		elif body.is_in_group("ball"):
			$BlueCircle.show()

	# Animation
	$AnimatedSprite2D.flip_v = false

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "vertical"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down" if velocity.y > 0 else "up"


func die():
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
