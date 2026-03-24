extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ball")
#	body_entered.connect(_on_body_entered)
#	area_entered.connect(_on_area_entered)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_body_entered(_body):
	print("Collided with:", _body.name)
	#Make ball dissapear if player collides with ball
	if _body.is_in_group("player"):
		queue_free()

#func _on_area_entered(area):
#	if area.is_in_group("player"):
#		queue_free()
