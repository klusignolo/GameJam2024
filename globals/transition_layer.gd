extends CanvasLayer

func _ready():
	$AnimationPlayer.play_backwards("fade_to_black")
	await $AnimationPlayer.animation_finished
	visible = false
	
func change_scene(target: String) -> void:
	visible = true
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	UI.hide_all_hud()
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade_to_black")
	await $AnimationPlayer.animation_finished
	visible = false
