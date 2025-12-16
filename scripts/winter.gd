extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Camera constants
const CAMERA_ZOOM = Vector2(2, 2)
const CAMERA_LIMIT_LEFT = 0
const CAMERA_LIMIT_RIGHT = 1600
const CAMERA_LIMIT_BOTTOM = 870
const CAMERA_LIMIT_TOP = 53
const WINTER_PLAYER_SPEED = 40

func _ready() -> void:
	camera.zoom = CAMERA_ZOOM
	camera.limit_left = CAMERA_LIMIT_LEFT
	camera.limit_right = CAMERA_LIMIT_RIGHT
	camera.limit_bottom = CAMERA_LIMIT_BOTTOM
	camera.limit_top = CAMERA_LIMIT_TOP
	player.speed = WINTER_PLAYER_SPEED

func _on_death_start_fight() -> void:
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/levels/combat.tscn")
