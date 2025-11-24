extends Node2D

signal open_hub_door


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		open_hub_door.emit(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		open_hub_door.emit(false)
