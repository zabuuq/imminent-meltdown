extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("hazard")
#	pass # Replace with function body.

@export var speed = 200 # How fast the Radioactive Worker will move (pixels/sec)
var velocity = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
		
#	# Never flip the sprite vertically
	$AnimatedSprite2D.flip_v = false

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "RWside"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "RWdown" if velocity.y > 0 else "RWup"

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
