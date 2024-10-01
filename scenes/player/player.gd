extends CharacterBody2D

const BASE_SPEED = 250.0
const SLOW_SPEED = 100.0
var speed = BASE_SPEED
const JUMP_VELOCITY = -650.0
const FLOAT_VELOCITY = 50
const FLOAT_GRAVITY = .5
const NORMAL_GRAVITY = 2
var gravity = 2
var can_lose_float = true
var can_jump := true
signal fell_down

func _physics_process(delta: float) -> void:
	# Fall through ropes if falling
	set_collision_mask_value(4, not Globals.player_lost_balance)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity
		Globals.player_is_on_floor = false
	else:
		Globals.player_is_on_floor = true
		
	if Input.is_action_just_pressed("phase"):
		$Sprite2D.self_modulate.a = 0.5
		set_collision_mask_value(5, false)
	elif Input.is_action_just_released("phase"):
		$Sprite2D.self_modulate.a = 1.0
		set_collision_mask_value(5, true)

	# Handle jump.
	if Input.is_action_just_pressed("jump_float") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("jump_float") and not is_on_floor() and velocity.y > 0:
		if Globals.float_remaining > 0:
			velocity.y = FLOAT_VELOCITY
			gravity = FLOAT_GRAVITY
			Globals.float_remaining -= 15 * delta
		else:
			gravity = NORMAL_GRAVITY
	else:
		gravity = NORMAL_GRAVITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$Sprite2D.flip_h = direction > 0
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		can_jump = true
		speed = BASE_SPEED
		var collision_rid = collision.get_collider_rid()
		var collition_layer_id = PhysicsServer2D.body_get_collision_layer(collision_rid)
		var is_on_rope = collition_layer_id == Globals.ROPE_LAYER_ID
		var is_on_ground = collition_layer_id == Globals.GROUND_LAYER_ID
		var is_touching_wall = collition_layer_id == Globals.WALL_LAYER_ID
		var is_touching_object = collition_layer_id == Globals.OBJECTS_LAYER_ID

		if is_on_ground:
			fell_down.emit()
		if is_on_rope:
			UI.show_balance_bar()
			can_jump = false
			speed = SLOW_SPEED
		else:
			UI.hide_balance_bar()
		if is_touching_wall:
			UI.show_phase_message()
		else:
			UI.hide_phase_message()
		if is_touching_object:
			pass
