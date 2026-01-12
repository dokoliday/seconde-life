extends Node2D

@export var speed: float = 100.0
@export var lifetime: float = 1.0
@onready var label: Label = $Label

var timer: float = 0.0

func _ready():
	visible = false  

func _process(delta):
	timer += delta
	position.y -= speed * delta  #Animation de montée
	modulate.a = 1.0 - (timer / lifetime)  # Fade-out
	if timer >= lifetime:
		queue_free()  # Supprime l'instance

func show_damage(amount: int, is_critical: bool = false):
	if label == null:
		return
	label.text = str(amount)  
	label.modulate = Color.RED  
	label.scale = Vector2(3.5, 3.5)  # Agrandit le texte
	visible = true  # Rend le pop-up visible
