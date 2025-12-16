extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var orange_door: AnimatedSprite2D = $OrangeDoor/Area2D/AnimatedSprite2D
@onready var blue_door: AnimatedSprite2D = $BlueDoor/Area2D/AnimatedSprite2D
@onready var green_door: AnimatedSprite2D = $GreenDoor/Area2D/AnimatedSprite2D
@onready var yellow_door: AnimatedSprite2D = $YellowDoor/Area2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Camera constants
const CAMERA_ZOOM = Vector2(2, 2)
const CAMERA_LIMIT_LEFT = 0
const CAMERA_LIMIT_RIGHT = 1600
const CAMERA_LIMIT_BOTTOM = 870
const CAMERA_LIMIT_TOP = 53

var door_opened: String = ""

func setup_door(door: AnimatedSprite2D, animation_name: String) -> void:
	door.play(animation_name)
	door.stop()
	door.frame = 0

func _ready() -> void:
	camera.zoom = CAMERA_ZOOM
	camera.limit_left = CAMERA_LIMIT_LEFT
	camera.limit_right = CAMERA_LIMIT_RIGHT
	camera.limit_bottom = CAMERA_LIMIT_BOTTOM
	camera.limit_top = CAMERA_LIMIT_TOP

	setup_door(orange_door, "open_orange")
	setup_door(blue_door, "open_blue")
	setup_door(green_door, "open_green")
	setup_door(yellow_door, "open_yellow")
	
func _on_orange_door_open_hub_door(in_area: bool) -> void:
	if in_area:
		orange_door.play("open_orange")
		door_opened = "orange"
		animation_player.play("fade_out")
	else:
		orange_door.play("close_orange")

func _on_blue_door_open_hub_door(in_area: bool) -> void:
	if in_area:
		blue_door.play("open_blue")
		door_opened = "blue"
		animation_player.play("fade_out")
	else:
		blue_door.play("close_blue")

func _on_green_door_open_hub_door(in_area: bool) -> void:
	if in_area:
		green_door.play("open_green")
	else:
		green_door.play("close_green")

func _on_yellow_door_open_hub_door(in_area: bool) -> void:
	if in_area:
		yellow_door.play("open_yellow")
	else:
		yellow_door.play("close_yellow")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		match door_opened:
			"orange":
				get_tree().change_scene_to_file("res://scenes/levels/spring.tscn")
			"blue":
				get_tree().change_scene_to_file("res://scenes/levels/winter.tscn")
