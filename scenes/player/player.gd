extends CharacterBody2D

var speed = 350.0
const JUMP_VELOCITY = -650.0
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
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		var collision_rid = collision.get_collider_rid()
		var collition_layer_id = PhysicsServer2D.body_get_collision_layer(collision_rid)
		if collition_layer_id == Globals.GROUND_LAYER_ID:
			UI.show_return_to_start_message()
		elif collition_layer_id == Globals.ROPE_LAYER_ID:
			speed = 100.0
		else:
			speed = 350.0
			
