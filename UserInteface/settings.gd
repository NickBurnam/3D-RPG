extends Control

# Graphics Settings
@onready var scaling_3d_slider: HSlider = %Scaling3DSlider
@onready var scaling_3d_value_label: Label = %Scaling3DValueLabel
@onready var anti_aliasing_option: OptionButton = %AntiAliasingOption
@onready var v_sync_option: OptionButton = %VSyncOption
@onready var window_mode_option: OptionButton = %WindowModeOption
@onready var resolution_option: OptionButton = %ResolutionOption
@onready var scaling_type_option: OptionButton = %ScalingTypeOption
@onready var fsr_options_h_box_container: HBoxContainer = %FSROptionsHBoxContainer
@onready var fsr_options_option: OptionButton = %FSROptionsOption
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

# Define list of resolutions for windowed mode
var resolutions:Dictionary = {
	"3840x2160": Vector2i(3840,2160),
	"3440x1440": Vector2i(3440,1440),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x800": Vector2i(1280,800),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}

func _ready() -> void:
	# Initialize Resolution Options
	for res in resolutions.keys():
		resolution_option.add_item(res)
	
	# Set the UI scale
	get_window().content_scale_size = Vector2i(1920, 1080)
	
	# Load the user saved settings from file
	load_option_button("window_mode", window_mode_option)
	load_option_button("resolution", resolution_option)
	load_option_button("scaling_type", scaling_type_option)
	load_option_button("fsr_options", fsr_options_option)
	load_slider("3d_scaling", scaling_3d_slider)
	load_option_button("vsync", v_sync_option)
	load_slider("max_fps", max_fps_h_slider)
	load_option_button("anti_aliasing", anti_aliasing_option)
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
	set_window_mode(window_mode_option.selected)
	set_resolution(resolution_option.selected)
	set_scaling_type(scaling_type_option.selected)
	if get_viewport().scaling_3d_mode == Viewport.SCALING_3D_MODE_FSR or get_viewport().scaling_3d_mode == Viewport.SCALING_3D_MODE_FSR2:
		set_fsr_options(fsr_options_option.selected)
	set_scaling_3d(scaling_3d_slider.value)
	set_vsync(v_sync_option.selected)
	set_max_fps(int(max_fps_h_slider.value))
	set_anti_aliasing(anti_aliasing_option.selected)
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


func set_scaling_type(index:int) -> void:
	save_setting("scaling_type", index)
	var scaling_value:float = scaling_3d_slider.value
	match index:
		1: # AMD FSR 1.0
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
			fsr_options_h_box_container.visible = true
			scaling_3d_slider.editable = false
			set_fsr_options(fsr_options_option.selected)
		2: # AMD FSR 2.2
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
			fsr_options_h_box_container.visible = true
			scaling_3d_slider.editable = false
			set_fsr_options(fsr_options_option.selected)
		_: # Default to BILINEAR
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
			fsr_options_h_box_container.visible = false
			scaling_3d_slider.editable = true
			set_scaling_3d(scaling_value) # Reapply the value when switching to bilinear from FSR


func set_fsr_options(index:int) -> void:
	save_setting("fsr_options", index)
	var scaling_val:float
	match index:
		1: # Balanced - 0.59
			scaling_val = 0.59
		2: # Quality - 0.67
			scaling_val = 0.67
		3: # Ultra Quality - 0.77
			scaling_val = 0.77
		_: # Default to Performance - 0.5
			scaling_val = 0.5
	
	# Update the slider and set the value
	scaling_3d_slider.set_value_no_signal(scaling_val)
	set_scaling_3d(scaling_val)


func update_scaling_3d_text(value:float) -> void:
	var formatted_string:String = "%.0f" % (value * 100)
	var scaled_res_string:String = str(int(round(get_window().get_size().x * value))) + "x" + str(int(round(get_window().get_size().y * value)))
	scaling_3d_value_label.text = formatted_string + "% " + scaled_res_string


func set_scaling_3d(value:float) -> void:
	save_setting("3d_scaling", value)
	GlobalSettings.set_scaling_3d(value)
	get_viewport().scaling_3d_scale = value
	update_scaling_3d_text(value)


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
			resolution_option.disabled = false
		1: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			resolution_option.disabled = true
		2: # Exclusive Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			resolution_option.disabled = true
	
	# Wait one frame before applying scaling
	await get_tree().process_frame
	
	get_viewport().scaling_3d_scale = GlobalSettings.scaling_3d
	
	# Wait one frame before applying resolution
	await get_tree().process_frame

	set_resolution(resolution_option.selected)


func set_resolution_text() -> void:
	var res_text:String = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resolution_option.set_text(res_text)
	
	update_scaling_3d_text(scaling_3d_slider.value)


func set_resolution(index:int) -> void:
	save_setting("resolution", index)
	if index >= resolutions.size():
		return
	
	var res:Vector2i = resolutions.values().get(index)
	
	# This works correctly for windowed only
	DisplayServer.window_set_size(res)
	
	# Save the value to GlobalSettings
	GlobalSettings.set_resolution(res)
	
	# Center the windows
	@warning_ignore("integer_division")
	var center_screen:Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size:Vector2i = get_window().get_size_with_decorations()
	@warning_ignore("integer_division")
	get_window().position = center_screen - window_size / 2
	
	await get_tree().process_frame
	
	set_resolution_text()


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
	# Exit the menu - automatically changes the menu state machine within
	get_parent().close_pause_menu()


func _on_scaling_3d_slider_value_changed(value: float) -> void:
	set_scaling_3d(value)


func _on_anti_aliasing_option_item_selected(index: int) -> void:
	set_anti_aliasing(index)


func _on_v_sync_option_item_selected(index: int) -> void:
	set_vsync(index)


func _on_window_mode_option_item_selected(index: int) -> void:
	set_window_mode(index)


func _on_resolution_option_item_selected(index: int) -> void:
	set_resolution(index)


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


func _on_scaling_type_option_item_selected(index: int) -> void:
	set_scaling_type(index)


func _on_fsr_optionse_option_item_selected(index: int) -> void:
	set_fsr_options(index)
