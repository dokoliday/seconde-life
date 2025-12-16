extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var dialogs: CanvasLayer = $"."
@onready var button: Button = $Button
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var DIALOGS = {}
var index = 0
var display_char_length = 0
var current_full_text: String = ""
var dialog_visible: bool
var is_current_dialog_displayed: bool

var click_sound
var letter_sound
const display_text_speed = 0.05

signal dialog_started
signal dialog_end

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	timer.paused = true
	click_sound = preload("res://assets/sounds/686557__williamrbx__button_click.mp3")
	letter_sound = preload("res://assets/sounds/646124__voxlab__waldorf-m-bing-percussion.wav")

func _process(_delta: float) -> void:
	if dialog_visible and timer.paused:
		timer.paused = false
	
func display_dialog(path) -> void:
	dialog_started.emit()
	load_dialogs(path)
	afficher_dialogue()

func load_dialogs(path) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var res = json.parse(file.get_as_text())
		if res == OK:
			DIALOGS = json.data
		else:
			print("Erreur de parsing JSON : ", json.get_error_message())
		file.close()
	else:
		print("Erreur : Impossible d'ouvrir le fichier dialogs.json")

func afficher_dialogue() -> void:
	
	if index < DIALOGS.size() :
		var texture = load(DIALOGS[index]["texture"])
		texture_rect.texture = texture
		current_full_text = DIALOGS[index]["text"]
		display_char_length = 0
		rich_text_label.text = ""  # Réinitialise le texte
		timer.start(display_text_speed)  #
	else:
		dialog_end.emit()
		hide_dialog(true)
	

func _on_timer_timeout() -> void:
	if display_char_length < current_full_text.length():
		display_char_length += 1
	
		rich_text_label.text = current_full_text.substr(0, display_char_length)
		audio_stream_player_2d.stream = letter_sound
		if display_char_length % 2 == 0:
			audio_stream_player_2d.play()
	else:
		is_current_dialog_displayed = true
		timer.stop()
		
func _on_button_pressed() -> void:
	audio_stream_player_2d.stream = click_sound
	audio_stream_player_2d.play()
	if rich_text_label.text.length() == current_full_text.length(): 
		is_current_dialog_displayed = true
	
		index += 1 
		if index < DIALOGS.size():
			afficher_dialogue()
		else:
			dialog_end.emit()
			hide_dialog(true)
			button.disabled = true
	else:
		is_current_dialog_displayed = false
		rich_text_label.text = current_full_text
		timer.stop()

func get_dialog_index() -> int:
	return index
	
func get_is_current_dialog_displayed_value() -> bool:
	return is_current_dialog_displayed
	
func hide_dialog(should_hide: bool) -> void:
	if should_hide:
		timer.stop()
		dialog_visible = false
		dialogs.visible = false
		button.disabled = true
	else:
		is_current_dialog_displayed = false
		button.disabled = false
		rich_text_label.text = ""  # Reset text to empty string
		display_char_length = 0
		timer.start(display_text_speed)
		dialog_visible = true
		dialogs.visible = true
	
