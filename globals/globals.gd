extends Node

var can_return_to_start := false
var screen_size: Vector2 = Vector2(1280, 720)
var GROUND_LAYER := 4
var ring_score: int = 0:
	set(value):
		ring_score = value
		UI.update_ring_score()
