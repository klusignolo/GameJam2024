extends Control

var is_balancing := false
const BASE_BALANCE = 500
const FALL_LIMIT = 100
var balance = BASE_BALANCE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_balancing:
		var drift_amount = balance - BASE_BALANCE
		var player_fell = BASE_BALANCE - abs(drift_amount) <= FALL_LIMIT
		if player_fell:
			Globals.player_lost_balance = true
			end_balance()
			await get_tree().create_timer(1.0).timeout
			Globals.player_lost_balance = false
			return
			
		var v = abs(drift_amount) * delta
		var min_v = 50 * delta
		var max_v = 200 * delta
		var move_velocity = max_v if v > max_v else min_v if v < min_v else v
		var is_moving_left = drift_amount <= 0
		var is_pressing_up = Input.is_action_pressed("up")
		var is_pressing_down = Input.is_action_pressed("down")
		if is_pressing_down or is_pressing_up:
			var balance_velocity = 200 * delta
			if is_pressing_down:
				balance -= balance_velocity
			else:
				balance += balance_velocity
		elif is_moving_left:
			balance -= move_velocity
		else:
			balance += move_velocity
		$HScrollBar.value = balance
	
func begin_balance():
	if not is_balancing:
		Globals.player_lost_balance = false
		visible = true
		is_balancing = true

func end_balance():
	if is_balancing:
		visible = false
		reset_bar()
		
func reset_bar():
	is_balancing = false
	balance = BASE_BALANCE
	
