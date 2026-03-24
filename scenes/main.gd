extends Node

@export var radioactive_worker_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	$OuterWallCollisions.add_to_group("wall")

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
	$HUD.show_message("Get to work!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_start_timer_timeout():
	$ScoreTimer.start()
	$RWMobTimer.start()
	
func _on_score_timer_timeout():
	score -= 1
	$HUD.update_score(score)
	
	if score != 359:
		$HUD.show_message("No time to stop!")
	if score != 358:
		$HUD.show_message("")
	if score <= 0:
		game_over()
	

func _on_rw_mob_timer_timeout():
# Create a new instance of the radioactive_worker scene.
	var RWmob = radioactive_worker_scene.instantiate()
	
	#Choose a random location on Path2D.
	var RWmob_spawn_location = $RWMobPath/RWMobSpawnLocation
	RWmob_spawn_location.progress_ratio = randf()
	
	#Set the mob's position to the random location.
	RWmob.position = RWmob_spawn_location.position
	
	#Set the mob's direction perpendicular to the path direction.
	var direction = RWmob_spawn_location.rotation + PI / 2
	
	#Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	#RWmob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	RWmob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main Scene
	add_child(RWmob)
