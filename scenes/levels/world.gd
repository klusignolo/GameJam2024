extends Node2D


func _ready() -> void:
	send_player_to_start()

func _process(_delta: float) -> void:
	$Camera.position.x = $Player.position.x
	
	if Input.is_action_just_pressed("action_f") and $Player.is_on_floor() and Globals.can_return_to_start:
		send_player_to_start()
	
func send_player_to_start():
	$Player.position = $StartingPosition.position
	Globals.ring_score = 0
	UI.hide_return_to_start_message()
