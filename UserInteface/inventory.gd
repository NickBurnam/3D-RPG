extends Control
class_name Inventory

const MIN_ARMOR_RATING:float = 0.0
const MAX_ARMOR_RATING:float = 80.0

signal armor_changed(protection:float)

@onready var level_label: Label = %LevelLabel
@onready var strength_value: Label = %StrengthValue
@onready var agility_value: Label = %AgilityValue
@onready var endurance_value: Label = %EnduranceValue
@onready var speed_value: Label = %SpeedValue
@onready var player:Player = get_parent().player
@onready var attack_value: Label = %AttackValue
@onready var armor_value: Label = %ArmorValue
@onready var item_grid: GridContainer = %ItemGrid
@onready var weapon_slot: CenterContainer = %WeaponSlot
@onready var shield_slot: CenterContainer = %ShieldSlot
@onready var armor_slot: CenterContainer = %ArmorSlot
@onready var gold_label: Label = %GoldLabel
@onready var gold:int = 0:
	set(value):
		gold = value
		
		# Update the UI label
		gold_label.text = "%s Gold" % str(gold)


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
	
	# Get the current armor value and emit the signal
	armor_value.text = str(get_armor_value())
	armor_changed.emit(get_armor_value())


func get_weapon_value() -> int:
	# Get the current weapons power
	var damage:int = 0
	if get_weapon():
		damage += get_weapon().power
	damage += player.stats.get_base_strength()
	return damage


func add_item(icon:ItemIcon) -> void:
	# Disconnect any existing signals on the item to avoid unwanted UI behavior
	for connection in icon.interact.get_connections():
		icon.interact.disconnect(connection.callable)
	
	# Reparent the item to the inventory item_grid and reconnect the interact signal
	icon.get_parent().remove_child(icon)
	item_grid.add_child(icon)
	icon.interact.connect(interact)


func add_currency(currency_in:int) -> void:
	# Currency kept as a value not as an inventory square
	gold += currency_in


func equip_item(item:ItemIcon, item_slot:CenterContainer) -> void:
	# Remove the current equipet item in the slot, add it back to the held items grid
	for child in item_slot.get_children():
		add_item(child)
	
	# Reparent the item to be equiped into the desired slot
	item.get_parent().remove_child(item)
	item_slot.add_child(item)


func interact(item:ItemIcon) -> void:
	# Handle item equiping when selected by player, replace the asset
	if item is WeaponIcon:
		equip_item(item, weapon_slot)
		get_tree().call_group("PlayerRig", "replace_weapon", item.item_model)
	if item is ArmorIcon:
		equip_item(item, armor_slot)
		get_tree().call_group("PlayerRig", "replace_armor", item.armor)
	if item is ShieldIcon:
		equip_item(item, shield_slot)
		get_tree().call_group("PlayerRig", "replace_shield", item.item_model)
	update_gear_stats()


func get_weapon() -> WeaponIcon:
	# Return the first item in the slot, there should only be 1 item, otherwise null
	if weapon_slot.get_child_count() != 1:
		return null
	return weapon_slot.get_child(0)


func get_shield() -> ShieldIcon:
	# Return the first item in the slot, there should only be 1 item, otherwise null
	if shield_slot.get_child_count() != 1:
		return null
	return shield_slot.get_child(0)


func get_armor() -> ArmorIcon:
	# Return the first item in the slot, there should only be 1 item, otherwise null
	if armor_slot.get_child_count() != 1:
		return null
	return armor_slot.get_child(0)

func get_armor_value() -> float:
	# Armor value is armor + shield protection, clamped to the defined range
	var armor:float = 0.0
	if get_armor():
		armor += get_armor().protection
	if get_shield():
		armor += get_shield().protection
	armor = clampf(armor, MIN_ARMOR_RATING, MAX_ARMOR_RATING)
	return armor
	
func _on_back_button_pressed() -> void:
	# Exit the menu
	get_parent().close_menu()
