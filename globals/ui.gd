extends CanvasLayer

@onready var instruction_label = $InstructionLabelContainer/Label
@onready var score_label = $RingScoreContainer/ScoreLabel
var green: Color = Color("86CF78")
var orange: Color = Color("FBE7AB")
@onready var level_timer = $LevelTimerContainer

func _ready():
	hide_all_hud()
	hide_balance_bar()
	hide_phase_message()

func hide_all_hud():
	visible = false

func show_all_hud():
	visible = true
	
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
