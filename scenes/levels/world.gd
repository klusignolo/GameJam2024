class_name WorldParent
extends Node2D

@onready var tilemap = $LevelTileMap
var player_is_at_start := true
func _ready() -> void:
	send_player_to_start()

func _process(_delta: float) -> void:
	$Camera.position.x = $Player.position.x
	$AudioStreamPlayer2D.position = $Player.position
	
	if $Player.position.distance_to($StartingPosition.position) > 50 and player_is_at_start:
		UI.start_level_timer()
	if $Player.position.distance_to($EndingPosition.position) < 50:
		UI.stop_level_timer()
		
	set_player_near_tile_properties()
	
	
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
	$Player.position = $StartingPosition.position
	for ring in get_tree().get_nodes_in_group("Ring"):
		ring.reset()
	Globals.ring_count = 0
	Globals.float_remaining = 100
	UI.stop_level_timer()
	UI.reset_level_timer()
	player_is_at_start = true


func _on_player_fell_down() -> void:
	send_player_to_start()
