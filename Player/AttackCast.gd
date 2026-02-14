extends RayCast3D


func deal_damage(damage:float, crit_chance:float) -> void:
	if not is_colliding():
		return
	
	# Check if the hit is a critical one
	var is_critical:bool = randf() <= crit_chance
	
	# Get the collider from the ID
	var collider = get_collider()
	
	# Only process if the collision is with an enemy
	if collider is Enemy:
		# Deal the damage to the enemy
		collider.health_component.take_damage(damage,is_critical)
		
		# Add the exception so that we do not hit the same enemy more than once per attack
		add_exception(collider)
