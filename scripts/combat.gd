extends Node2D
@onready var death: AnimatedSprite2D = $Ennemy/Death
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	death.flip_h = true

var shake_intensity = 12.0
var shake_duration = 0.2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		start_shake()

func start_shake():
	var tween = create_tween()
	
	for i in range(10):
		var random_offset = Vector2(
			randf_range(-1, 1) * shake_intensity,
			randf_range(-1, 1) * shake_intensity
			)
		tween.tween_property(camera_2d, "offset", random_offset, shake_duration / 20)
		tween.tween_property(camera_2d, "offset", Vector2.ZERO, shake_duration / 5)
