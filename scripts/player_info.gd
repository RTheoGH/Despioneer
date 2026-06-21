extends Node

var score: int = 0
var scores_sheet = {"NNN" = 00000,"NNM" = 1,"NNA" = 2}
const FILE_NAME = "user://game-data.json"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scores_sheet = load_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_score(new_score : int) -> void:
	score = new_score

func reset_game() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))

func add_score(name:String,score:int):
	scores_sheet += {name = score}

func save_game():
	var file = FileAccess.open(FILE_NAME,FileAccess.WRITE)
	file.store_string(scores_sheet)
	file = null

func load_game():
	var file = FileAccess.open(FILE_NAME,FileAccess.READ)
	if file:
		var content = file.get_as_text()
		return content
