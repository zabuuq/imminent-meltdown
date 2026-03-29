extends Area2D

var cell: Vector2i
var conduits_layer: TileMapLayer
var hud: Node
var meltdown_timer: Timer
var on_fixed: Callable


func _ready() -> void:
	$FixTimer.timeout.connect(_on_fix_timer_timeout)


func _process(_delta: float) -> void:
	if not $FixTimer.is_stopped():
		$MarginContainer/Label.text = str(ceili($FixTimer.time_left))


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	var holding := body.get_node("Holding")
	if holding.get_child_count() == 0:
		return

	var broken_coord := conduits_layer.get_cell_atlas_coords(cell)
	conduits_layer.set_cell(cell, conduits_layer.get_cell_source_id(cell), ConduitMap.get_fixed(broken_coord))

	holding.get_child(0).queue_free()
	hud.add_cooldown()
	hud.remove_damage()
	meltdown_timer.start(meltdown_timer.time_left + 15.0)
	on_fixed.call_deferred()

	$CollisionShape2D.set_deferred("disabled", true)
	$RedRect.hide()
	$YellowRect.show()
	$MarginContainer/Label.show()
	$FixTimer.start()


func _on_fix_timer_timeout() -> void:
	hud.remove_cooldown()
	queue_free()
