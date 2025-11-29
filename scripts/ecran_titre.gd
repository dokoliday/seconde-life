extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animated_sprite_2d.scale=Vector2(0.5,0.5)
	animation_player.play("title")
