extends CanvasLayer

@onready var instruction_label = $InstructionLabelContainer/Label
@onready var score_label = $RingScoreContainer/ScoreLabel

func _ready():
	hide_all_hud()
	hide_phase_message()

func hide_all_hud():
	visible = false

func show_all_hud():
	visible = true
	
func show_balance_bar():
	$RopeBalanceBar.begin_balance()
	
func hide_balance_bar():
	$RopeBalanceBar.end_balance()

func show_phase_message():
	instruction_label.visible = true
	
func hide_phase_message():
	instruction_label.visible = false
	
func update_ring_score():
	score_label.text = str(Globals.ring_count) + "/" + str(Globals.ring_total)

func start_level_timer():
	$LevelTimerContainer.start()
	
func reset_level_timer():
	$LevelTimerContainer.reset()
	
func stop_level_timer():
	$LevelTimerContainer.stop()

func update_float_remaining(float_remaining: int):
	$FloatBarContainer/ProgressBar.value = float_remaining
