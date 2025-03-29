extends Node
var sfx_slider_val: int = 50
var music_slider_val: int = 50
var auto_reload: bool = false
func save_settings():
	var save_file = FileAccess.open(Constants.SETTINGS_SAVE_PATH, FileAccess.WRITE)
	var audio_settings = {
		"sfx_slider_val" : sfx_slider_val,
		"music_slider_val" : music_slider_val
	}
	var gameplay_settings = {
		"auto_reload" : auto_reload
	}
	var settings_data = {
		"audio_settings" : audio_settings,
		"gameplay_settings" : gameplay_settings
	}
	var json_string = JSON.stringify(settings_data, "\t")
	save_file.store_string(json_string)
	save_file.close()
func load_settings():
	#save_settings()
	var save_file = FileAccess.open(Constants.SETTINGS_SAVE_PATH, FileAccess.READ)
	var json_string = save_file.get_as_text()
	save_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var save_data = json.get_data()
		var audio_settings = save_data.get("audio_settings", {}) 
		sfx_slider_val = audio_settings.get("sfx_slider_val")
		 
		music_slider_val = audio_settings.get("music_slider_val", -80)
		print(music_slider_val)
		var gameplay_settings = save_data.get("gameplay_settings")
		auto_reload = gameplay_settings.get("auto_reload")
