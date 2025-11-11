extends Area2D

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	

func _process(delta):

	var velocity = Vector2.ZERO # The player's movement vector.
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
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x == 0 :
		player_sprite.animation = "stationary"
		
	if velocity.x != 0:
		player_sprite.animation = "walk"
		player_sprite.flip_h = velocity.x < 0
	player_sprite.scale = Vector2(position.y/400,position.y/400)
	
	
		
	player_sprite.play()
