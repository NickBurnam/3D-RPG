extends CenterContainer

@export var inventory:Inventory

@onready var grid_container: GridContainer = $PanelContainer/VBoxContainer/GridContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleTexture/TitleLabel

var current_container:LootContainer


func _ready() -> void:
	# Ensure the UI starts invisible
	visible = false


func close() -> void:
	# Make the UI invisible, capture the mouse for normal gameplay
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Ensure the current_container exists
	if is_instance_valid(current_container):
		# Loop through all items in the container
		for item in grid_container.get_children():
			# Disconnect the interact signal from the item
			item.interact.disconnect(pickup_item)
			
			# Remove the item from the UI grid
			grid_container.remove_child(item)
			
			# Put the item back into the current_container from the UI
			current_container.add_child(item)
			
			# Ensure the item is not visible
			item.visible = false


func open(loot:LootContainer) -> void:
	# Add toggle behavior by pressing interact again while container is open
	if visible:
		close()
	else:
		# Get the reference to the container and update the UI name
		current_container = loot
		title_label.text = loot.name.capitalize()
		
		# Loop through all the items in the container
		for item in loot.get_items():
			# Remove the item from the container
			current_container.remove_child(item)
			
			# Add the item to the UI
			grid_container.add_child(item)
			
			# Ensure the item is visible
			item.visible = true
			
			# Connect the iteract signal to the pickup function
			item.interact.connect(pickup_item)
		
		# Make the UI visible and show the mouse cursor
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func pickup_item(icon:ItemIcon) -> void:
	# Disconnect the interact signal from the item
	icon.interact.disconnect(pickup_item)
	if icon is CurrencyIcon:
		# Add currency to the gold value, no UI square in inventory
		inventory.add_currency(icon.value)
		icon.queue_free()
	else:
		# Add item to player inventory
		inventory.add_item(icon)


func _on_close_button_pressed() -> void:
	# Close the UI
	close()
