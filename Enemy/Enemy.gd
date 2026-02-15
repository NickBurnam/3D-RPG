extends CharacterBody3D
class_name Enemy

const RUN_VELOCITY_THRERSHOLD:float = 2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var velocity_target:Vector3 = Vector3.ZERO

@export var max_health:float = 20.0
@export var xp_value:float = 25.0
@export var crit_rate:float = 0.05
@export var speed:float = 5.0
@export var shields:Array[PackedScene]
@export var weapons:Array[PackedScene]

@onready var rig: Node3D = $RigPivot/Rig
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var player_detector: ShapeCast3D = $RigPivot/Rig/PlayerDetector
@onready var area_attack: ShapeCast3D = $RigPivot/Rig/AreaAttack
@onready var player:Player = get_tree().get_first_node_in_group("Player")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	# Pick from the list of villager meshes
	rig.set_active_mesh(rig.villager_meshes.pick_random())
	
	# Randomize the enemy gear
	rig.replace_shield(shields.pick_random())
	rig.replace_weapon(weapons.pick_random())
	
	# Set the max health
	health_component.update_max_health(max_health)


func _physics_process(delta: float) -> void:
	# Set the player position as the target
	navigation_agent_3d.target_position = player.global_position
	
	# Check if the enemy is on the floor
	if is_on_floor():
		# Clear out the previous velocity target
		velocity_target = Vector3.ZERO
		
		# Only check for attacks if the enemy is not doing anything else (idle)
		if rig.is_idle():
			# Check for and perform attacks
			check_for_attacks()
			
			if not navigation_agent_3d.is_target_reached():
				# Get the velocity target from the navigation agent and apply the enemy's speed
				velocity_target = get_local_navigation_direction() * speed
				
				# Face the enemy in the direction of travel
				orient_rig(navigation_agent_3d.get_next_path_position())
	else:
		# Add the gravity to the velocity target
		velocity_target.y -= gravity * delta
	
	# Set the navigation agent velocity to the target
	navigation_agent_3d.velocity = velocity_target


func check_for_attacks() ->void:
	# Loop through all possible collisions on the layer
	for collision_id in player_detector.get_collision_count():
		# Get the collider from the ID
		var collider = player_detector.get_collider(collision_id)
		
		# Start the overhead swing animation if the collider is a player
		if collider is Player:
			rig.travel("Overhead")
			navigation_agent_3d.avoidance_mask = 0


func orient_rig(target_position:Vector3) -> void:
	# Start at the rig height
	target_position.y = rig.global_position.y
	
	# Don't process if the target is the same as rig
	if rig.global_position.is_equal_approx(target_position):
		return
	
	# Face the rig in the target direction (+Z oriented rig)
	rig.look_at(target_position, Vector3.UP, true)


func get_local_navigation_direction() -> Vector3:
	# Get the destination
	var destination:Vector3 = navigation_agent_3d.get_next_path_position()
	
	# Compute the new vector using the difference of two vectors
	var local_destination:Vector3 = destination - global_position
	
	# Return the result normalized
	return local_destination.normalized()


func _on_health_component_defeat() -> void:
	# Increase the player xp
	player.stats.xp += xp_value
	
	# Play the Defeat animation
	rig.travel("Defeat")
	
	# Disable the physics collision
	collision_shape_3d.disabled = true
	set_physics_process(false)
	navigation_agent_3d.target_position = global_position
	navigation_agent_3d.velocity = Vector3.ZERO


func _on_rig_heavy_attack() -> void:
	# Deal the damage - this signals after the overhead swing animation finishes
	area_attack.deal_damage(20.0, crit_rate)
	
	# Reenable the avoidance bit mask (layer 1)
	navigation_agent_3d.avoidance_mask = 1


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	# Update the rig animation tree movespace to weight towards run or idle
	if safe_velocity.length() > RUN_VELOCITY_THRERSHOLD:
		rig.run_weight_target = 1.0
	else:
		rig.run_weight_target = 0.0
	
	# Update the velocity of the enemy with the final result
	velocity = safe_velocity
	
	# Perform the physics move and slide
	move_and_slide()
