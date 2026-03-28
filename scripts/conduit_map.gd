# conduit_map.gd
# Maps fixed conduit tile coordinates to their broken counterparts and vice versa.
#
# Tile coordinates are Vector2i(column, row) in the tileset atlas.
# Tile size: 16×16 with 1px separation. Conduit region: cols 0–25, rows 4–7.
#
# Pairing layout:
#   Region 1 — 3×3 block: cols 0–2, rows 4–6  ↔  cols 3–5, rows 4–6
#   Region 2 — Row 7:     (0,7)↔(2,7), (1,7)↔(3,7), (4,7)↔(5,7)
#   Region 3 — 2×2 groups, cols 6–25, rows 4–7:
#               each group of 4 tiles pairs with the next group to the right
#               (6–7)↔(8–9), (10–11)↔(12–13), (14–15)↔(16–17),
#               (18–19)↔(20–21), (22–23)↔(24–25)
#               repeated independently for row bands 4–5 and 6–7
#
# Usage (static — no instance needed):
#   ConduitMap.get_broken(Vector2i(1, 4))   # → broken tile coord
#   ConduitMap.get_fixed(Vector2i(4, 4))    # → fixed tile coord
#   ConduitMap.is_fixed_conduit(coord)      # → bool
#   ConduitMap.is_broken_conduit(coord)     # → bool
#   ConduitMap.is_conduit(coord)            # → bool (fixed or broken)

class_name ConduitMap

static var _fixed_to_broken: Dictionary
static var _broken_to_fixed: Dictionary


static func _static_init() -> void:
	_fixed_to_broken = {}
	_broken_to_fixed = {}

	# Region 1: 3×3 block pair (cols 0–2 fixed, cols 3–5 broken), rows 4–6
	for row in range(4, 7):
		for col in range(0, 3):
			_pair(Vector2i(col, row), Vector2i(col + 3, row))

	# Region 2: row-7 pairs
	_pair(Vector2i(0, 7), Vector2i(2, 7))
	_pair(Vector2i(1, 7), Vector2i(3, 7))
	_pair(Vector2i(4, 7), Vector2i(5, 7))

	# Region 3: 2×2 group pairs, cols 6–25
	# Each pair of groups spans 4 columns; first 2 cols are fixed, next 2 are broken.
	for row_band in [[4, 5], [6, 7]]:
		for base_col in range(6, 24, 4):  # 6, 10, 14, 18, 22
			for row in row_band:
				_pair(Vector2i(base_col,     row), Vector2i(base_col + 2, row))
				_pair(Vector2i(base_col + 1, row), Vector2i(base_col + 3, row))


static func _pair(fixed: Vector2i, broken: Vector2i) -> void:
	_fixed_to_broken[fixed] = broken
	_broken_to_fixed[broken] = fixed


# Returns the broken version of a fixed conduit tile.
# Returns Vector2i(-1, -1) if the coord is not a fixed conduit.
static func get_broken(fixed: Vector2i) -> Vector2i:
	return _fixed_to_broken.get(fixed, Vector2i(-1, -1))


# Returns the fixed version of a broken conduit tile.
# Returns Vector2i(-1, -1) if the coord is not a broken conduit.
static func get_fixed(broken: Vector2i) -> Vector2i:
	return _broken_to_fixed.get(broken, Vector2i(-1, -1))


static func is_fixed_conduit(coord: Vector2i) -> bool:
	return _fixed_to_broken.has(coord)


static func is_broken_conduit(coord: Vector2i) -> bool:
	return _broken_to_fixed.has(coord)


static func is_conduit(coord: Vector2i) -> bool:
	return _fixed_to_broken.has(coord) or _broken_to_fixed.has(coord)
