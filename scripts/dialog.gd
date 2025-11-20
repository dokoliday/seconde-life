extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var next_dialog: Button = $Next_dialog
@onready var dialogs: CanvasLayer = $"."

const DIALOG_MUM_SPRING = preload("uid://dhlk6fryj6snp")

var DIALOGS = {} # Utilise `load` au lieu de `preload` pour charger dynamiquement
var index = 0  # Commence à 0 pour accéder au premier élément

signal dialog_started
signal dialog_end

func _ready() -> void:
	dialog_started.emit()
	load_dialogs()
	setImage()
	afficher_dialogue()
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setImage() -> void:
	texture_rect.texture = DIALOG_MUM_SPRING

func load_dialogs() -> void:
	var file = FileAccess.open("res://dialogs.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var res = json.parse(file.get_as_text())
		if res == OK:
			DIALOGS = json.data  # json.data est le dictionnaire parsé
		else:
			print("Erreur de parsing JSON : ", json.get_error_message())
		file.close()
	else:
		print("Erreur : Impossible d'ouvrir le fichier dialogs.json")

func afficher_dialogue() -> void:
	if DIALOGS.has("dialog_spring"):
		rich_text_label.text = DIALOGS["dialog_spring"][index]["text"]  # Accède au premier dialogue
	else:
		print("Erreur : La clé 'dialog_spring' n'existe pas dans le JSON.")
		
func _on_next_dialog_pressed() -> void:
	index += 1
	if index < DIALOGS["dialog_spring"].size():
		afficher_dialogue()
	else:
		dialogs.hide()
		dialog_end.emit()
		next_dialog.disabled = true
	
