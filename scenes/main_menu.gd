extends Control

var is_player_outside := false
var last_input_was_controller = false

func _input(event):
	if event is InputEventKey:
		last_input_was_controller = false
		update_ui_hint()
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_was_controller = true
		update_ui_hint()

func update_ui_hint():
	var phase_hint = "F" if !last_input_was_controller else "B"
	var move_hint = "left / right" if !last_input_was_controller else "left stick"
	var balance_hint = "up / down" if !last_input_was_controller else "right stick"
	var jump_hint = "spacebar" if !last_input_was_controller else "A"
	var crouch_hint = "right trigger"
	var text = "Move: %s\n" % move_hint
	text += "Rope Balance: %s\n" % balance_hint
	text += "Crouch: %s\n" % crouch_hint
	text += "Jump: %s\n" % jump_hint
	text += "Big Jump: crouch + jump\n"
	text += "Phase through walls: %s\n" % phase_hint
	text += "Float: Press %s while airborn" % jump_hint
	$MenuButtonsContainer/MainMenuContainer/ControlsContainer/Label.text = text
	
func _ready():
	$AnimationPlayer.play("instructions_fade")
	$MenuButtonsContainer/MainMenuContainer/LevelButton.grab_focus()
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
