extends Node

var can_return_to_start := false
var screen_size: Vector2 = Vector2(1280, 720)
const OBJECTS_LAYER_ID := 4
const GROUND_LAYER_ID := 4
const ROPE_LAYER_ID := 8
const WALL_LAYER_ID := 16

var selected_level := 1:
	set(value):
		print("Updating to " + str(value))
		selected_level = value
		UI.update_level_label()
		
var level_scenes = {
	1: "res://scenes/levels/level_one.tscn",
	2: "res://scenes/levels/level_two.tscn",
	3: "res://scenes/levels/level_three.tscn"
}
var high_scores = {
	1: null,
	2: null,
	3: null
}
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
		
var float_remaining: float = 100.0:
	set(value):
		if float_remaining != value:
			float_remaining = value
			UI.update_float_remaining(float_remaining)

func regenerate_float():
	while player_is_on_floor and float_remaining < 100:
		float_remaining += 1
		await get_tree().create_timer(.05).timeout
			
