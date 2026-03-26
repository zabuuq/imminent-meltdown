extends Node

const CONDUIT_SCENE = preload("res://scenes/conduit.tscn")
const MAX_ATTEMPTS = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.position = $Player/StartPosition.position
	$Mobs/RadioactiveWorker.position = $Mobs/RadioactiveWorker/StartPosition.position
	spawn_objects(CONDUIT_SCENE, 25)


func spawn_objects(object_scene: PackedScene, count: int) -> void:
	var rng := RandomNumberGenerator.new()
	var walls := $Map/Walls as TileMapLayer
	var machines := $Map/Machines as TileMapLayer
	var machine_innards := $Map/MachineInnards as TileMapLayer
	var tile_size: Vector2i = walls.tile_set.tile_size

	var min_tile := Vector2i(0, 0)
	var max_tile := Vector2i(99, 49)

	var placed := 0
	var attempts := 0

	while placed < count and attempts < MAX_ATTEMPTS:
		attempts += 1
		var tile := Vector2i(
			rng.randi_range(min_tile.x, max_tile.x),
			rng.randi_range(min_tile.y, max_tile.y)
		)

		var is_blocked := walls.get_cell_source_id(tile) != -1
		is_blocked = true if machines.get_cell_source_id(tile) != -1 else is_blocked
		is_blocked = true if machine_innards.get_cell_source_id(tile) != -1 else is_blocked

		if not is_blocked:
			var conduit := object_scene.instantiate()
			add_child(conduit)
			conduit.position = Vector2(tile * tile_size)
			placed += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
