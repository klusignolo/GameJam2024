extends Node2D

@export var color: Color:
	set(value):
		color = value
		$PointLight2D.color = color

func _ready():
	$Sprite2D.visible = false
