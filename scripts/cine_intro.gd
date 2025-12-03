extends Node2D

@onready var house_sprite: Sprite2D = $House/Sprite2D
@onready var player: CharacterBody2D = $Player
@onready var spriteplayer: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var door: AnimatedSprite2D = $Door
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d_2: Camera2D = $Camera2D2
@onready var letter_box: AnimatedSprite2D = $letter_box
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var death: CharacterBody2D = $Death
@onready var audio_effects: AudioStreamPlayer2D = $audioEffects
@onready var music: AudioStreamPlayer2D = $music

	
var door_sound = preload("res://assets/sounds/open-door-1-14550.mp3")

var winter_house_texture = preload("res://assets/sheet/house-WINTER.png")


var player_anim: String = "stationary_front_winter"
var current_anim: String = ""

func _ready():
	var music_theme = preload("res://assets/sounds/hebrew-nostalgia-385545.mp3")
	music_theme.loop = true
	house_sprite.texture = winter_house_texture
	camera_2d_2.zoom = Vector2(1.7, 1.7)
	camera_2d_2.limit_left = 0
	music.stream = music_theme
	music.volume_db= -10
	music.play()
	animation_player.play("camera")

func _process(_delta: float) -> void:
	if player_anim == 'pause':
		spriteplayer.pause()
	elif player_anim != current_anim:
		if player_anim == 'walk_left_winter':
			spriteplayer.flip_h = true
			spriteplayer.play("walk_right_winter") 
		else:
			spriteplayer.flip_h = false
			spriteplayer.play(player_anim)  
			
	if Input.is_action_pressed("action") and color_rect_2.visible == true :
		color_rect_2.visible = false
		play_player_anim("walk_right_winter")
		animation_player.play()
	
func open_door():
	audio_effects.stream = door_sound
	audio_effects.play()
	door.play("open")

func play_player_anim(anim: String):
	player_anim = anim
		
func take_letter():
	animation_player.pause()
	letter_box.play()

func _on_letter_box_animation_finished() -> void:
	color_rect_2.visible = true
	death.visible = true
	
func start_shake():
	var tween = create_tween()
	
	for i in range(10):
		var random_offset = Vector2(
			randf_range(-1, 1) * 2,
			randf_range(-1, 1) * 2
			
			)
		tween.tween_property(camera_2d_2, "offset", random_offset, 0.2 / 20)
		tween.tween_property(camera_2d_2, "offset", Vector2.ZERO, 0.2 / 5)
		
	
