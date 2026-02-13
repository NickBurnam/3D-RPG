extends Node
class_name HealthComponent

signal defeat()
signal health_changed()

var max_health:float
var current_health:float:
	# Define the set behavior
	set(value):
		# Clamp the minimum health to zero
		current_health = max(value,0.0)
		
		# Emit the defeat signal on death
		if current_health == 0.0:
			defeat.emit()
		
		# Always emit the health changed signal
		health_changed.emit()


func update_max_health(max_hp_in:float) -> void:
	# Update the max health to the new value
	max_health = max_hp_in
	
	# Update the current health to be full
	current_health = max_health


func take_damage(damage_in:float) -> void:
	# Subtract the damage from the current health
	current_health -= damage_in
