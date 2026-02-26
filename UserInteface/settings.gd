extends Control

# Graphics Settings
@onready var scaling_3d_slider: HSlider = %Scaling3DSlider
@onready var scaling_3d_value_label: Label = %Scaling3DValueLabel
@onready var anti_aliasing_option: OptionButton = %AntiAliasingOption
@onready var v_sync_option: OptionButton = %VSyncOption
@onready var window_mode_option: OptionButton = %WindowModeOption
@onready var max_fps_h_slider: HSlider = %MaxFpsHSlider
@onready var max_fps_value_label: Label = %MaxFpsValueLabel
@onready var shadow_filter_quality_option: OptionButton = %ShadowFilterQualityOption
@onready var ssao_option: OptionButton = %SSAOOption
@onready var ssil_option: OptionButton = %SSILOption
@onready var sdfgi_option: OptionButton = %SDFGIOption
@onready var glow_option: OptionButton = %GlowOption
@onready var volumetric_fog_option: OptionButton = %VolumetricFogOption
@onready var color_adjustments_option: OptionButton = %ColorAdjustmentsOption

# Audio Settings
@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var master_volume_value_label: Label = %MasterVolumeValueLabel

# Gameplay Settings
@onready var fov_slider: HSlider = %FOVSlider
@onready var fov_value_label: Label = %FOVValueLabel


func _ready() -> void:
	# Load the user saved settings from file
	load_slider("3d_scaling", scaling_3d_slider)
	load_option_button("anti_aliasing", anti_aliasing_option)
	load_option_button("vsync", v_sync_option)
	load_option_button("window_mode", window_mode_option)
	load_slider("max_fps", max_fps_h_slider)
	load_option_button("shadow_filter_quality", shadow_filter_quality_option)
	load_option_button("ssao", ssao_option)
	load_option_button("ssil", ssil_option)
	load_option_button("sdfgi", sdfgi_option)
	load_option_button("glow", glow_option)
	load_option_button("volumetric_fog", volumetric_fog_option)
	load_option_button("color_adjustments", color_adjustments_option)
	load_slider("master_volume", master_volume_slider)
	load_slider("fov", fov_slider)
	
	# Apply the settings
	set_scaling_3d(scaling_3d_slider.value)
	set_anti_aliasing(anti_aliasing_option.selected)
	set_vsync(v_sync_option.selected)
	set_window_mode(window_mode_option.selected)
	set_max_fps(int(max_fps_h_slider.value))
	set_shadow_filter_quality(shadow_filter_quality_option.selected)
	set_ssao(ssao_option.selected)
	set_ssil(ssil_option.selected)
	set_sdfgi(sdfgi_option.selected)
	set_glow(glow_option.selected)
	set_volumetric_fog(volumetric_fog_option.selected)
	set_color_adjustments(color_adjustments_option.selected)
	set_master_volume(master_volume_slider.value)
	set_fov(fov_slider.value)


func save_setting(save_name:String, value) -> void:
	var save:FileAccess = FileAccess.open("user://" + save_name + ".txt", FileAccess.WRITE)
	save.store_string(str(value))
	save.close()


func load_slider(save_name:String, slider:HSlider) -> void:
	var save:FileAccess = FileAccess.open("user://" + save_name + ".txt", FileAccess.READ)
	if save:
		slider.value = float(save.get_as_text())
		save.close()


func load_option_button(save_name:String, option_button:OptionButton) -> void:
	var save:FileAccess = FileAccess.open("user://" + save_name + ".txt", FileAccess.READ)
	if save:
		option_button.selected = int(save.get_as_text())
		save.close()


func set_scaling_3d(value:float) -> void:
	save_setting("3d_scaling", value)
	get_viewport().scaling_3d_scale = value
	var formatted_string:String = "%.2f" % (value * 100)
	scaling_3d_value_label.text = formatted_string + "%"


func set_anti_aliasing_options(msaa:Viewport.MSAA, taa:bool, screenspace_aa:Viewport.ScreenSpaceAA) -> void:
	get_viewport().msaa_3d = msaa
	get_viewport().use_taa = taa
	get_viewport().screen_space_aa = screenspace_aa


func set_anti_aliasing(index:int) -> void:
	save_setting("anti_aliasing", index)
	match index:
		0: # None
			set_anti_aliasing_options(Viewport.MSAA_DISABLED, false, Viewport.SCREEN_SPACE_AA_DISABLED)
		1: # FXAA
			set_anti_aliasing_options(Viewport.MSAA_DISABLED, false, Viewport.SCREEN_SPACE_AA_FXAA)
		2: # TAA
			set_anti_aliasing_options(Viewport.MSAA_DISABLED, true, Viewport.SCREEN_SPACE_AA_DISABLED)
		3: # MSAA 2x
			set_anti_aliasing_options(Viewport.MSAA_2X, false, Viewport.SCREEN_SPACE_AA_DISABLED)
		4: # MSAA 4x
			set_anti_aliasing_options(Viewport.MSAA_4X, false, Viewport.SCREEN_SPACE_AA_DISABLED)
		5: # MSAA 8x
			set_anti_aliasing_options(Viewport.MSAA_8X, false, Viewport.SCREEN_SPACE_AA_DISABLED)
		_: # Default to Disabled
			set_anti_aliasing_options(Viewport.MSAA_DISABLED, false, Viewport.SCREEN_SPACE_AA_DISABLED)


func set_vsync(index:int) -> void:
	save_setting("vsync", index)
	if index == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func set_window_mode(index:int) -> void:
	save_setting("window_mode", index)
	match index:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: # Exclusive Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		_: # Default to Exclusive Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func set_max_fps(value:int) -> void:
	save_setting("max_fps", value)
	if value == 0 or value >= max_fps_h_slider.max_value:
		Engine.max_fps = 0 # Uncapped
		max_fps_value_label.text = "Unlimited"
	else:
		Engine.max_fps = value
		max_fps_value_label.text = str(value)


func set_shadow_filter_quality_options(quality:int) -> void:
	RenderingServer.directional_soft_shadow_filter_set_quality(quality) # Sunlight
	RenderingServer.positional_soft_shadow_filter_set_quality(quality) # Other lights

func set_shadow_filter_quality(index:int) -> void:
	save_setting("shadow_filter_quality", index)
	match index:
		0: # Hard
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_HARD)
		1: # Soft Very Low
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		2: # Soft Low
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		3: # Soft Medium
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		4: # Soft High
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		5: # Soft Ultra
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
		_: # Default to Hard
			set_shadow_filter_quality_options(RenderingServer.SHADOW_QUALITY_HARD)


func set_ssao(index:int) -> void:
	save_setting("ssao", index)
	GlobalSettings.set_ssao_value(index)


func set_ssil(index:int) -> void:
	save_setting("ssil", index)
	GlobalSettings.set_ssil_value(index)


func set_sdfgi(index:int) -> void:
	save_setting("sdfgi", index)
	GlobalSettings.set_sdfgi_value(index)


func set_glow(index:int) -> void:
	save_setting("glow", index)
	GlobalSettings.set_glow_value(index)


func set_volumetric_fog(index:int) -> void:
	save_setting("volumetric_fog", index)
	GlobalSettings.set_volumetric_fog_value(index)


func set_color_adjustments(index:int) -> void:
	save_setting("color_adjustments", index)
	GlobalSettings.set_color_adjustment_value(index)


func set_master_volume(value:float) -> void:
	save_setting("master_volume", value)
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	var formatted_string:String = "%.0f" % (value * 100)
	master_volume_value_label.text = formatted_string + "%"


func set_fov(value:float) -> void:
	save_setting("fov", value)
	GlobalSettings.set_fov_value(value)
	var formatted_string:String = "%.0f" % value
	fov_value_label.text = str(formatted_string)


func _on_back_button_pressed() -> void:
	# Exit the menu
	get_parent().close_pause_menu()


func _on_scaling_3d_slider_value_changed(value: float) -> void:
	set_scaling_3d(value)


func _on_anti_aliasing_option_item_selected(index: int) -> void:
	set_anti_aliasing(index)


func _on_v_sync_option_item_selected(index: int) -> void:
	set_vsync(index)


func _on_window_mode_option_item_selected(index: int) -> void:
	set_window_mode(index)


func _on_max_fps_h_slider_value_changed(value: float) -> void:
	set_max_fps(int(value))


func _on_shadow_filter_quality_option_item_selected(index: int) -> void:
	set_shadow_filter_quality(index)


func _on_ssao_option_item_selected(index: int) -> void:
	set_ssao(index)


func _on_ssil_option_item_selected(index: int) -> void:
	set_ssil(index)


func _on_sdfgi_option_item_selected(index: int) -> void:
	set_sdfgi(index)


func _on_glow_option_item_selected(index: int) -> void:
	set_glow(index)


func _on_volumetric_fog_option_item_selected(index: int) -> void:
	set_volumetric_fog(index)


func _on_color_adjustments_option_item_selected(index: int) -> void:
	set_color_adjustments(index)


func _on_master_volume_slider_value_changed(value: float) -> void:
	set_master_volume(value)


func _on_fov_slider_value_changed(value: float) -> void:
	set_fov(value)
