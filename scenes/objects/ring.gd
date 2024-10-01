extends StaticBody2D

var has_player_entered_ring = false
var has_score_been_claimed = false

func _on_ring_exit_body_entered(_body: Node2D) -> void:
	if has_player_entered_ring and not has_score_been_claimed:
		has_score_been_claimed = true
		Globals.ring_count += 1               
		has_player_entered_ring = false 
		
func _on_ring_entry_body_entered(_body: Node2D) -> void:
	has_player_entered_ring = true
	
func reset():
	has_player_entered_ring = false
	has_score_been_claimed = false
