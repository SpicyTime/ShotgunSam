extends Control
@onready var music_slider: HSlider = $Sliders/Music/MusicSlider
@onready var sfx_slider: HSlider = $Sliders/SFX/SFXSlider
func save() -> Dictionary:
	var data = {
		"music_slider" : music_slider.value,
		"sfx_slider" : sfx_slider.value
	}
	return data
func _ready() ->void:
	SettingsData.load_settings()
	music_slider.value = SettingsData.music_slider_val
	#print(SettingsData.music_slider_val)
	sfx_slider.value = SettingsData.sfx_slider_val
	#print(SettingsData.sfx_slider_val)
func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsData.sfx_slider_val = value
	var bus_index = AudioServer.get_bus_index("SFX")
	var db_value = lerp(-80, 0, value / 100)
	AudioServer.set_bus_volume_db(bus_index, db_value)

func _on_music_slider_value_changed(value: float) -> void:
	SettingsData.music_slider_val = value
	var bus_index = AudioServer.get_bus_index("Music")
	var db_value = lerp(-80, 0, value / 100)
	AudioServer.set_bus_volume_db(bus_index, db_value)
	
func _on_back_to_menu_button_pressed() -> void:
	SettingsData.save_settings()
	get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")
	 



 
