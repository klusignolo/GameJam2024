extends CanvasLayer

func _ready():
	$AnimationPlayer.play_backwards("fade_to_black")
	
func change_scene(target: String) -> void:
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade_to_black")
