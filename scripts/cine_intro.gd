extends Node2D

#Objects and Characters
@onready var house_sprite: Sprite2D =  $Objects/House/Sprite2D
@onready var player: CharacterBody2D = $Characters/Player
@onready var death: CharacterBody2D = $Characters/Death

@onready var spriteplayer: AnimatedSprite2D =  $Characters/Player/AnimatedSprite2D
@onready var door: AnimatedSprite2D = $Objects/Door
@onready var letter_box: AnimatedSprite2D = $Objects/letter_box

@onready var letter: ColorRect = $Letter

#animation & camera
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cinematique_camera: Camera2D = $Cinematique_camera

#audio
@onready var audio_effects: AudioStreamPlayer2D = $Audio/audioEffects
@onready var music: AudioStreamPlayer2D = $Audio/music

	
var door_sound = preload("res://assets/sounds/open-door-1-14550.mp3")
var winter_house_texture = preload("res://assets/sheet/house-WINTER.png")
var music_theme = preload("res://assets/sounds/hebrew-nostalgia-385545.mp3")
var walk_sound = preload("res://assets/sounds/sand-walk-106366.mp3")

var player_anim: String = "stationary_front_winter"
var current_anim: String = ""


func _ready():
	house_sprite.texture = winter_house_texture
	
	cinematique_camera.zoom = Vector2(1.7, 1.7)
	cinematique_camera.limit_left = 0
	animation_player.play("camera")
	
	music_theme.loop = true
	walk_sound.loop = true
	music.stream = music_theme
	music.volume_db= -10
	music.play()

func _process(_delta: float) -> void:
	handle_anim()
	handle_input()

		
func handle_anim():
	if player_anim == 'pause':
		spriteplayer.pause()
	elif player_anim != current_anim:
		if not  player_anim.contains('walk'):
			audio_effects.stream = walk_sound
			audio_effects.play()
		if player_anim == 'walk_left_winter':
			spriteplayer.flip_h = true
			spriteplayer.play("walk_right_winter") 
		else:
			spriteplayer.flip_h = false
			spriteplayer.play(player_anim)  
			
func handle_input():
	if Input.is_action_pressed("action") and letter.visible == true :
		letter.visible = false
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
	
func start_shake() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	var initial_offset = cinematique_camera.offset
	for i in range(10):
		var random_offset = Vector2(
			randf_range(-1, 1) * 2,
			randf_range(-1, 1) * 2
		)
		tween.tween_property(cinematique_camera, "offset", random_offset, 0.05)
		tween.tween_property(cinematique_camera, "offset", initial_offset, 0.05)
		
	
func _on_letter_box_animation_finished() -> void:
	letter.visible = true
	death.visible = true
