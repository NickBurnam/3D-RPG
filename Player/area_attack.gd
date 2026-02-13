extends ShapeCast3D


func deal_damage(damage:float) -> void:
	# Loop through all possible collisions on the layer
	for collision_id in get_collision_count():
		# Get the collider from the ID
		var collider = get_collider(collision_id)
		
		# Apply the damage to the player/enemy health component
		if collider is Player or collider is Enemy:
			collider.health_component.take_damage(damage)
