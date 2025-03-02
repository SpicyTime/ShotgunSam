extends Node
var sfx_volume_value: int = 50
var music_volume_value: int = 50

func save():
	var file = FileAccess.open(Constants.SAVE_PATH, FileAccess.WRITE)
	var save_data = {
		"sfx_volume_val" : SettingsData.sfx_volume_value,
		"music_volume_val" : SettingsData.music_volume_value
	}
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
func load_save():
	if not FileAccess.file_exists(Constants.SETTINGS_SAVE_PATH):
		print("No save file found!")
		return  # No save file, do nothing
	var file = FileAccess.open(Constants.SETTINGS_SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var save_data = json.get_data()
		sfx_volume_value = save_data.get("sfx_volume_val")
		music_volume_value = save_data.get("music_volume_val")
