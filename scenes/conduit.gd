extends Area2D

const OBJECT = preload('res://scenes/conduit.tscn')

var can_pick_up = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rng := RandomNumberGenerator.new()
	position.y += sin(Time.get_ticks_msec() / rng.randf_range(175, 200)) * 10 * delta


func drop() -> void:
	can_pick_up = false
	$CoolDown.start()


func _on_cool_down_timeout() -> void:
	can_pick_up = true


func _on_body_entered(body: Node2D) -> void:
	if can_pick_up and body.has_node('Holding') and body.get_node('Holding').get_child_count() == 0:
		var conduit = OBJECT.instantiate()
		conduit.position = Vector2.ZERO
		body.get_node('Holding').add_child(conduit)
		if body.has_node('DropTimer'):
			body.get_node('DropTimer').wait_time = randi_range(1, 10)
			body.get_node('DropTimer').start()
		queue_free.call_deferred()
