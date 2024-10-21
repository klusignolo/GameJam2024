extends Control

var is_player_outside := false

func _ready():
	$AnimationPlayer.play("instructions_fade")
	SilentWolf.configure({
		"api_key": "zUsuLiZVRa7nnSzXzCWeF2IlrBfR3PaV8izxcbKt",
		"game_id": "three ring circus",
		"game_version": "1.0.0",
		"log_level": 0
	})

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
	$MenuButtonsContainer/MainMenuContainer/LevelButton.text = "Choose Level: " + str(Globals.selected_level)

func _on_back_button_button_up() -> void:
	$MenuButtonsContainer/MainMenuContainer.visible = true
	$MenuButtonsContainer/ControlsContainer.visible = false
	$MenuButtonsContainer/VolumeContainer.visible = false
	$MenuButtonsContainer/LeaderboardContainer.visible = false

func _on_controls_button_button_up() -> void:
	$MenuButtonsContainer/ControlsContainer.visible = true
	$MenuButtonsContainer/MainMenuContainer.visible = false

func _on_audio_button_button_up() -> void:
	$MenuButtonsContainer/MainMenuContainer.visible = false
	$MenuButtonsContainer/VolumeContainer.visible = true

func _on_leaderboard_button_button_up() -> void:
	$MenuButtonsContainer/LeaderboardContainer/Leaderboard.load_high_scores()
	$MenuButtonsContainer/MainMenuContainer.visible = false
	$MenuButtonsContainer/LeaderboardContainer.visible = true
