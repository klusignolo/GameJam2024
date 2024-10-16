extends StaticBody2D

var has_player_entered_back = false
var has_player_entered_front = false
var has_score_been_claimed = false
@onready var sfx_ring_collect = $sfx_ring_collect

func _on_ring_exit_body_entered(_body: Node2D) -> void:
	if has_score_been_claimed: return
	if has_player_entered_front:
		claim_score()
	else:
		has_player_entered_back = true
		
func _on_ring_entry_body_entered(_body: Node2D) -> void:
	if has_score_been_claimed: return
	if has_player_entered_back:
		claim_score()
	else:
		has_player_entered_front = true

func claim_score():
	sfx_ring_collect.play()
	has_score_been_claimed = true
	Globals.ring_count += 1  
	
func reset():
	has_player_entered_back = false
	has_player_entered_front = false
	has_score_been_claimed = false
