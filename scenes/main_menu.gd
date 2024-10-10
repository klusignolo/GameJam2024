extends Control

var is_player_outside := false

func _process(_delta: float):
	if is_player_outside:
		$Camera2D.position.x = $Player.position.x - 640

func start_level():
	var selected_scene: String = Globals.level_scenes[Globals.selected_level]
	TransitionLayer.change_scene(selected_scene)


func _on_cannon_player_fired_away() -> void:
	start_level()

func _on_level_button_button_up() -> void:
	var level_count = len(Globals.level_scenes)
	if Globals.selected_level == level_count:
		Globals.selected_level = 1
	else:
		Globals.selected_level += 1
	$VBoxContainer/VBoxContainer/LevelButton.text = "Choose Level: " + str(Globals.selected_level)
