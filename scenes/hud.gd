extends CanvasLayer

# Notifies 'Main' node that the button has been pressed
# signal start_game

func show_message(text):
	print(text)
	$MessageContainer/Message.text = text
	$MessageContainer/Message.show()
	$MessageTimer.start()
	
	await $MessageTimer.timeout
	
	$MessageContainer/Message.hide()
	

func show_game_over():
	pass
	#show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	#await $MessageTimer.timeout
	
	#$Message.text = "Imminent Meltdown!"
	#$Message.show()
	# Make a one-shot timer and wait for it to finish.
	#await get_tree().create_timer(1.0).timeout
	#$StartButton.show()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_score(score):
	$MarginContainer/ScoreLabel.text = str(score)

#func _on_start_button_pressed():
	#$StartButtonMargin.hide()
	#start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
