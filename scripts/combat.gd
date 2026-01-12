extends Node2D

@onready var death: AnimatedSprite2D = $Ennemy/Death
@onready var camera_2d: Camera2D = $Camera2D
@onready var player_life: TextureProgressBar = $CanvasLayer/LifeBoard/PlayerLife
@onready var death_life: TextureProgressBar = $CanvasLayer/LifeBoard/DeathLife
@onready var v_box_container: VBoxContainer = $CanvasLayer/ActionBoard/AttacksButton/VBoxContainer
@onready var player: AnimatedSprite2D = $Player
@onready var damage_popup_scene = preload("res://scenes/UI/damage_score.tscn")

# Constants
const COMBAT_DATA_PATH = "res://Json/combat_datas.json"
const SHAKE_INTENSITY = 12.0
const SHAKE_DURATION = 0.2
const SHAKE_ITERATIONS = 10


# Combat data
var combat_data: Dictionary = {}
var player_life_value: float = 0.0
var death_life_value: float = 0.0
var player_attacks_list: Array

var ennemy_should_attack:bool = false
var death_level = "death_1"


func _ready() -> void:
	death.flip_h = true
	player.animation_finished.connect(_on_animation_finished)
	load_combat_data()
	initialize_life_bars()
	

func _process(_delta: float) -> void:
	death_life.value = death_life_value
	player_life.value = player_life_value
	
	if ennemy_should_attack:
		ennemy_should_attack = false
		ennemy_attack()

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
					player_attacks_list = combat_data.characters.player.attacks
					for player_attack in player_attacks_list :
						var button = Button.new()
						button.text = player_attack
						if player_attack:
							button.pressed.connect(_on_attack_button_pressed.bind(player_attack))
						v_box_container.add_child(button)
						
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


func start_shake() -> void:
	var tween = create_tween()
	
	for i in range(SHAKE_ITERATIONS):
		var random_offset = Vector2(
			randf_range(-1, 1) * SHAKE_INTENSITY,
			randf_range(-1, 1) * SHAKE_INTENSITY
		)
		tween.tween_property(camera_2d, "offset", random_offset, SHAKE_DURATION / 20)
		tween.tween_property(camera_2d, "offset", Vector2.ZERO, SHAKE_DURATION / 5)

func _on_attacks_button_pressed() -> void:
	v_box_container.visible = !v_box_container.visible

func _on_attack_button_pressed(attackName:String):
	player.play("attack_" + combat_data.attacks.player[attackName].animation)

func _on_animation_finished() -> void:
	var anim_name = player.animation
	
	if anim_name.begins_with("attack_"):
		print("Animation d'attaque terminée : ", anim_name)
		on_attack_finished(anim_name.replace("attack_",""))

func on_death_attack_finished(attack_name):
	start_shake()
	death.flip_h = true
	player_life_value -= combat_data.attacks[death_level][attack_name].damage_full
	death.play("stationnary_fight")
	ennemy_should_attack = false
	show_damage_popup(combat_data.attacks[death_level][attack_name].damage_full,player)
	
func on_attack_finished(attack_name):
	start_shake()
	death_life_value -= combat_data.attacks.player[attack_name].damage_full
	player.play("stationnary_fight")
	show_damage_popup(combat_data.attacks['player'][attack_name].damage_full,death)

	ennemy_should_attack = true

func ennemy_attack() -> void:
	var attack = combat_data.characters[death_level].attacks[0]
	var attack_anim = combat_data.attacks[death_level][attack].animation
	death.flip_h = false
	death.play("attack_" + attack_anim)


func _on_death_animation_finished() -> void:
	var anim_name = death.animation
	if anim_name.begins_with("attack_"):
		on_death_attack_finished(anim_name.replace("attack_",""))

func show_damage_popup(amount: int, hitBody: AnimatedSprite2D):
	var popup = damage_popup_scene.instantiate()
	get_parent().add_child(popup)  # Ajoute d'abord à l'arbre de scène
	popup.position = hitBody.global_position
	
	popup.show_damage(amount, true)
