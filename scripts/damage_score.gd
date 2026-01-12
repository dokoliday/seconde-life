extends Node2D

@export var speed: float = 1.0
@export var lifetime: float = 1.0
var timer: float = 0.0
@onready var label: Label = $Label

func _ready():
	# Trouve le nœud Label de manière sécurisée
	if not has_node("Label"):
		printerr("Erreur : Le nœud Label n'existe pas comme enfant direct.")
		return
	print(label)
	position.y -= 20  # Décalage initial
	visible = false   # Cache le pop-up au démarrage

func _process(delta):
	timer += delta
	position.y -= speed * delta  # Animation de montée
	modulate.a = 1.0 - (timer / lifetime)  # Fade-out
	if timer >= lifetime:
		print('free')
		queue_free()  # Supprime l'instance

func show_damage(amount: int, is_critical: bool = false):
	if label == null:
		printerr("Erreur : Le nœud Label n'est pas initialisé.")
		return
	label.text = str(amount)  
	print(label)
	if is_critical:
		label.modulate = Color.RED  # Rouge pour les coups critiques
		label.scale = Vector2(1.5, 1.5)  # Agrandit le texte
	visible = true  # Rend le pop-up visible
