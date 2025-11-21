extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_blocked:bool =  false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO
	
	move_and_slide()# The player's movement vector.
	
	if player_blocked:
		player_sprite.animation = "stationary_spring"
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
	
		# Gestion des animations (priorité : vertical > horizontal > stationnaire)
	if velocity.y < 0:
		player_sprite.animation = "walk_up_spring"
	elif velocity.y > 0:
		player_sprite.animation = "walk_down_spring"
	elif velocity.x != 0:
		player_sprite.animation = "walk_right_spring"
		player_sprite.flip_h = velocity.x < 0
	else:
		player_sprite.animation = "stationary_spring"
		
	player_sprite.play()
	
func _on_dialogs_dialog_end() -> void:
	player_blocked = false

func _on_dialogs_dialog_started() -> void:
	player_blocked = true
