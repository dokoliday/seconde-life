extends Node2D

@onready var camera = $Player/Camera2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	camera.zoom = Vector2(2, 2)
	camera.limit_left = 0
	camera.limit_right=1600
	camera.limit_bottom=870
	camera.limit_top=53
	player.speed = 40
