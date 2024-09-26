extends Node2D

var platform_width = 1280
@export var camera: Camera2D
@export var platform_a: StaticBody2D
@export var platform_b: StaticBody2D
var current_floor: StaticBody2D
var other_platform_on_left: bool = false

class PlatformRenderLayout:
	func _init(current_platform: StaticBody2D, other_platform: StaticBody2D, is_to_left: bool):
		current_platform = current_platform
		other_platform = other_platform
		is_to_left = is_to_left

func _ready():
	current_floor = platform_a
	
func _process(_delta):
	var current_platform_info = which_platform_is_character_on()
	var current_platform: StaticBody2D = current_platform_info[0]
	var other_platform: StaticBody2D = current_platform_info[1]
	var is_on_left: bool = current_platform_info[2]
	current_floor = other_platform if current_platform != current_floor else current_platform
	if is_on_left != other_platform_on_left:
		other_platform_on_left = is_on_left
		move_platform(other_platform, is_on_left)

func which_platform_is_character_on():
	# Take camera's current x position and divide by screen width. If an even number, it's platform_a
	var ratio = camera.global_position.x / Globals.screen_size.x
	var is_platform_a = int(ratio) % 2 == 0
	var current_platform = platform_a if is_platform_a else platform_b
	var other_platform = platform_a if not is_platform_a else platform_b
	var is_left = abs(ratio - int(ratio)) < 0.5
	return [current_platform, other_platform, is_left]

func is_off_screen(platform: StaticBody2D) -> bool:
	var camera_view_left = camera.global_position.x - (camera.get_viewport_rect().size.x / 2)
	return platform.global_position.x + platform_width < camera_view_left
	
func move_platform(platform: StaticBody2D, is_on_left: bool):
	var other_platform = platform_b if platform == platform_a else platform_a
	if is_on_left:
		platform.global_position.x = other_platform.global_position.x - platform_width
	else:
		platform.global_position.x = other_platform.global_position.x + platform_width
