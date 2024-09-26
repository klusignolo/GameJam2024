extends CanvasLayer

func show_return_to_start_message():
	Globals.can_return_to_start = true
	$ReturnToStartLabel.visible = true
	
func hide_return_to_start_message():
	Globals.can_return_to_start = false
	$ReturnToStartLabel.visible = false
