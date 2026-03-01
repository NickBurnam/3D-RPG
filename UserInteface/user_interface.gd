extends Control
class_name UserInterface

const HUD_STATE:int = 0
const INVENTORY_STATE:int = 1
const SETTINGS_STATE:int = 2
const LOOT_CONTAINER_STATE:int = 3
var current_state:int = 0

@onready var level_label: Label = %LevelLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var health_label: Label = %HealthLabel
@onready var inventory: Control = $Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_item_name: Label = %InteractItemName
@onready var loot_container_display: CenterContainer = $LootContainerDisplay
@onready var settings: Control = $Settings

@export var player:Player

func _unhandled_input(event: InputEvent) -> void:
	# Check if a loot container is open
	if loot_container_display.visible:
		current_state = LOOT_CONTAINER_STATE
	
	# State Machine
	match current_state:
		0: # HUD - Gameplay State
			if event.is_action_pressed("open_menu"):
				# Open the Inventory menu normally
				current_state = INVENTORY_STATE
				#call_deferred("open_inventory_menu")
				open_inventory_menu()
			elif event.is_action_pressed("open_pause_menu"):
				# Open the Pause menu normally
				current_state = SETTINGS_STATE
				#call_deferred("open_pause_menu")
				open_pause_menu()
		1: # Inventory state
			if event.is_action_pressed("open_menu"):
				# Close the Inventory menu normally
				current_state = HUD_STATE
				#call_deferred("close_inventory_menu")
				close_inventory_menu()
			elif event.is_action_pressed("open_pause_menu"):
				# Close the Inventory menu first
				#call_deferred("close_inventory_menu")
				close_inventory_menu()
				
				# Open the Pause menu normally
				current_state = SETTINGS_STATE
				#call_deferred("open_pause_menu")
				open_pause_menu()
		2: # Pause Menu state
			if event.is_action_pressed("open_menu"):
				# Close the Pause menu first
				#call_deferred("close_pause_menu")
				close_pause_menu()
				
				# Open the Inventory menu normally
				current_state = INVENTORY_STATE
				#call_deferred("open_inventory_menu")
				open_inventory_menu()
			elif event.is_action_pressed("open_pause_menu"):
				# Close the Pause menu normally
				current_state = HUD_STATE
				#call_deferred("close_pause_menu")
				close_pause_menu()
		3: # Loot Container state
			if event.is_action_pressed("open_menu"):
				loot_container_display.close()
				# Open the Inventory menu normally
				current_state = INVENTORY_STATE
				#call_deferred("open_inventory_menu")
				open_inventory_menu()
			elif event.is_action_pressed("open_pause_menu"):
				loot_container_display.close()
				# Open the Pause menu normally
				current_state = SETTINGS_STATE
				#call_deferred("open_pause_menu")
				open_pause_menu()
		_: # Default to HUD State
			if event.is_action_pressed("open_menu"):
				# Open the Inventory menu normally
				current_state = INVENTORY_STATE
				#call_deferred("open_inventory_menu")
				open_inventory_menu()
			elif event.is_action_pressed("open_pause_menu"):
				# Open the Pause menu normally
				current_state = SETTINGS_STATE
				#call_deferred("open_pause_menu")
				open_pause_menu()
	


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


func _visible_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func open_inventory_menu() -> void:
	# Make the inventory UI visible, pause the game, show the mouse, and update the current gear stats for the UI
	inventory.visible = true
	get_tree().paused = true
	
	# Defer mouse visible until after input finishes processing
	call_deferred("_visible_mouse")
	
	inventory.update_gear_stats()


func close_inventory_menu() -> void:
	# Change state to default HUD (harmless)
	current_state = HUD_STATE
	
	# Make the inventory invisible, unpause the game, capture the mouse
	inventory.visible = false
	get_tree().paused = false
	
	# Defer mouse capture until after input finishes processing
	call_deferred("_capture_mouse")


func open_pause_menu() -> void:
	# Make the pause menu UI visible, pause the game, show the mouse, and update the current gear stats for the UI
	settings.visible = true
	get_tree().paused = true
	
	# Defer mouse visible until after input finishes processing
	call_deferred("_visible_mouse")


func close_pause_menu() -> void:
	# Change state to default HUD (harmless)
	current_state = HUD_STATE
	
	# Make the pause menu invisible, unpause the game, capture the mouse
	settings.visible = false
	get_tree().paused = false
	
	# Defer mouse capture until after input finishes processing
	call_deferred("_capture_mouse")


func update_interact_text(text:String) -> void:
	# Restart the interaction animation with the new text
	animation_player.stop()
	animation_player.play("FadeOutText")
	interact_item_name.text = text


func open_loot_container(loot:LootContainer) -> void:
	# Open the loot container and pass the reference
	loot_container_display.open(loot)
