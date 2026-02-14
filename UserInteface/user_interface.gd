extends Control
class_name UserInterface

@onready var level_label: Label = %LevelLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var health_label: Label = %HealthLabel

@export var player:Player

func update_stats_display() -> void:
	# Update the player level as a string
	level_label.text = str(player.stats.level)
	
	# Grab the max value for the XP bar
	xp_bar.max_value = player.stats.percentage_level_up_boundary()
	
	# Grab the current XP value
	xp_bar.value = player.stats.xp


func update_health() -> void:
	# Grab the max value for the player health
	health_bar.max_value = player.health_component.max_health
	
	# Grab the current Health
	health_bar.value = player.health_component.current_health
	
	# Grab the health string and update the label
	health_label.text = player.health_component.get_health_string()
