extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide() #hides the player when the game starts

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
#	pass

var velocity = Vector2.ZERO # The player's movement vector. Use this when you want the player always move

func _process(delta: float):
	#var velocity = Vector2.ZERO # The player's movement vector. Use this when you want the player to stop when not pressing a button
	if Input.is_action_pressed("move_right"):
		velocity.x += 400 #Use 1 when velocity inside loop, 400 when outside
		velocity.y = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= 400 #Use 1 when velocity inside loop, 400 when outside
		velocity.y = 0
	if Input.is_action_pressed("move_down"):
		velocity.y += 400 #Use 1 when velocity inside loop, 400 when outside
		velocity.x = 0
	if Input.is_action_pressed("move_up"):
		velocity.y -= 400 #Use 1 when velocity inside loop, 400 when outside
		velocity.x = 0
	#velocity & position printed for troubleshooting purposes
	#print(velocity)
	#print(position)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
#	# Never flip the sprite vertically
	$AnimatedSprite2D.flip_v = false

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "vertical"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down" if velocity.y > 0 else "up"

func _on_body_entered(_body):
	#hide() # Player disappears after being hit.
	#hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback
	#$CollisionShape2D.set_deferred("disabled", true)
	if _body.is_in_group("hazard"):
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	elif _body.is_in_group("wall"):
		# Push player back (simple wall behavior)
		position -= velocity * 0.1
		velocity = Vector2.ZERO
	elif _body.is_in_group("ball"):
		pass
		
		

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
