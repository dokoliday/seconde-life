extends Node2D
@onready var camera = $Player/Camera2D
@onready var orange_door: AnimatedSprite2D = $OrangeDoor/Area2D/AnimatedSprite2D
@onready var blue_door: AnimatedSprite2D = $BlueDoor/Area2D/AnimatedSprite2D
@onready var green_door: AnimatedSprite2D = $GreenDoor/Area2D/AnimatedSprite2D
@onready var yellow_door: AnimatedSprite2D = $YellowDoor/Area2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func setup_door(door: AnimatedSprite2D, animation_name: String) -> void:
	door.play(animation_name)
	door.stop()
	door.frame = 0
	
func _ready() -> void:
	camera.zoom = Vector2(2, 2)
	camera.limit_left = 0
	camera.limit_right=1600
	camera.limit_bottom=870
	camera.limit_top=53

	setup_door(orange_door, "open_orange")
	setup_door(blue_door, "open_blue")
	setup_door(green_door, "open_green")
	setup_door(yellow_door, "open_yellow")
	
func _on_orange_door_open_hub_door(inArea:bool) -> void:
	if inArea:
		orange_door.play("open_orange")
		animation_player.play("fade_out")
	else:
		orange_door.play("close_orange")
func _on_blue_door_open_hub_door(inArea:bool) -> void:
	if inArea:
		blue_door.play("open_blue")
	else:
		blue_door.play("close_blue")
func _on_green_door_open_hub_door(inArea:bool) -> void:
	if inArea:
		green_door.play("open_green")
	else:
		green_door.play("close_green")
func _on_yellow_door_open_hub_door(inArea:bool) -> void:
	if inArea:
		yellow_door.play("open_yellow")
	else:
		yellow_door.play("close_yellow")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scenes/levels/spring.tscn")
		
		
