extends Area2D

const CONDUIT = preload("res://scenes/conduit.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() / 200) * 10 * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_node("Holding") and body.get_node("Holding").get_child_count() == 0:
		var conduit = CONDUIT.instantiate()
		conduit.position = Vector2.ZERO
		body.get_node("Holding").add_child(conduit)
		queue_free()
