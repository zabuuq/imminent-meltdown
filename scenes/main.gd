extends Node

const CONDUIT_SCENE = preload('res://scenes/conduit.tscn')
const RAD_WORKER_SCENE = preload('res://scenes/radioactive_worker.tscn')
const MAX_ATTEMPTS = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/Player.position = $Player/StartPosition.position
	spawn_objects(CONDUIT_SCENE, 25)
	$MeltdownTimer.timeout.connect(_on_meltdown_timer_timeout)


func _process(_delta: float) -> void:
	if not $StartTimer.is_stopped():
		var t: int = ceili($StartTimer.time_left)
		$HUD.get_node("MessageContainer/VBoxContainer/Countdown").text = str(t)
		var msg := $HUD.get_node("MessageContainer/VBoxContainer/Message")
		if t <= 1:
			msg.text = "Go!"
		elif t <= 2:
			msg.text = "Set"
		elif t <= 3:
			msg.text = "Ready"
		elif t <= 7:
			msg.text = "No time to stop!"
	if not $MeltdownTimer.is_stopped():
		$HUD.set_meltdown_time(ceili($MeltdownTimer.time_left))


func _on_start_timer_timeout() -> void:
	$HUD.get_node("MessageContainer/VBoxContainer/Countdown").text = ""
	$HUD.get_node("MessageContainer/VBoxContainer/Message").text = ""
	$RadWorker/MobSpawnTimer.start()
	$MeltdownTimer.start()
	$Player/Player.start_moving()


func _on_meltdown_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")


func spawn_objects(object_scene: PackedScene, count: int) -> void:
	var floor_layer := $Map/Floor as TileMapLayer
	var tile_size: Vector2i = floor_layer.tile_set.tile_size

	var min_tile := Vector2i(0, 0)
	var max_tile := Vector2i(99, 49)

	var placed := 0
	var attempts := 0

	while placed < count and attempts < MAX_ATTEMPTS:
		attempts += 1
		var tile := Vector2i(
			randi_range(min_tile.x, max_tile.x),
			randi_range(min_tile.y, max_tile.y)
		)

		if floor_layer.get_cell_source_id(tile) != -1:
			var object := object_scene.instantiate()
			$Objects.add_child(object)
			object.global_position = floor_layer.to_global(Vector2(tile * tile_size))
			placed += 1


func _on_mob_spawn_timer_timeout() -> void:
	# Set the next spawn time between 1 and 10 seconds
	$RadWorker/MobSpawnTimer.wait_time = randi_range(1, 10)

	var rad_worker := RAD_WORKER_SCENE.instantiate()
	rad_worker.position = $RadWorker/StartPosition.position
	$RadWorker.add_child(rad_worker)
