extends CharacterBody3D
class_name Enemy

@export var max_health:float = 20.0

@onready var rig: Node3D = $RigPivot/Rig
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var player_detector: ShapeCast3D = $RigPivot/Rig/PlayerDetector
@onready var area_attack: ShapeCast3D = $RigPivot/Rig/AreaAttack


func _ready() -> void:
	# Pick from the list of villager meshes
	rig.set_active_mesh(rig.villager_meshes.pick_random())
	
	# Set the max health
	health_component.update_max_health(max_health)


func _physics_process(_delta: float) -> void:
	# Only check for attacks if the enemy is not doing anything else (idle)
	if rig.is_idle():
		check_for_attacks()


func check_for_attacks() ->void:
	# Loop through all possible collisions on the layer
	for collision_id in player_detector.get_collision_count():
		# Get the collider from the ID
		var collider = player_detector.get_collider(collision_id)
		
		# Start the overhead swing animation if the collider is a player
		if collider is Player:
			rig.travel("Overhead")


func _on_health_component_defeat() -> void:
	# Play the Defeat animation
	rig.travel("Defeat")
	
	# Disable the physics collision
	collision_shape_3d.disabled = true
	set_physics_process(false)


func _on_rig_heavy_attack() -> void:
	# Deal the damage - this signals after the overhead swing animation finishes
	area_attack.deal_damage(20.0)
