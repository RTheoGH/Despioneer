extends Control

@onready var game : PackedScene = preload("res://scenes/game.tscn")
@onready var hs_box = $ScrollContainer/VBoxContainer
var i = 0

func _ready() -> void:
	generate_hs_tab()
	$AudioStreamPlayer2D.play()
	
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_packed(game)

func generate_hs_tab():
	if PlayerInfo.scores_sheet :
		PlayerInfo.scores_sheet.sort()
		for score in PlayerInfo.scores_sheet.keys():
			var line_scene = load("res://scenes/HighscoreLine.tscn")
			var line = line_scene.instantiate()
			line.score_name = score
			hs_box.add_child(line)
