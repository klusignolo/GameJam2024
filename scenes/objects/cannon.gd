extends Node2D

signal player_fired_away
var player_body
var is_firing := false
@export var can_fire := false
@onready var player_sprite = $Body/PlayerSprite
@onready var sfx_cannon = $sfx_cannon

func _process(_delta: float) -> void:
	if player_body:
		player_body.global_position = player_sprite.global_position
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_firing or not can_fire: return
	is_firing = true
	sfx_cannon.play()
	player_body = body
	player_body.visible = false
	player_sprite.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	$sfx_cannon.play()
	# Scoot the sprite into the cannon
	tween.tween_property(player_sprite, "position", Vector2(32, -94), 0.6)
	# Rotate cannon
	tween.chain().tween_property($Body, "rotation_degrees", 15.0, 0.8)
	# Animate the wick
	tween.chain().tween_property($Body/Wick, "visible", true, 0.1)
	tween.chain().tween_property($Body/Wick, "position", Vector2(-37, -36), 1)
	tween.chain().tween_property($Body/Wick, "position", Vector2(-39, -35), .25)
	tween.play()
	await tween.finished
	$Body/Wick.visible = false
	# Make sprite belong to the cannon projectile path
	player_sprite.reparent($Body/Path2D/PathFollow2D)
	var new_tween = get_tree().create_tween()
	# Move the sprite along the projectile path
	new_tween.tween_property($Body/Path2D/PathFollow2D, "progress_ratio", 1.0, .5)
	new_tween.play()
	await new_tween.finished
	# Signal end of cannon animation
	player_fired_away.emit()
