extends CharacterBody2D

var speed := 75
var goal: Node
var can_move := false
@onready var player = get_tree().get_first_node_in_group('Player')


func _ready() -> void:
	# Set death timer between 5 and 60 seconds
	$DeathTimer.wait_time = randi() % 56 + 5
	$DeathTimer.start()


func _physics_process(delta: float) -> void:
	if can_move:
		if position.distance_to(player.global_position) < 80 and position.distance_to(player.global_position) > 8:
			$NavigationAgent2D.target_position = player.global_position

		if !$NavigationAgent2D.is_navigation_finished():
			var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			velocity = nav_point_direction * speed
			move_and_slide()
			set_animation()


func set_animation():
	if abs(velocity.x) >= abs(velocity.y):
		$AnimatedSprite2D.animation = 'horizontal'
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = 'down' if velocity.y > 0 else 'up'


func set_random_target() -> void:
	var nav_candidates: Array[Node] = []
	var main = get_tree().root.get_node('Main')

	nav_candidates.append_array(main.get_node('Player').get_children())
	for rad_worker in main.get_node('RadWorker').get_children():
		if rad_worker != self and rad_worker is CharacterBody2D:
			nav_candidates.append(rad_worker)
	nav_candidates.append_array(main.get_node('Objects').get_children())

	if nav_candidates.is_empty():
		return

	goal = nav_candidates[randi() % nav_candidates.size()]
	
	$NavigationAgent2D.target_position = goal.global_position


func _on_start_moving_timer_timeout() -> void:
	can_move = true
	set_random_target()


func _on_navigation_agent_2d_navigation_finished() -> void:
	set_random_target()


func _on_death_timer_timeout() -> void:
	can_move = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.animation = 'dying'
	$DyingTimer.start()


func _on_dying_timer_timeout() -> void:
	queue_free()
