extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const GRAVITY = 2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$Sprite2D.flip_h = direction > 0
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
		var collision_rid = collision.get_collider_rid()
		if PhysicsServer2D.body_get_collision_layer(collision_rid) == Globals.GROUND_LAYER:
			UI.show_return_to_start_message()
