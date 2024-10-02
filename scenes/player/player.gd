extends CharacterBody2D

const BASE_SPEED = 250.0
const SLOW_SPEED = 100.0
var speed = BASE_SPEED
const JUMP_VELOCITY = -650.0
const BIG_JUMP_VELOCITY = -850.0
const FLOAT_VELOCITY = 50
const FLOAT_GRAVITY = .5
const NORMAL_GRAVITY = 2
var gravity = 2
var can_lose_float = true
var can_jump := true
var is_floating := false
signal fell_down

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var is_on_rope := false:
	set(value):
		if value != is_on_rope:
			is_on_rope = value
			if is_on_rope:
				UI.show_balance_bar()
				can_jump = false
				speed = SLOW_SPEED
			else:
				can_jump = true
				speed = BASE_SPEED
				UI.hide_balance_bar()
var is_touching_wall := false:
	set(value):
		if value != is_touching_wall:
			is_touching_wall = value
			if is_touching_wall and not Input.is_action_pressed("phase"):
				UI.show_phase_message()
			else:
				UI.hide_phase_message()

func _physics_process(delta: float) -> void:
	# Fall through ropes if falling
	set_collision_mask_value(3, not Globals.player_lost_balance)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity
		Globals.player_is_on_floor = false
	else:
		Globals.player_is_on_floor = true
		
	if Input.is_action_just_pressed("phase"):
		$Sprite2D.self_modulate.a = 0.5
		set_collision_mask_value(4, false)
	elif Input.is_action_just_released("phase"):
		$Sprite2D.self_modulate.a = 1.0
		set_collision_mask_value(4, true)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_jump:
		if Input.is_action_pressed("down"):
			velocity.y = BIG_JUMP_VELOCITY
		else:
			velocity.y += JUMP_VELOCITY
			
			
		
	# Check if jump is pressed and also falling down. If so, float.
	if Input.is_action_pressed("jump") and not is_on_floor() and velocity.y > 0:
		if Globals.float_remaining > 0:
			is_floating = true
			velocity.y = FLOAT_VELOCITY
			gravity = FLOAT_GRAVITY
			Globals.float_remaining -= 15 * delta
		else:
			is_floating = false
			gravity = NORMAL_GRAVITY
	else:
		is_floating = false
		gravity = NORMAL_GRAVITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$Sprite2D.flip_h = direction < 0
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	set_animation()
	move_and_slide()

func set_animation():
	if not is_on_floor():
		if velocity.y < 0:
			animation_player.play("jump")
		else:
			animation_player.play("moving")
	else:
		if is_on_rope or Input.is_action_pressed("down"):
			animation_player.play("squish")
		else:
			if velocity.x != 0:
				animation_player.play("moving")
			else:
				animation_player.play("bobbing_idle")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	fell_down.emit()
