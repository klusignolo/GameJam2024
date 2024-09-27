extends CanvasLayer

@onready var return_to_start = $ReturnToStartContainer/Label
@onready var score_label = $RingScoreContainer/ScoreLabel

func show_return_to_start_message():
	Globals.can_return_to_start = true
	return_to_start.visible = true
	
func hide_return_to_start_message():
	Globals.can_return_to_start = false
	return_to_start.visible = false
	
func update_ring_score():
	score_label.text = str(Globals.ring_score)
