extends Node2D

var platform_width = 1280
@export var camera: Camera2D
@export var platform_a: StaticBody2D
@export var platform_b: StaticBody2D

func _ready():
	platform_a.global_position.x = 0
	platform_b.global_position.x = platform_width
	
func _process(delta):
	if is_off_screen(platform_a):
		print("platform went off screen")
		recycle_platform(platform_a)
	elif is_off_screen(platform_b):
		print("platform went off screen")
		recycle_platform(platform_b)
		
func is_off_screen(platform: StaticBody2D) -> bool:
	var camera_view_left = camera.global_position.x - (camera.get_viewport_rect().size.x / 2)
	return platform.global_position.x + platform_width < camera_view_left
	
func recycle_platform(platform: StaticBody2D):
	var other_platform = platform_b if platform == platform_a else platform_a
	print("recycling")
	
	platform.global_position.x = other_platform.global_position.x + platform_width
