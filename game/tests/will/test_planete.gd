extends Node2D

@export var scene : PackedScene
#var planete

var index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	#if planete:
		#planete.queue_free()
	for c in get_children():
		if c.is_in_group("Planetes"): c.queue_free()
	var planete_scene = load("res://scenes/planete.tscn")
	var planete = planete_scene.instantiate()
	if index != null : planete.index_generated = index
	add_child(planete)


#func _on_text_edit_text_set() -> void:
	#index = int($CanvasLayer/TextEdit.text)


func _on_text_edit_text_changed() -> void:
	index = int($CanvasLayer/TextEdit.text)
