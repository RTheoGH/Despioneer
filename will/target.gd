extends Node2D

@onready var sprite = $TargetSprite
@onready var hitbox = $TargetSprite/TargetHitbox

var index:int = 0
@export var scales: Array[float]

@export var sprites: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#oriente(Vector2(300,0))
	index = randi_range(0,1)
	sprite.texture = load(sprites[index])
	sprite.scale = Vector2(scales[index]+randf_range(-0.1,0.1),scales[index]+randf_range(-0.1,0.1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#oriente(get_global_mouse_position())
	pass

func get_sprite():
	return sprite

func get_hitbox():
	return hitbox

func oriente(cible):
	var angle = rad_to_deg(get_angle_to(cible))-90
	rotate(deg_to_rad(angle))
	#sprite.look_at(cible)
