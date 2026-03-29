extends Control
class_name WinGame

static var items_fixed: int = 0
static var time_left: int = 0
static var score: int = 0
static var cumulative_score: int = 0
static var level: int = 0


func _ready() -> void:
	var previous_score := cumulative_score
	cumulative_score += score
	level += 1

	var base := $MessageContainer/VBoxContainer/MarginContainer/VBoxContainer
	base.get_node("HBoxContainer1/ItemsFixedLabel").text = str(items_fixed)
	base.get_node("HBoxContainer2/TimeLeftLabel").text = str(time_left)

	if previous_score > 0:
		base.get_node("PreviousScoreContainer").show()
		base.get_node("PreviousScoreContainer/PreviousScoreLabel").text = str(previous_score)
		base.get_node("HBoxContainer3/Label").text = "Total: "
		base.get_node("HBoxContainer3/ScoreLabel").text = str(cumulative_score)
	else:
		base.get_node("HBoxContainer3/ScoreLabel").text = str(score)
	
	$WinSound.play()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('start_game'):
		get_tree().call_deferred("change_scene_to_file", 'res://scenes/main.tscn')
