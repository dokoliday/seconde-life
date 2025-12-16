extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $TextureButton/Label
@onready var texture_button: TextureButton = $TextureButton
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var title_anim: AnimatedSprite2D = $title_anim
@onready var dance_anim: AnimatedSprite2D = $dance_anim
@onready var color_rect_2: ColorRect = $ColorRect2

var letter_sound
var button_sound
var ambiance_sound

func _ready() -> void:
	title_anim.scale=Vector2(0.5,0.5)
	animation_player.play("title")
	letter_sound = preload("res://assets/sounds/letters_splash_screen.wav")
	ambiance_sound = preload("res://assets/sounds/sacred-chant-spiritual-religious-choir-394914.mp3")
	button_sound = preload("res://assets/sounds/metal-hit-sound-effect-241374.mp3")
	
	label.add_theme_font_override("font", load("res://assets/fonts/Valorant_Font.ttf"))
	label.add_theme_color_override("font_color", Color(1, 1, 1))  # Blanc
	label.text = "COMMENCER"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"title":
			texture_button.visible = true
			dance_anim.visible = true
			dance_anim.play('init')
		"fade_out":
			get_tree().change_scene_to_file("res://scenes/cinématiques/cine_intro.tscn"
			)
	
func _on_texture_button_button_up() -> void:
	audio_stream_player_2d.stream = button_sound
	audio_stream_player_2d.play()
	color_rect_2.visible = true
	animation_player.play("fade_out")

func _on_animated_sprite_2d_frame_changed() -> void:
	if audio_stream_player_2d and title_anim.frame < 8:
		audio_stream_player_2d.play()
	elif audio_stream_player_2d and title_anim.frame >= 8:
		ambiance_sound.loop = true
		audio_stream_player_2d.stream = ambiance_sound
		audio_stream_player_2d.volume_db= -80
		audio_stream_player_2d.play()
		var tween = create_tween()
		tween.tween_property(audio_stream_player_2d,'volume_db',-10 ,4)

func _on_dance_anim_animation_finished() -> void:
	if dance_anim.animation == "init":
		dance_anim.play("loop")
	
	


func _on_title_anim_animation_finished() -> void:
	pass # Replace with function body.
