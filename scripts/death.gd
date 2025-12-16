extends CharacterBody2D

@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

var should_fight: bool = false
signal start_fight

func _process(_delta: float) -> void:
	# Only check input when player is in range and action is just pressed (not held)
	if Input.is_action_just_pressed("action") and should_fight:
		start_fight.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		animated_sprite_2d_2.visible = true
		animated_sprite_2d_2.play("default")
		should_fight = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		animated_sprite_2d_2.visible = false
		animated_sprite_2d_2.stop()
		should_fight = false
