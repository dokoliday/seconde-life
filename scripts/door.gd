extends AnimatedSprite2D

@onready var door_sprite: AnimatedSprite2D = $"."
@onready var action_icon: AnimatedSprite2D = $action_icon

var door_actionnabled:bool = false
var is_door_opened:bool =false


func _process(delta: float) -> void:
	if Input.is_action_pressed("action") and door_actionnabled:
		door_sprite.play('open')
		action_icon.visible = false
		is_door_opened = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Player" and is_door_opened == false:
		door_actionnabled = true
		action_icon.visible = true
		action_icon.play('blink') # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
		if body.name=="Player":
			door_actionnabled = false
			action_icon.visible = false
			action_icon.visible = false
			action_icon.stop()
			
