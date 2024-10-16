extends Node2D

@onready var tilemap = $LevelTileMap
var player_is_at_start := false

func _ready() -> void:
	UI.show_all_hud()
	UI.reset_level_timer()
	$Player.visible = false
	fly_player_in_from_left()
	var rings = get_tree().get_nodes_in_group("Ring")
	Globals.ring_total = len(rings)
	UI.update_ring_score()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		UI.hide_all_hud()
		Globals.ring_total = 0
		TransitionLayer.change_scene("res://scenes/main_menu.tscn")
		
	$Camera.position.x = min($Markers/EndingPosition.position.x - 200, $Player.position.x)
	
	if $Player.position.distance_to($Markers/StartingPosition.position) > 50 and player_is_at_start:
		UI.start_level_timer()
		player_is_at_start = false
	if $Player.position.distance_to($Markers/EndingPosition.position) < 50 and Globals.collected_all_rings:
		_on_reached_finish_line()
		
	set_player_near_tile_properties()
	

func _on_reached_finish_line():
	UI.stop_level_timer()
	UI.blink_level_timer()
	Globals.high_scores[Globals.selected_level] = UI.level_timer.get_time_formatted()
	$Cannon.can_fire = true
	
	
func set_player_near_tile_properties():
	var down_position = tilemap.local_to_map($Player.global_position + Vector2(0, 32))
	var left_position = tilemap.local_to_map($Player.global_position - Vector2(20, 0))
	var right_position = tilemap.local_to_map($Player.global_position + Vector2(20, 0))
	var tile_down: TileData = tilemap.get_cell_tile_data(down_position)
	var tile_left: TileData = tilemap.get_cell_tile_data(left_position)
	var tile_right: TileData = tilemap.get_cell_tile_data(right_position)
	if tile_down:
		$Player.is_on_rope = tile_down.get_custom_data("is_rope")
	else:
		$Player.is_on_rope = false
	if tile_left:
		$Player.is_touching_wall = tile_left.get_custom_data("is_wall")
	if tile_right:
		$Player.is_touching_wall = tile_right.get_custom_data("is_wall")
	if not tile_left and not tile_right:
		$Player.is_touching_wall = false

func send_player_to_start():
	$Player.position = $Markers/StartingPosition.position
	for ring in get_tree().get_nodes_in_group("Ring"):
		ring.reset()
	Globals.ring_count = 0
	Globals.float_remaining = 100
	UI.stop_level_timer()
	UI.reset_level_timer()
	player_is_at_start = true


func _on_player_fell_down() -> void:
	send_player_to_start()

func fly_player_in_from_left():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($FlyInPath/PathFollow2D, "progress_ratio", 1, .6)
	tween.tween_property($FlyInPath/PathFollow2D/Sprite2D, "rotation_degrees", -35, .5)
	tween.play()
	await tween.finished
	
	$FlyInPath/PathFollow2D/Sprite2D.visible = false
	$Player.visible = true
	player_is_at_start = true


func _on_cannon_player_fired_away() -> void:
	transition_to_next_level()
	
func transition_to_next_level():
	var level_count = len(Globals.level_scenes)
	var destination_scene = "res://scenes/main_menu.tscn"
	if Globals.selected_level == level_count:
		Globals.selected_level = 1
	else:
		Globals.selected_level += 1
		destination_scene = Globals.level_scenes[Globals.selected_level]
	TransitionLayer.change_scene(destination_scene)
