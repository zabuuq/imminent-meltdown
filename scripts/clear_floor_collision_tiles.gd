# Clears Floor tiles wherever Walls, Machines, or MachineInnards have tiles,
# so Floor represents only navigable space. Run manually via File > Run.

@tool
extends EditorScript

func _run() -> void:
	var scene := get_scene()

	var floor_layer := scene.find_child("Floor", true, false) as TileMapLayer
	var walls := scene.find_child("Walls", true, false) as TileMapLayer
	var machines := scene.find_child("Machines", true, false) as TileMapLayer
	var machine_innards := scene.find_child("MachineInnards", true, false) as TileMapLayer

	if not floor_layer:
		print("ERROR: Floor layer not found")
		return
	if not walls:
		print("ERROR: Walls layer not found")
		return
	if not machines:
		print("ERROR: Machines layer not found")
		return
	if not machine_innards:
		print("ERROR: MachineInnards layer not found")
		return

	var blocked_tiles: Array[Vector2i] = []
	blocked_tiles.append_array(walls.get_used_cells())
	blocked_tiles.append_array(machines.get_used_cells())
	blocked_tiles.append_array(machine_innards.get_used_cells())

	var cleared := 0
	for tile in blocked_tiles:
		if floor_layer.get_cell_source_id(tile) != -1:
			floor_layer.erase_cell(tile)
			cleared += 1

	print("Cleared ", cleared, " Floor tiles.")
