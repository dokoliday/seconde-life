extends Node2D

@onready var death: AnimatedSprite2D = $Ennemy/Death
@onready var camera_2d: Camera2D = $Camera2D
@onready var player_life: TextureProgressBar = $CanvasLayer/LifeBoard/PlayerLife
@onready var death_life: TextureProgressBar = $CanvasLayer/LifeBoard/DeathLife

# Constants
const COMBAT_DATA_PATH = "res://Json/combat_datas.json"
const SHAKE_INTENSITY = 12.0
const SHAKE_DURATION = 0.2
const SHAKE_ITERATIONS = 10
const DAMAGE_PER_ATTACK = 20

# Combat data
var combat_data: Dictionary = {}
var player_life_value: float = 0.0
var death_life_value: float = 0.0

func _ready() -> void:
	death.flip_h = true
	load_combat_data()
	initialize_life_bars()

func load_combat_data() -> void:
	var file = FileAccess.open(COMBAT_DATA_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			combat_data = json.data
			# Initialize values from JSON
			if "characters" in combat_data:
				if "player" in combat_data.characters:
					player_life_value = combat_data.characters.player.health
				if "death_1" in combat_data.characters:
					death_life_value = combat_data.characters.death_1.health
		else:
			print("Erreur de parsing JSON : ", json.get_error_message())
			# Fallback values
			player_life_value = 100.0
			death_life_value = 2000.0
		file.close()
	else:
		print("Erreur : Impossible d'ouvrir le fichier combat_datas.json")
		# Fallback values
		player_life_value = 100.0
		death_life_value = 2000.0

func initialize_life_bars() -> void:
	# Set player life bar
	if "characters" in combat_data and "player" in combat_data.characters:
		var player_data = combat_data.characters.player
		player_life.max_value = player_data.max_health
		player_life.value = player_life_value
	else:
		player_life.max_value = 100.0
		player_life.value = player_life_value
	
	# Set death life bar
	if "characters" in combat_data and "death_1" in combat_data.characters:
		var death_data = combat_data.characters.death_1
		death_life.max_value = death_data.max_health
		death_life.value = death_life_value
	else:
		death_life.max_value = 2000.0
		death_life.value = death_life_value

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		start_shake()
	
	# Update life bars
	death_life.value = death_life_value
	player_life.value = player_life_value

func start_shake() -> void:
	var tween = create_tween()
	
	for i in range(SHAKE_ITERATIONS):
		var random_offset = Vector2(
			randf_range(-1, 1) * SHAKE_INTENSITY,
			randf_range(-1, 1) * SHAKE_INTENSITY
		)
		tween.tween_property(camera_2d, "offset", random_offset, SHAKE_DURATION / 20)
		tween.tween_property(camera_2d, "offset", Vector2.ZERO, SHAKE_DURATION / 5)

func _on_attack_button_pressed() -> void:
	start_shake()
	death_life_value = max(0, death_life_value - DAMAGE_PER_ATTACK)
