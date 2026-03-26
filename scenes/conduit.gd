extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() / 200) * 10 * delta


func _on_body_entered(body: Node2D) -> void:
	print("grabbed conduit")
	queue_free()
