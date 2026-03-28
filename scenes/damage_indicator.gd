extends Area2D

var cell: Vector2i
var conduits_layer: TileMapLayer
var hud: Node


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	var holding := body.get_node("Holding")
	if holding.get_child_count() == 0:
		return

	var broken_coord := conduits_layer.get_cell_atlas_coords(cell)
	conduits_layer.set_cell(cell, conduits_layer.get_cell_source_id(cell), ConduitMap.get_fixed(broken_coord))

	holding.get_child(0).queue_free()
	hud.remove_damage()
	queue_free()
