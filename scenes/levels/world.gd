extends Node2D

func _ready() -> void:
	send_player_to_start()

func _process(_delta: float) -> void:
	$Camera.position.x = $Player.position.x
	
func send_player_to_start():
	$Player.position = $StartingPosition.position
	Globals.ring_score = 0
	UI.hide_return_to_start_message()
	UI.stop_level_timer()
	UI.reset_level_timer()


func _on_player_fell_down() -> void:
	send_player_to_start()
