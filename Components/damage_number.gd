extends Node3D

@onready var label_3d: Label3D = $Label3D


func setup(damage:int, color:Color, position_in:Vector3) -> void:
	# avoid using label_3d until its ready
	if not is_inside_tree():
		await ready
	
	# Set the damage number text
	label_3d.text = str(damage)
	
	# Set the color using modulate
	label_3d.modulate = color
	
	# Set the world position
	global_position = position_in
