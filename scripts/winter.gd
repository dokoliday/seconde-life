extends Node2D

@onready var camera = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	camera.zoom = Vector2(2, 2)
	camera.limit_left = 0
	camera.limit_right=1600
	camera.limit_bottom=870
	camera.limit_top=53
	player.speed = 40

func _on_death_start_fight() -> void:
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/levels/combat.tscn"
	)
