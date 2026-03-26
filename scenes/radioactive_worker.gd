extends CharacterBody2D

var speed := 75
var goal: Node


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if (!$NavigationAgent2D.is_navigation_finished()):
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed
		move_and_slide()
		set_animation()


func set_animation():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "horizontal"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "down" if velocity.y > 0 else "up"


func set_random_target() -> void:
	var nav_candidates: Array[Node] = []
	var main = get_tree().root.get_node("Main")

	nav_candidates.append_array(main.get_node("Player").get_children())
	for rad_worker in main.get_node("RadWorker").get_children():
		if rad_worker != self:
			nav_candidates.append(rad_worker)
	nav_candidates.append_array(main.get_node("Objects").get_children())

	if nav_candidates.is_empty():
		return

	goal = nav_candidates[randi() % nav_candidates.size()]
	
	$NavigationAgent2D.target_position = goal.global_position


func _on_start_moving_timer_timeout() -> void:
	set_random_target()


func _on_navigation_agent_2d_navigation_finished() -> void:
	set_random_target()


func _on_follow_timer_timeout() -> void:
	#if ($NavigationAgent2D.target_position != goal.global_position):
		#$NavigationAgent2D.target_position = goal.global_position
		
	$FollowTimer.start()
