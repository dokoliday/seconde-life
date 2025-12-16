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
@onready var walk_audio: AudioStreamPlayer2D = $Audio/walk_sound

#dialog
@onready var dialogs: CanvasLayer = $Dialogs

	
var door_sound = preload("res://assets/sounds/open-door-1-14550.mp3")
var winter_house_texture = preload("res://assets/sheet/house-WINTER.png")
var music_theme = preload("res://assets/sounds/hebrew-nostalgia-385545.mp3")
var walk_sound = preload("res://assets/sounds/sand-walk-106366.mp3")
var letter_sound = preload("res://assets/sounds/321108__nsstudios__page-turn.wav")

var player_anim: String = "stationary_front_winter"
var current_anim: String = ""

func _ready():
	house_sprite.texture = winter_house_texture
	cinematique_camera.zoom = Vector2(1.7, 1.7)
	cinematique_camera.limit_left = 0
	animation_player.play("camera")
	
	# Set loop on the stream after assigning it to the player
	music.stream = music_theme
	if music_theme:
		music_theme.loop = true
	if walk_sound:
		walk_sound.loop = true
	music.play()
	
	dialogs.button.pressed.connect(on_next_dialog)
	dialogs.dialog_end.connect(fadeOut)
	dialogs.display_dialog("res://Json/dialogs/cinematiques/intro.json")
	
func _process(_delta: float) -> void:
	handle_anim()
	handle_input()
	
func handle_anim() -> void:
	var is_walking = player_anim.contains("walk")
	
	if not is_walking:
		walk_audio.stop()
	
	# Only play if not already playing
	if not walk_audio.playing:
		walk_audio.volume_db = 20
		walk_audio.stream = walk_sound
		walk_audio.play()
	
	if player_anim == 'pause':
		spriteplayer.pause()
	elif player_anim != current_anim:
		if player_anim == 'walk_left_winter':
			spriteplayer.flip_h = true
			spriteplayer.play("walk_right_winter") 
		else:
			spriteplayer.flip_h = false
			spriteplayer.play(player_anim)  
			
func handle_input() -> void:
	if Input.is_action_just_pressed("action") and letter.visible:
		letter.visible = false
		show_dialog()

func open_door() -> void:
	audio_effects.stream = door_sound
	audio_effects.play()
	door.play("open")

func _on_door_animation_finished() -> void:
	show_dialog()

func play_player_anim(anim: String) -> void:
	player_anim = anim

func take_letter() -> void:
	animation_player.pause()
	letter_box.play()

func start_shake() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	var initial_offset = cinematique_camera.offset
	const SHAKE_INTENSITY = 2.0
	const SHAKE_ITERATIONS = 10
	const SHAKE_DURATION = 0.05
	
	for i in range(SHAKE_ITERATIONS):
		var random_offset = Vector2(
			randf_range(-1, 1) * SHAKE_INTENSITY,
			randf_range(-1, 1) * SHAKE_INTENSITY
		)
		tween.tween_property(cinematique_camera, "offset", random_offset, SHAKE_DURATION)
		tween.tween_property(cinematique_camera, "offset", initial_offset, SHAKE_DURATION)
	
	show_dialog()

func _on_letter_box_animation_finished() -> void:
	audio_effects.stream = letter_sound
	audio_effects.play()
	letter.visible = true
	death.visible = true

func on_next_dialog() -> void:
	if not dialogs.get_is_current_dialog_displayed_value():
		return
	
	var dialog_index = dialogs.get_dialog_index()
	if dialog_index in [1, 2, 4]:
		dialogs.hide_dialog(true)
		if dialog_index == 2:
			play_player_anim("walk_right_winter")
		animation_player.play()

func show_dialog() -> void:
	play_player_anim("pause")
	animation_player.pause()
	audio_effects.stop()
	dialogs.hide_dialog(false)

func fadeOut() -> void:
	animation_player.play("fadeOut")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeOut":
		get_tree().change_scene_to_file("res://scenes/levels/combat.tscn")
