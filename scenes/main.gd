extends Node

const CONDUIT_SCENE = preload('res://scenes/conduit.tscn')
const DAMAGE_SCENE = preload('res://scenes/damage_indicator.tscn')
const RAD_WORKER_SCENE = preload('res://scenes/radioactive_worker.tscn')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up the map objects and initial breaks
	spawn_objects(CONDUIT_SCENE, 25)
	for i in 5:
		break_tile()

	$MeltdownTimer.timeout.connect(_on_meltdown_timer_timeout)
	$HUD.game_won.connect(_on_game_won)
	$Player/Player.hud = $HUD
	$"Reactor/RXHeat".self_modulate.a = 0.5

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
		if $HUD.damages > 0:
			var progress = 1.0 - $MeltdownTimer.time_left / $MeltdownTimer.wait_time
			var pulse_speed = lerp(1.0, 10.0, progress)
			var alpha := (sin(Time.get_ticks_msec() / 1000.0 * pulse_speed) + 1.0) / 2.0
			$"Reactor/RXHeat".self_modulate.a = lerp(0.2, 1.0, alpha)
		else:
			var max_time_left := 0.0
			var fix_wait := 1.0
			for obj in $Objects.get_children():
				if obj.has_node("FixTimer") and not obj.get_node("FixTimer").is_stopped():
					var t = obj.get_node("FixTimer").time_left
					if t > max_time_left:
						max_time_left = t
						fix_wait = obj.get_node("FixTimer").wait_time
			$"Reactor/RXHeat".self_modulate.a = max_time_left / fix_wait


func spawn_objects(object_scene: PackedScene, count: int) -> void:
	var floor_layer := $Map/Floor as TileMapLayer

	var floor_tiles := floor_layer.get_used_cells()
	floor_tiles.shuffle()

	for cell in floor_tiles.slice(0, count):
		var object := object_scene.instantiate()
		$Objects.add_child(object)
		object.global_position = floor_layer.to_global(floor_layer.map_to_local(cell))


func break_tile() -> void:
	var conduits := $Map/Conduits as TileMapLayer
	var cells := conduits.get_used_cells()
	cells.shuffle()

	for cell in cells:
		var tile_data := conduits.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("is_breakable"):
			var atlas_coord := conduits.get_cell_atlas_coords(cell)
			if ConduitMap.is_fixed_conduit(atlas_coord):
				var damage_indicator = DAMAGE_SCENE.instantiate()
				damage_indicator.cell = cell
				damage_indicator.conduits_layer = conduits
				damage_indicator.hud = $HUD
				damage_indicator.meltdown_timer = $MeltdownTimer
				damage_indicator.on_fixed = spawn_objects.bind(CONDUIT_SCENE, 1)
				conduits.set_cell(cell, conduits.get_cell_source_id(cell), ConduitMap.get_broken(atlas_coord))
				$Objects.add_child(damage_indicator)
				damage_indicator.global_position = conduits.to_global(conduits.map_to_local(cell))
				$HUD.add_damage()
				return


func _on_start_timer_timeout() -> void:
	$HUD.get_node("MessageContainer/VBoxContainer/Countdown").text = ""
	$HUD.get_node("MessageContainer/VBoxContainer/Message").text = ""
	$HUD.get_node("DamagesContainer").show()
	$HUD.get_node("TimerContainer").show()
	$HUD.get_node("LivesContainer").show()
	$HUD.get_node("ScoreContainer").show()
	$MeltdownTimer.start()
	$DamageTimer.start()
	$RadWorker/MobSpawnTimer.start()
	$Player/Player.start_moving()


func _on_damage_timer_timeout() -> void:
	if $HUD.damages == 0:
		$DamageTimer.stop()
		return

	# Set the next spawn time between 30 and 60 seconds
	$DamageTimer.wait_time = randi_range(30, 60)

	break_tile()


func _on_mob_spawn_timer_timeout() -> void:
	# Set the next spawn time between 1 and 10 seconds
	$RadWorker/MobSpawnTimer.wait_time = randi_range(1, 10)

	var rad_worker := RAD_WORKER_SCENE.instantiate()
	rad_worker.position = $RadWorker/StartPosition.position
	$RadWorker.add_child(rad_worker)


func _on_game_won(items_fixed: int) -> void:
	var time_left := ceili($MeltdownTimer.time_left)
	WinGame.items_fixed = items_fixed
	WinGame.time_left = time_left
	WinGame.score = items_fixed + time_left
	get_tree().call_deferred("change_scene_to_file", "res://scenes/win_game.tscn")


func _on_meltdown_timer_timeout() -> void:
	GameOver.items_fixed = $HUD.items_fixed
	GameOver.time_left = 0
	GameOver.score = $HUD.items_fixed
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
