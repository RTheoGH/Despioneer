extends Control

@onready var label = $Panel/Label
var score_name = ""

func _ready() -> void:
	label.text = score_name + "   -   " + str(PlayerInfo.scores_sheet[score_name])
	
	
func set_border_color(color : Color):
	$Panel.get_theme_stylebox("panel").border_color = color
