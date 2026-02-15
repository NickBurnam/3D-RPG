extends Control
class_name Inventory

@onready var level_label: Label = %LevelLabel
@onready var strength_value: Label = %StrengthValue
@onready var agility_value: Label = %AgilityValue
@onready var endurance_value: Label = %EnduranceValue
@onready var speed_value: Label = %SpeedValue
@onready var player:Player = get_parent().player
@onready var attack_value: Label = %AttackValue


func _ready() -> void:
	update_status()


func update_status() -> void:
	# Update the UI based on the player stats
	level_label.text = "Level %s" % player.stats.level
	strength_value.text = str(player.stats.strength.ability_score)
	agility_value.text = str(player.stats.agility.ability_score)
	endurance_value.text = str(player.stats.endurance.ability_score)
	speed_value.text = str(player.stats.speed.ability_score)


func update_gear_stats() -> void:
	# Get the current attack value
	attack_value.text = str(get_weapon_value())


func get_weapon_value() -> int:
	# Gets the current weapon's attack value
	var damage:int = 10 # ToDo: replace this value later with weapon base value
	damage += player.stats.get_base_strength()
	return damage


func _on_back_button_pressed() -> void:
	get_parent().close_menu()
