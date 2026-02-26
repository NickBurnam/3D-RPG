extends Node

signal ssao_value_changed
signal ssil_value_changed
signal sdfgi_value_changed
signal glow_value_changed
signal volumetric_fog_value_changed
signal color_adjustment_enabled_value_changed
signal fov_value_changed

# Store the target Value
var ssao_enabled:int = false
var ssil_enabled:int = false
var sdfgi_enabled:int = false
var glow_enabled:int = false
var volumetric_fog_enabled:int = false
var color_adjustment_enabled:int = false
var fov:float = 75.0

func set_ssao_value(value:int) -> void:
	ssao_enabled = value
	ssao_value_changed.emit(value)

func set_ssil_value(value:int) -> void:
	ssil_enabled = value
	ssil_value_changed.emit(value)

func set_sdfgi_value(value:int) -> void:
	sdfgi_enabled = value
	sdfgi_value_changed.emit(value)

func set_glow_value(value:int) -> void:
	glow_enabled = value
	glow_value_changed.emit(value)

func set_volumetric_fog_value(value:int) -> void:
	volumetric_fog_enabled = value
	volumetric_fog_value_changed.emit(value)

func set_color_adjustment_value(value:int) -> void:
	color_adjustment_enabled = value
	color_adjustment_enabled_value_changed.emit(value)

func set_fov_value(value:float) -> void:
	fov = value
	fov_value_changed.emit(value)
