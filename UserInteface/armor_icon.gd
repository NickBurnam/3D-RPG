extends ItemIcon
class_name ArmorIcon

@export var protection:int
@export var armor:armor_type

# Enum containing types of armor
enum armor_type {
	IRON_PLATE,
	STEEL_PLATE
}

func _ready() -> void:
	# Update the UI with the armor protection value
	stat_label.text = "+" + str(protection)
	
	# Update the UI with the armor type capitalized
	item_label.text = armor_type.keys()[armor]
	item_label.text = item_label.text.capitalize()
