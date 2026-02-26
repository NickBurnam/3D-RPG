extends Node3D

@onready var world_environment: WorldEnvironment = %WorldEnvironment


func _ready() -> void:
	# Connect to the global signals so we can change values live
	GlobalSettings.ssao_value_changed.connect(_on_ssao_value_changed)
	GlobalSettings.ssil_value_changed.connect(_on_ssil_value_changed)
	GlobalSettings.sdfgi_value_changed.connect(_on_sdfgi_value_changed)
	GlobalSettings.glow_value_changed.connect(_on_glow_value_changed)
	GlobalSettings.volumetric_fog_value_changed.connect(_on_volumetric_fog_value_changed)
	GlobalSettings.color_adjustment_enabled_value_changed.connect(_on_color_adjustment_enabled_value_changed)
	
	# Load in the current saved values
	set_ssao(GlobalSettings.ssao_enabled)
	set_ssil(GlobalSettings.ssil_enabled)
	set_sdfgi(GlobalSettings.sdfgi_enabled)
	set_glow(GlobalSettings.glow_enabled)
	set_volumetric_fog(GlobalSettings.volumetric_fog_enabled)
	set_color_adjustment(GlobalSettings.color_adjustment_enabled)

func set_ssao(value:bool) -> void:
	world_environment.environment.ssao_enabled = value

func set_ssil(value:bool) -> void:
	world_environment.environment.ssil_enabled = value

func set_sdfgi(value:bool) -> void:
	world_environment.environment.sdfgi_enabled = value

func set_glow(value:bool) -> void:
	world_environment.environment.glow_enabled = value

func set_volumetric_fog(value:bool) -> void:
	world_environment.environment.volumetric_fog_enabled = value

func set_color_adjustment(value:bool) -> void:
	world_environment.environment.adjustment_enabled = value


func _on_ssao_value_changed(value:bool) -> void:
	set_ssao(value)


func _on_ssil_value_changed(value:bool) -> void:
	set_ssil(value)


func _on_sdfgi_value_changed(value:bool) -> void:
	set_sdfgi(value)


func _on_glow_value_changed(value:bool) -> void:
	set_glow(value)


func _on_volumetric_fog_value_changed(value:bool) -> void:
	set_volumetric_fog(value)


func _on_color_adjustment_enabled_value_changed(value:bool) -> void:
	set_color_adjustment(value)
