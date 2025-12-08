extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var dialogs: CanvasLayer = $"."
@onready var button: Button = $Button


var DIALOGS = {} # Utilise `load` au lieu de `preload` pour charger dynamiquement
var index = 0  # Commence à 0 pour accéder au premier élément

signal dialog_started
signal dialog_end

func display_dialog(path,texture) -> void:
	dialog_started.emit()
	load_dialogs(path)
	afficher_dialogue()




func load_dialogs(path) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
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
	texture_rect.texture = DIALOGS[index]["texture"]  # 
	rich_text_label.text = DIALOGS[index]["text"]  # Accède au premier dialogue
		
func _on_button_pressed() -> void:
	index += 1
	if index < DIALOGS.size():
		afficher_dialogue()
	else:
		dialogs.hide()
		dialog_end.emit()
		button.disabled = true
		
	
