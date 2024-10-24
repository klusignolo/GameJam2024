extends CanvasLayer

@onready var instruction_label = $InstructionLabelContainer/Label
@onready var score_label = $RingScoreContainer/ScoreLabel
@onready var submit_score_edit: LineEdit = $HighScoreSubmissionControl/HighScoreEdit
var green: Color = Color("86CF78")
var orange: Color = Color("FBE7AB")
@onready var level_timer = $LevelTimerContainer
var score_submission_level = 0
var score_submission_time = 0

func _ready():
	hide_all_hud()
	hide_balance_bar()
	hide_phase_message()
	Leaderboard.configure_silentwolf()

func hide_all_hud():
	$InstructionLabelContainer.visible = false
	$RingScoreContainer.visible = false
	$LevelNameControl.visible = false
	$LevelTimerContainer.visible = false
	$FloatBarContainer.visible = false
	$RopeBalanceBar.visible = false
	if Globals.is_submitting_score:
		$LevelTimerContainer.visible = true

func show_all_hud():
	$InstructionLabelContainer.visible = true
	$RingScoreContainer.visible = true
	$LevelNameControl.visible = true
	$LevelTimerContainer.visible = true
	$FloatBarContainer.visible = true
	$RopeBalanceBar.visible = true
	
func show_balance_bar():
	$RopeBalanceBar.begin_balance()
	
func hide_balance_bar():
	$RopeBalanceBar.visible = false
	$RopeBalanceBar.end_balance()

func show_phase_message():
	instruction_label.visible = true
	
func hide_phase_message():
	instruction_label.visible = false
	
func update_ring_score():
	var rings_finished = Globals.ring_count == Globals.ring_total
	score_label.modulate = green if rings_finished else orange
	score_label.text = str(Globals.ring_count) + "/" + str(Globals.ring_total)

func start_level_timer():
	$LevelTimerContainer.start()
	
func reset_level_timer():
	$LevelTimerContainer.reset()
	
func stop_level_timer():
	$LevelTimerContainer.stop()
	
func blink_level_timer():
	$AnimationPlayer.play("blink_level_timer")
	
func update_level_label():
	$LevelNameControl/LevelLabel.text = "Level: " + str(Globals.selected_level)

func update_float_remaining(float_remaining: float):
	$FloatBarContainer/ProgressBar.value = float_remaining
	
var current_level_time: int:
	get:
		return 	$LevelTimerContainer.time

func show_high_score_submission():
	$HighScoreSubmissionControl.visible = true
	await get_tree().process_frame
	$HighScoreSubmissionControl/HighScoreEdit.grab_focus()
	score_submission_level = Globals.selected_level
	score_submission_time = int($LevelTimerContainer.time * 1000.0)
	Globals.is_submitting_score = true
	
func hide_high_score_submission():
	$HighScoreSubmissionControl.visible = false
	$LevelTimerContainer.visible = false
	Globals.is_submitting_score = false

func _on_high_score_edit_text_submitted(new_text: String) -> void:
	var is_valid = true
	if new_text == "": is_valid = false
	if is_valid:
		Leaderboard.add_score(new_text, score_submission_time, score_submission_level)
		hide_high_score_submission()
