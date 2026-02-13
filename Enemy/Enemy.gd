extends CharacterBody3D
class_name Enemy

@export var max_health:float = 20.0

@onready var rig: Node3D = $RigPivot/Rig
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	# Pick from the list of villager meshes
	rig.set_active_mesh(rig.villager_meshes.pick_random())
	
	# Set the max health
	health_component.update_max_health(max_health)


func _on_health_component_defeat() -> void:
	# Play the Defeat animation
	rig.travel("Defeat")
	
	# Disable the physics collision
	collision_shape_3d.disabled = true
	set_physics_process(false)
