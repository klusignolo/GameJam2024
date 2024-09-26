extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	UI.show_return_to_start_message()
