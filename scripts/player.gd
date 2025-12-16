extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var speed = 200

const SCREEN_PADDING = 400
const DEFAULT_LEVEL_NAME = "spring"

# Scene name to level name mapping for special cases
const SCENE_TO_LEVEL_MAP = {
	"cine_intro": "winter"
}

var screen_size: Vector2
var player_blocked: bool = false
var current_level_name: String = DEFAULT_LEVEL_NAME

func _ready() -> void:
	screen_size = get_viewport_rect().size
	current_level_name = _get_level_name_from_scene()

func _get_level_name_from_scene() -> String:
	var scene_name = get_tree().current_scene.name
	
	# Check if there's a special mapping for this scene
	if scene_name in SCENE_TO_LEVEL_MAP:
		return SCENE_TO_LEVEL_MAP[scene_name]
	
	# For Hub, keep default level name
	if scene_name == "Hub":
		return DEFAULT_LEVEL_NAME
	
	# For other scenes, use the scene name as level name
	return scene_name

func _physics_process(_delta: float) -> void:
	if player_blocked:
		velocity = Vector2.ZERO
		player_sprite.animation = "stationary_front_" + current_level_name.to_lower()
		player_sprite.play()
		move_and_slide()
		return
	
	# Reset velocity
	velocity = Vector2.ZERO
	
	# Get input direction
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
	if Input.is_action_pressed("walk_up"):
		velocity.y -= 1

	# Normalize and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Move and handle collisions
	move_and_slide()
	
	# Clamp position to screen bounds after movement
	position = position.clamp(Vector2.ZERO, Vector2(screen_size.x + SCREEN_PADDING, screen_size.y))
	
	if velocity.x != 0:
		player_sprite.animation = "walk_right_" + current_level_name.to_lower()
		player_sprite.flip_h = velocity.x < 0
	elif velocity.y < 0:
		player_sprite.animation = "walk_up_" + current_level_name.to_lower()
	elif velocity.y > 0:
		player_sprite.animation = "walk_down_" + current_level_name.to_lower()
	else:
		if player_sprite.animation == "walk_up_" + current_level_name.to_lower() or player_sprite.animation == "stationary_back_" + current_level_name.to_lower() : 
			player_sprite.animation = "stationary_back_" + current_level_name.to_lower()
		else:
			player_sprite.animation = "stationary_front_" + current_level_name.to_lower()
		
	player_sprite.play()
	
func _on_dialogs_dialog_end() -> void:
	player_blocked = false

func _on_dialogs_dialog_started() -> void:
	player_blocked = true
