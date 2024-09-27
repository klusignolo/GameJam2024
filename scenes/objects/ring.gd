extends StaticBody2D

var has_player_entered_ring = false


func _on_ring_exit_body_entered(body: Node2D) -> void:
	if has_player_entered_ring:
		print("Player passed through the ring")
		Globals.ring_score += 1
		has_player_entered_ring = false


func _on_ring_entry_body_entered(body: Node2D) -> void:
	has_player_entered_ring = true
