extends Node

var can_return_to_start := false
var screen_size: Vector2 = Vector2(1280, 720)
const OBJECTS_LAYER_ID := 4
const GROUND_LAYER_ID := 4
const ROPE_LAYER_ID := 8
const WALL_LAYER_ID := 16
var player_lost_balance = false
var player_is_on_floor := true:
	set(value):
		if player_is_on_floor != value:
			player_is_on_floor = value
			if player_is_on_floor:
				regenerate_float()

var ring_count := 0:
	set(value):
		ring_count = value
		UI.update_ring_score()
var ring_total := 0
var collected_all_rings: bool = false:
	get:
		return ring_count == ring_total
		
var float_remaining: int = 100:
	set(value):
		if float_remaining != value:
			float_remaining = value
			UI.update_float_remaining(float_remaining)
			regenerate_float

func regenerate_float():
	if player_is_on_floor:
		await get_tree().create_timer(.1).timeout
		if float_remaining < 100:
			float_remaining += 1
			regenerate_float()
			
