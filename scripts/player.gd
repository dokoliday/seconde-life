extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var speed = 200

var screen_size
var player_blocked:bool =  false
var current_level_name:String = "spring"

func _ready():
	screen_size = get_viewport_rect().size
	if get_tree().current_scene.name != 'Hub':
		current_level_name = get_tree().current_scene.name

func _process(delta):
	var velocity = Vector2.ZERO
	
	move_and_slide()
	
	if player_blocked:
		player_sprite.animation = "stationary_front_" + current_level_name.to_lower()
		player_sprite.play()
		return
		
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
	if Input.is_action_pressed("walk_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, Vector2(screen_size.x+400,screen_size.y))
	
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
