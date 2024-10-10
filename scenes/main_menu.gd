extends Control

var is_player_outside := false
var selected_level = 1

func _process(_delta: float):
	if is_player_outside:
		$Camera2D.position.x = $Player.position.x - 640

func start_level():
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_cannon_player_fired_away() -> void:
	start_level()


func _on_level_button_button_up() -> void:
	selected_level += 1
	$VBoxContainer/VBoxContainer/LevelButton.text = "Choose Level: " + str(selected_level)
