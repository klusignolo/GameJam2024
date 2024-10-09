extends Node2D

signal player_fired_away
var player_body
var is_firing := false
@onready var player_sprite = $Body/PlayerSprite

func _process(_delta: float) -> void:
	if player_body:
		player_body.global_position = player_sprite.global_position
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_firing: return
	is_firing = true
	print("rotating")
	print(body)
	player_body = body
	body.visible = false
	player_sprite.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(player_sprite, "position", Vector2(32, -94), 0.6)
	tween.chain().tween_property($Body, "rotation_degrees", 15.0, 0.8)
	tween.chain().tween_property($Body/Wick, "visible", true, 0.1)
	tween.chain().tween_property($Body/Wick, "position", Vector2(-37, -36), 1)
	tween.chain().tween_property($Body/Wick, "position", Vector2(-39, -35), .25)
	tween.play()
	await tween.finished
	player_sprite.reparent($Body/Path2D/PathFollow2D)
	var new_tween = get_tree().create_tween()
	new_tween.tween_property($Body/Path2D/PathFollow2D, "progress_ratio", 1.0, .5)
	new_tween.play()
	await new_tween.finished
	player_fired_away.emit()
