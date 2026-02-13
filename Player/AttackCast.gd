extends RayCast3D


func deal_damage() -> void:
	if not is_colliding():
		return
	
	var collider = get_collider()
	
	# Only process if the collision is with an enemy
	if collider is Enemy:
		# Deal the damage to the enemy
		collider.health_component.take_damage(15.0)
		
		# Add the exception so that we do not hit the same enemy more than once per attack
		add_exception(collider)
