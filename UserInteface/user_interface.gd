extends Control
class_name UserInterface

@onready var level_label: Label = %LevelLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var health_label: Label = %HealthLabel
@onready var inventory: Control = $Inventory

@export var player:Player

func _unhandled_input(event: InputEvent) -> void:
	# Open/close the menu on button press
	if event.is_action_pressed("open_menu"):
		if inventory.visible:
			close_menu()
		else:
			open_menu()


func update_stats_display() -> void:
	# Update the player level as a string
	level_label.text = str(player.stats.level)
	
	# Grab the max value for the XP bar
	xp_bar.max_value = player.stats.percentage_level_up_boundary()
	
	# Grab the current XP value
	xp_bar.value = player.stats.xp
	
	# Update the inventory UI with current stats
	inventory.update_status()


func update_health() -> void:
	# Grab the max value for the player health
	health_bar.max_value = player.health_component.max_health
	
	# Grab the current Health
	health_bar.value = player.health_component.current_health
	
	# Grab the health string and update the label
	health_label.text = player.health_component.get_health_string()


func open_menu() -> void:
	# Make the inventory UI visible, pause the game, show the mouse, and update the current gear stats for the UI
	inventory.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inventory.update_gear_stats()


func close_menu() -> void:
	# Make the inventory invisible, unpause the game, capture the mouse
	inventory.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
