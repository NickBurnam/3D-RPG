extends ItemIcon
class_name WeaponIcon

@export var power:int
@export var item_model:PackedScene

func _ready() -> void:
	# Update the UI with the weapon power value
	stat_label.text = "+" + str(power)
	
	# Update the UI with the weapon name derived from the file name
	item_label.text = item_model.resource_path.get_file()
	var extension = item_model.resource_path.get_extension()
	item_label.text = item_label.text.rstrip("." + extension)
	item_label.text = item_label.text.capitalize()
