extends RigidBody2D

var orbites : Dictionary

#structure du dico {"planete" : [9.0,pos,lore]} 

var initial_force := Vector2(700.0,20.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_force(initial_force)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_forces()

func apply_forces() -> void:
	#On applique la force + les gravités au vaisseau
	var force = initial_force + calculate_attractions()
	apply_central_force(force)
	
	#On ajuste la direction du vaisseau  
	var angle = initial_force.angle_to(force)
	initial_force = initial_force.rotated(angle)
	

#Ajoute l'orbite traversé au dictionaire "orbites" avec le nom en keys et les infos en values
func _on_detection_area_area_entered(area: Area2D) -> void:	
	var planete = area.get_parent()
	var info = planete.get_info()
	orbites[info[0]] = [info[1],info[2],info[3]]

#Retire l'orbite qu'on vient de quitter
func _on_detection_area_area_exited(area: Area2D) -> void:
	var planete = area.get_parent()
	var info = planete.get_info()
	orbites.erase(info[0])

#itère à travers orbites et ajoute leur influences à la force principale
func calculate_attractions() -> Vector2:
	var force = Vector2(0.0,0.0) 
	
	for i in orbites.keys():
		var orbite = orbites[i]
		var dir = (orbite[1] - global_position).normalized()
		force = (force + dir * orbite[0]) 
	return force
