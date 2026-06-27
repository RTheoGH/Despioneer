extends Node2D


var planetes : Array[RigidBody2D]
var current_orbit_index := -1

@export var gravite := false
#@export var FORCE_GRAVITE := 1000.0

@export var sonde: RigidBody2D
@export var sonde_velocity := Vector2(200,0)

func _ready() -> void:
	sonde.linear_velocity = sonde_velocity
	for planete in get_children():
		if planete.is_in_group("Planetes"):
			planetes.append(planete)
			
	for i in planetes:
		print(i)
		
	for i in planetes.size():
		var zone = planetes[i].get_node("Gravite")
		# On passe l'index en paramètre avec Callable.bind()
		zone.body_entered.connect(_on_zone_gravite_body_entered.bind(i))
		zone.body_exited.connect(_on_zone_gravite_body_exited.bind(i))

func _physics_process(_delta: float) -> void:
	if gravite:
		_appliquer_gravite()

func _appliquer_gravite() -> void:
	if current_orbit_index == -1:
		return
	
	var cible = planetes[current_orbit_index]
	var direction = (cible.global_position - sonde.global_position).normalized()
	var distance = sonde.global_position.distance_to(cible.global_position)
	
	var force = cible.mass / max(distance * 0.1, 10)
	#var force = FORCE_GRAVITE / max(distance * 0.1, 1.0)
	
	sonde.apply_central_force(direction * force)

func _on_zone_gravite_body_entered(body: Node, index: int) -> void:
	if body == sonde:
		current_orbit_index = index
		gravite = true
		print("gravité planetes[", index, "]")

func _on_zone_gravite_body_exited(body: Node, index: int) -> void:
	if body == sonde:
		var encore_dans_zone := false
		for planete in planetes:
			if planete.get_node("Gravite").overlaps_body(sonde):
				encore_dans_zone = true
				current_orbit_index = planetes.find(planete)
				break
		
		if not encore_dans_zone:
			current_orbit_index = -1
			gravite = false
			print("pas de gravité")
#
#func _on_planete_body_entered(body: Node) -> void:
	#if body == sonde:
		#sonde.apply_central_force(Vector2(0, 0))

#func _on_sonde_body_entered(body: Node) -> void:
	#print(body)
	#if body.get_parent() in planetes:
		#print("test")
		#for i in planetes.size():
			##var area = planetes[i].get_node("Gravite")
			#if body.overlaps_body(self):
				#current_orbit_index = i
				#gravite = true
				#print("gravité planetes[", i, "]")
				#break
