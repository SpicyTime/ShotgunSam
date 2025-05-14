extends Control
@onready var music_slider: HSlider = $Sliders/Music/MusicSlider
@onready var sfx_slider: HSlider = $Sliders/SFX/SFXSlider
@onready var check_button: CheckButton = $CheckBox/AutoReload/CheckButton

func save() -> Dictionary:
	var audio_settings = {
		"music_slider_val" : music_slider.value,
		"sfx_slider_val" : sfx_slider.value
	}
	var gameplay_settings = {
		"auto_reload" : check_button.button_pressed
	}
	var data = {
		"audio_settings" : audio_settings,
		"gameplay_settings" : gameplay_settings
	}
	return data
func switch_scene(path: String):
	get_tree().change_scene_to_file(path)
	
func linear_to_db(value: float) -> float:
	return -80 + (value / 100 * 80)  # Squared for smoother scaling
	
func _ready() ->void:
	SettingsData.load_settings()
	music_slider.value = SettingsData.music_slider_val
	sfx_slider.value = SettingsData.sfx_slider_val
	check_button.button_pressed = SettingsData.auto_reload
	
func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsData.sfx_slider_val = value
	var bus_index = AudioServer.get_bus_index("SFX")
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_value - 28)

func _on_music_slider_value_changed(value: float) -> void:
	SettingsData.music_slider_val = value
	var bus_index = AudioServer.get_bus_index("Music")
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db_value - 45 )
	
func _on_back_to_menu_button_pressed() -> void:
	SettingsData.save_settings()
	call_deferred("switch_scene", "res://scenes/menus/main_menu.tscn")
func _on_check_button_toggled(toggled_on: bool) -> void:
	SettingsData.auto_reload = check_button.button_pressed
	
	
