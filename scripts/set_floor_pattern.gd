# This is a script for randomizing the floor tiles. It is run manually.
# I'm keeping in case I want to change the tiles again.

@tool
extends EditorScript

func _run() -> void:
	var rng := RandomNumberGenerator.new()
	var scene := get_scene()
	var floor_layer := scene.find_child("Floor", true, false) as TileMapLayer

	if not floor_layer:
		print("ERROR: Floor layer not found")
		return

	var cells := floor_layer.get_used_cells()
	for cell in cells:
		var random_num = rng.randi_range(0,100)

		# set initial values
		var atlas_x = 22
		var atlas_y := 1 if (cell.x + cell.y + rng.randi_range(0,3) ) % 3 == 0 else 0

		# randomize x
		if random_num >= 0 and random_num <= 50:
			atlas_x = 22
		if random_num > 50 and random_num <= 70:
			atlas_x = 14
		if random_num > 40:
			atlas_x = 22 if (cell.x + cell.y) % 2 == 0 else 23
			atlas_x = atlas_x if rng.randi_range(0 ,50) > 0 else atlas_x - 8

		atlas_y = 0 if atlas_x == 22 and rng.randi_range(0 ,10) > 0 else atlas_y

		floor_layer.set_cell(cell, 0, Vector2i(atlas_x, atlas_y))

	print("Updated ", cells.size(), " tiles.")
