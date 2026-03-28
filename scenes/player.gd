extends CharacterBody2D

signal update_health(health: float)


var input_direction = Vector2.ZERO
var speed := 100
var health := 5.0
var can_move := false


func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_dropping()
	handle_collisions()


func handle_movement():
	if not can_move:
		return
	input_direction.x = Input.get_axis('move_left','move_right')
	input_direction.y = Input.get_axis('move_up','move_down')

	if input_direction.length() > 0:
		velocity = input_direction * speed

	move_and_slide()
	set_animation()


func start_moving() -> void:
	can_move = true
	velocity = Vector2([-1, 1].pick_random() * speed, 0)
	set_animation()


func set_animation():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = 'horizontal'
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = 'down' if velocity.y > 0 else 'up'


func handle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMapLayer and collider.get_parent().name == 'Map':
			velocity = velocity.bounce(collision.get_normal())
			pass


func handle_dropping():
	if Input.is_action_just_pressed('drop_item'):
		var holding = $Holding
		if holding.get_child_count() == 0:
			return
		var item = holding.get_child(0)
		holding.remove_child(item)
		get_parent().add_child(item)

		var drop_dir := -velocity.normalized() if velocity != Vector2.ZERO else Vector2(0, 1)
		var drop_pos := global_position + drop_dir * 8
		var nav_map = get_world_2d().navigation_map
		if not _is_on_navmesh(nav_map, drop_pos):
			var perp := Vector2(-drop_dir.y, drop_dir.x)
			if _is_on_navmesh(nav_map, global_position + perp * 16):
				drop_pos = global_position + perp * 16
			elif _is_on_navmesh(nav_map, global_position - perp * 16):
				drop_pos = global_position - perp * 16
			else:
				drop_pos = global_position

		drop_pos = snap_to_tile_center(drop_pos)
		if drop_pos == snap_to_tile_center(global_position):
			var tile_step := Vector2(16.0 * sign(drop_dir.x), 0) if abs(drop_dir.x) >= abs(drop_dir.y) \
				else Vector2(0, 16.0 * sign(drop_dir.y))
			var candidate := drop_pos + tile_step
			if _is_on_navmesh(nav_map, candidate + Vector2(8, 8)):
				drop_pos = candidate

		item.global_position = drop_pos
		if item.has_method('drop'):
			item.drop()


func snap_to_tile_center(pos: Vector2) -> Vector2:
	return (pos / 16.0).floor() * 16.0


func _is_on_navmesh(nav_map: RID, pos: Vector2) -> bool:
	return NavigationServer2D.map_get_closest_point(nav_map, pos).distance_to(pos) < 2.0


func _on_area_2d_body_entered(_body: Node2D) -> void:
	health -= 1
	update_health.emit(health)
	
	if health <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
		
	if $HealTimer.is_stopped():
		$HealTimer.start()
		


func _on_heal_timer_timeout() -> void:
	health += 0.5
	update_health.emit(health)
	
	if health < 5:
		$HealTimer.start()
