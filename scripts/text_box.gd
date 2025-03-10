extends MarginContainer

var punctuation_time = 0.01
var letter_time = 0.03
var space_time = 0.09
var letter_index: int = 0
var text: String = ""
var custom_min_size
 
func display_text(t: String):
	text = t
	$MarginContainer/Label.text = text
	await resized
	custom_minimum_size.x = min(size.x, Constants.MAX_TEXT_BOX_WIDTH)
	size.x += 50
	 
	if size.x > Constants.MAX_TEXT_BOX_WIDTH:
		$MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
		 
		await resized
		await resized
		custom_minimum_size.y = size.y
		 
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	$MarginContainer/Label.text = ""
 
	
	_display_letter()
func set_texture(texture: Texture2D):
	$Sprite2D.texture = texture
func _display_letter():
	$MarginContainer/Label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		Signals.text_display_finished.emit()
		return
	match text[letter_index]:
		"!", "?", ".", ",":
			await get_tree().create_timer(punctuation_time).timeout
		" ":
			await get_tree().create_timer(space_time).timeout
		_:
			await get_tree().create_timer(letter_time).timeout
	_display_letter()
 
