extends Control

@onready var game : PackedScene = preload("res://scenes/game.tscn")

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_packed(game)
