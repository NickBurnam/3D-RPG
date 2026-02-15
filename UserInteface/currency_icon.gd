extends ItemIcon
class_name CurrencyIcon

@export var value:int

func _ready() -> void:
	# Update the UI with the gold value
	stat_label.text = "+" + str(value)
