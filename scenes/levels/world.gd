class_name WorldParent
extends Node2D

var player_is_at_start := true
func _ready() -> void:
	send_player_to_start()

func _process(_delta: float) -> void:
	$Camera.position.x = $Player.position.x
	
	if $Player.position.distance_to($StartingPosition.position) > 50 and player_is_at_start:
		UI.start_level_timer()
	if $Player.position.distance_to($EndingPosition.position) < 50:
		UI.stop_level_timer()
	
func send_player_to_start():
	$Player.position = $StartingPosition.position
	for ring in get_tree().get_nodes_in_group("Ring"):
		ring.reset()
	Globals.ring_count = 0
	Globals.float_remaining = 100
	UI.stop_level_timer()
	UI.reset_level_timer()
	player_is_at_start = true


func _on_player_fell_down() -> void:
	send_player_to_start()
