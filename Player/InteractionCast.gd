extends ShapeCast3D

@export var player:Player
@export var ui:Control


func check_interactions() -> void:
	# Loop through all collisions
	for collision in get_collision_count():
		# Get the current item colliding
		var collider = get_collider(collision)
		
		#Only process LootContainer collisions
		if collider is LootContainer:
			# Show the UI for the interaction button prompt
			ui.update_interact_text("Open Chest")
			
			# Open the LootContainer UI when the interaction button is pressed
			if Input.is_action_just_pressed("interact"):
				# Pass the reference to the collider container when opening
				ui.open_loot_container(collider)
		
		# Only process Passage scene transition
		if collider is Passage:
			# Show the UI for the interaction button prompt
			ui.update_interact_text("Travel")
			
			# Trigger the scene transition when the interaction button is pressed
			if Input.is_action_just_pressed("interact"):
				collider.travel(player)
