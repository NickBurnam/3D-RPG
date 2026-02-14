extends Node3D

const DAMAGE_NUMBER = preload("res://Components/damage_number.tscn")

func spawn_damage_number(damage:int, color:Color, position_in:Vector3) -> void:
	# Instantiate the damage number scene
	var new_number = DAMAGE_NUMBER.instantiate()
	
	# Call the setup function to set the number, color and position
	new_number.setup(damage, color, position_in)
	
	# Add the damage number to the root node
	add_child(new_number)
