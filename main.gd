extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass

func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 360
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get to Work!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_start_timer_timeout():
	$ScoreTimer.start()
	
func _on_score_timer_timeout():
	score -= 1
	$HUD.update_score(score)
	#if score != 0:
	#	$game_over.start()
	
