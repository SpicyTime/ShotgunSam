extends Control
@onready var music_slider: HSlider = $Sliders/Music/MusicSlider
@onready var sfx_slider: HSlider = $Sliders/SFX/SFXSlider
func _ready() ->void:
	sfx_slider.value = SettingsData.sfx_volume_value
	music_slider.value = SettingsData.music_volume_value
func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsData.sfx_volume_value = value
	var bus_index = AudioServer.get_bus_index("SFX")
	var db_value = lerp(-80, 0, value / 100)
	print(db_value)
	AudioServer.set_bus_volume_db(bus_index, db_value)

func _on_music_slider_value_changed(value: float) -> void:
	SettingsData.music_volume_value = value
	var bus_index = AudioServer.get_bus_index("Music")
	var db_value = lerp(-80, 0, value / 100)
	AudioServer.set_bus_volume_db(bus_index, db_value)
	
func _on_back_to_menu_button_pressed() -> void:
	SettingsData.save()
	get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")

 
