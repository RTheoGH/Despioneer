extends RigidBody2D

var orbites : Dictionary
# Structure du dictionnaire : {"nom_planete" : [force_g, position, lore]} 

# On réintroduit "velocity" pour que l'inspecteur et les autres scripts 
# puissent continuer à l'utiliser sans planter
@export var velocity := Vector2(200.0, 0.0)

var in_range_sun = false
var sun : Area2D
var is_dead := false

var current_points = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$propulseur.play()
	get_node("Label").visible = false
	sun = get_parent().get_parent().get_node("Soleil")
	
	# On désactive la gravité globale du projet pour ce vaisseau
	gravity_scale = 0.0
	
	# On applique la valeur reçue dans 'velocity' à la vraie propriété physique
	linear_velocity = velocity

# On utilise _physics_process pour tout ce qui concerne la physique et les forces
func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	
	# On calcule la somme des forces gravitationnelles des planètes à portée
	var attraction = calculate_attractions()
	
	# On applique cette force combinée sur le vaisseau
	apply_central_force(attraction)
	
	# On aligne l'angle du vaisseau avec sa trajectoire actuelle (vecteur vitesse)
	if linear_velocity.length_squared() > 1.0:
		rotation = linear_velocity.angle()
		
	get_node("Label").rotation = -rotation

# Itère à travers orbites et ajoute leurs influences à la force principale
func calculate_attractions() -> Vector2:
	var force = Vector2(0.0, 0.0) 
	
	var dir_sun = (sun.global_position - global_position).normalized()
	var radius_sun = sun.get_node("GraviteArea/CollisionShape2D").shape.radius
	#var force_sun = dir_sun * sun.mass * 0.1 / global_position.distance_to(sun.global_position)
	var force_sun = dir_sun \
		* (radius_sun - global_position.distance_to(sun.global_position))
	
	if in_range_sun:
		force += force_sun
	
	for i in orbites.keys():
		var orbite = orbites[i]
		# orbite[1] correspond à la position de la planète
		var dir = (orbite[1] - global_position).normalized()
		# orbite[0] correspond à l'intensité de la gravité de cette planète
		force += dir * orbite[0] 
		
	return force


# Ajoute l'orbite traversée au dictionnaire "orbites" avec le nom en clé et les infos en valeurs
func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Morts"):
		var text : String
		if area.name == "Soleil":
			is_dead = true
			linear_velocity = Vector2.ZERO
			#freeze = true
			text = "Space ship vaporized..."
			PlayerInfo.set_score(int(PlayerInfo.score/2.0))
			$plouf.play()
			$plouf_parts.emitting = true
			$Mbappe.visible = false
			await $plouf.finished
		elif area.name == "Borders":
			text = "Space ship lost..."
		else:
			text = "Space ship destroyed..."
		
		get_parent().call_deferred("delete_ship", text)
		#get_parent().delete_ship(text)
		
	if area.is_in_group("Speedrun"):
		PlayerInfo.set_score(99999)
		get_parent().get_parent().explode_earth()
		
		get_parent().call_deferred("delete_ship", "Humanity destroyed !")
		#get_parent().delete_ship("Humanity destroyed !")
		
		PlayerInfo.reset_game()
		
	var parent = area.get_parent()
	
	if parent.is_in_group("Planetes"):
		var info = parent.get_info()
		orbites[info[0]] = [info[1], info[2], info[3]]
	elif parent.is_in_group("Destructibles"):
		current_points = parent.hit()
		
		if current_points != null and current_points > 0:
			print(current_points)
			
			$point_timer.start()
			get_node("Label").visible = true
			get_node("Label").text = "+" + str(current_points)
		
	elif parent.is_in_group("Morts"):
		in_range_sun = true

# Retire l'orbite qu'on vient de quitter
func _on_detection_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Planetes"):
		var info = parent.get_info()
		orbites.erase(info[0])
	elif parent.is_in_group("Destructibles"):
		pass


func _on_point_timer_timeout() -> void:
	get_node("Label").visible = false
