extends CanvasLayer

@export_file("*.json") var d_file: String

var path = "res://res/npc/dialogue/json/blackMale_chats.json"
var dialogue = []


func _ready():
	start()

func start():
	dialogue = load_dialogue()
	$NinePatchRect/Name.text = dialogue[0]["name"]
	$NinePatchRect/Chat.text = dialogue[0]["text"]

func load_dialogue():
	var file = FileAccess.new()
	#var file = file.open(d_file,FileAccess.READ)
	var json_obj = JSON.new()

	if file.file_exists(d_file):
		file.open(d_file, file.READ)
		#return parse_json(file.get_as_text())
		return json_obj.parse(file.get_as_text())
